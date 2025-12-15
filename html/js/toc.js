// ======= UncommentrchAdapter from "typesense-instantsearch-adapter";
let dictionary = {};
dictionary["01"] = "1949 - 1953";
dictionary["02"] = "1953 - 1957";
dictionary["03"] = "1957 - 1961";
dictionary["04"] = "1961 - 1965";
dictionary["05"] = "1965 - 1969";
dictionary["06"] = "1969 - 1972";
dictionary["07"] = "1972 - 1976";
dictionary["08"] = "1976 - 1980";
dictionary["09"] = "1980 - 1983";
dictionary["10"] = "1983 - 1987";
dictionary["11"] = "1987 - 1990";
dictionary["12"] = "1990 - 1994";
dictionary["13"] = "1994 - 1998";
dictionary["14"] = "1998 - 2002";
dictionary["15"] = "2002 - 2005";

// Track visited rows in session storage
var VISITED_KEY = "visited_rows";

// Get visited rows from session storage
var getVisitedRows = () => {
  try {
    var visited = sessionStorage.getItem(VISITED_KEY);
    return visited ? JSON.parse(visited) : [];
  } catch (e) {
    return [];
  }
};

// Add a row to visited list
var markRowAsVisited = (href) => {
  var visited = getVisitedRows();
  if (!visited.includes(href)) {
    visited.push(href);
    sessionStorage.setItem(VISITED_KEY, JSON.stringify(visited));
  }
};

// Check if a row has been visited
var isRowVisited = (href) => {
  return getVisitedRows().includes(href);
};

// Create the render function
var renderHits = (renderOptions, isFirstRender) => {
  var { items, widgetParams, results } = renderOptions;

  let currentAttribute = "year";
  let currentDirection = "asc";

  // Get current sort state from the search instance UI state
  var currentUiState = search.getUiState();
  var currentSortBy = currentUiState.kgparl?.sortBy || "kgparl";

  // Parse current sort from index name
  if (currentSortBy.includes("/sort/")) {
    var sortPart = currentSortBy.split("/sort/")[1];
    var [attribute, direction] = sortPart.split(":");
    currentAttribute = attribute;
    currentDirection = direction;
  }

  // Helper function to render sort indicator
  var getSortIndicator = (attribute) => {
    if (currentAttribute === attribute) {
      // Triangle pointing up for ascending, down for descending
      var directionClass =
        currentDirection === "asc"
          ? "sort-indicator-asc"
          : "sort-indicator-desc";
      return ` <span class="sort-indicator ${directionClass}"></span>`;
    }
    // Show a subtle indicator for sortable columns - matching DataTables style
    return ' <span class="sort-indicator-neutral"><span class="sort-arrow sort-arrow-up"></span><span class="sort-arrow sort-arrow-down"></span></span>';
  };

  widgetParams.container.innerHTML = `
    <table class="table table-striped table-hover" id="toc-table">
      <thead>
        <tr>
          <th data-sort-attribute="party" style="cursor: pointer; user-select: none;">Fraktion${getSortIndicator("party")}</th>
          <th data-sort-attribute="period" style="cursor: pointer; user-select: none;">Wahlperiode${getSortIndicator("period")}</th>
          <th style="cursor: default;">Titel</th>
          <th data-sort-attribute="date" style="cursor: pointer; user-select: none;">Sitzungsdatum${getSortIndicator("date")}</th>
        </tr>
      </thead>
      <tbody>
        ${items
          .map((item) => {
            var href = `${item.id}.html`;
            var visitedClass = isRowVisited(href) ? "row-visited" : "";
            return `
          <tr data-href="${href}" class="${visitedClass}" style="cursor: pointer;" title="Seite aufrufen">
              <td>${instantsearch.highlight({ attribute: "party", hit: item })}</td>
              <td>${instantsearch.highlight({ attribute: "period", hit: item })}</td>
              <td>${instantsearch.highlight({ attribute: "title", hit: item })}</td>
              <td>${instantsearch.highlight({ attribute: "date", hit: item })}</td>
            </tr>`;
          })
          .join("")}
      </tbody>
    </table>
  `;

  // Add click event listeners to sortable headers
  var headers = widgetParams.container.querySelectorAll(
    "th[data-sort-attribute]",
  );
  headers.forEach((header) => {
    header.addEventListener("click", () => {
      var attribute = header.getAttribute("data-sort-attribute");
      handleHeaderClick(attribute);
    });
  });

  // Add click event listeners to table rows
  var rows = widgetParams.container.querySelectorAll("tr[data-href]");
  rows.forEach((row) => {
    row.addEventListener("click", (e) => {
      // Don't navigate if clicking on a link or other interactive element
      if (e.target.tagName === "A" || e.target.closest("a")) {
        return;
      }
      var href = row.getAttribute("data-href");
      // Mark row as visited before navigating
      markRowAsVisited(href);
      row.classList.add("row-visited");
      window.location.href = href;
    });
  });
};

// Create the custom widget
var customHits = instantsearch.connectors.connectHits(renderHits);

window.$ = jQuery;
window.TypesenseInstantSearchAdapter = TypesenseInstantSearchAdapter;
var additionalSearchParameters = {
  query_by: "title, party, period, persons, full_text",
  sort_by: "date:asc",
  // group_by: "categories",
  // group_limit: 1
  // pinned_hits: "23:2"
};

// Allow search params to be specified in the URL, for the test suite
var urlParams = new URLSearchParams(window.location.search);
["groupBy", "groupLimit", "pinnedHits", "sortBy"].forEach((attr) => {
  if (urlParams.has(attr)) {
    additionalSearchParameters[attr] = urlParams.get(attr);
  }
});

var typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
  server: {
    connectionTimeoutSeconds: 10000,
    apiKey: TYPESENSE_CONFIG.apiKey, // Be sure to use an API key that only has search permissions, since this is exposed in the browser
    nodes: [
      {
        host: TYPESENSE_CONFIG.host,
        port: TYPESENSE_CONFIG.port,
        protocol: TYPESENSE_CONFIG.protocol,
      },
    ],
  },
  // The following parameters are directly passed to Typesense's search API endpoint.
  //  So you can pass any parameters supported by the search endpoint below.
  //  query_by is required.
  additionalSearchParameters,
});

var searchClient = typesenseInstantsearchAdapter.searchClient;
var search = instantsearch({
  searchClient,
  indexName: "kgparl",
  routing: true,
});

// ============ Begin Widget Configuration
// Function to handle header click and trigger sorting
var handleHeaderClick = (attribute) => {
  // Get current sort state from the search instance
  var currentUiState = search.getUiState();
  var currentSortBy = currentUiState.kgparl?.sortBy || "kgparl";

  let currentAttribute = "year";
  let currentDirection = "asc";

  // Parse current sort
  if (currentSortBy.includes("/sort/")) {
    var sortPart = currentSortBy.split("/sort/")[1];
    var [attr, dir] = sortPart.split(":");
    currentAttribute = attr;
    currentDirection = dir;
  }

  // Determine new direction
  let newDirection = "asc";
  if (currentAttribute === attribute) {
    // Toggle direction if clicking the same column
    newDirection = currentDirection === "asc" ? "desc" : "asc";
  }

  // varruct the index name for sorting
  var indexName = `kgparl/sort/${attribute}:${newDirection}`;

  console.log(
    "Sorting:",
    attribute,
    newDirection,
    "Current:",
    currentAttribute,
    currentDirection,
  );

  // Trigger sorting using setUiState to properly sync with InstantSearch
  search.setUiState({
    kgparl: {
      ...search.getUiState().kgparl,
      sortBy: indexName,
    },
  });
};

search.addWidgets([
  instantsearch.widgets.searchBox({
    container: "#searchbox",
    placeholder: "Durchsuche die Protokolle",
    autofocus: true,
    showReset: true,
    showSubmit: false,
    cssClasses: {
      input: "form-control",
      reset: "btn  border-bottom-0 border rounded-pill fs-3",
    },
  }),
  instantsearch.widgets.pagination({
    container: "#pagination",
    cssClasses: {
      link: "border-0 text-black fs-3",
    },
  }),

  // Hidden sortBy widget - needed for programmatic sorting via setUiState
  instantsearch.widgets.sortBy({
    container: document.createElement('div'), // Hidden container
    items: [
      { label: "Jahr", value: "kgparl" },
      { label: "Jahr absteigend", value: "kgparl/sort/year:desc" },
      { label: "Wahlperiode", value: "kgparl/sort/period:asc" },
      { label: "Wahlperiode absteigend", value: "kgparl/sort/period:desc" },
      { label: "Fraktion", value: "kgparl/sort/party:asc" },
      { label: "Fraktion absteigend", value: "kgparl/sort/party:desc" },
      { label: "Datum", value: "kgparl/sort/date:asc" },
      { label: "Datum absteigend", value: "kgparl/sort/date:desc" },
    ],
  }),

  instantsearch.widgets.refinementList({
    container: document.querySelector("#period-list"),
    attribute: "period",
    operator: "or",
    showMore: false,
    limit: 15,
    showMoreLimit: 20,
    sortBy: function (a, b) {
      // Sort by integer value of the label (e.g., "01" -> 1, "15" -> 15)
      return parseInt(a.name, 10) - parseInt(b.name, 10);
    },
    templates: {
      item(data) {
        var { label, value, count, isRefined, cssClasses } = data;
        // Transform the label here: remove leading zeros and add ". WP"
        var numericLabel = parseInt(label, 10);
        var displayLabel = isNaN(numericLabel) ? label : numericLabel;
        displayLabel = `${displayLabel}. WP (${dictionary[label] || ""})`;
        return `
          <label class="${cssClasses.label}">
            <input type="checkbox"
                   class="${cssClasses.checkbox}"
                   value="${value}"
                   ${isRefined ? "checked" : ""} />
            <span class="d-flex px-2 align-items-center text-black">${displayLabel}</span>
            <span class="${cssClasses.count}">${count}</span>
          </label>
        `;
      },
      showMoreText: ({ isShowingMore }, { html }) => {
        return isShowingMore ? html`Weniger anzeigen…` : html`Mehr anzeigen…`;
      },
    },

    cssClasses: {
      searchableInput: "form-control form-control-sm mb-2",
      searchableSubmit: "d-none",
      searchableReset: "d-none",
      showMore: "btn btn-primary btn-sm",
      list: "list-unstyled",
      count: "badge counter ms-auto",
      label: "d-flex px-2 align-items-center text-black mb-1 me-4",
      checkbox: "mr-2",
    },
  }),
  instantsearch.widgets.clearRefinements({
    container: "#clear-refinements",
    templates: {
      resetLabel: "Filter zurücksetzen",
    },
    cssClasses: {
      button: "btn btn-primary",
    },
  }),
  /*instantsearch.widgets.currentRefinements({
    container: "#current-refinements",
    cssClasses: {
      delete: "btn",
      label: "badge",
    },
  }),*/
  instantsearch.widgets.refinementList({
    container: "#person-list",
    attribute: "persons",
    searchable: true,
    searchablePlaceholder: "Suche nach Personen",
    searchableIsAlwaysActive: true,
    operator: "and",
    showMore: true,
    showMoreLimit: 100,
    cssClasses: {
      searchableInput: "form-control form-control-sm mb-2",
      searchableSubmit: "d-none",
      searchableReset: "d-none",
      showMore: "btn btn-primary btn-sm",
      list: "list-unstyled",
      count: "badge counter ms-auto",
      label: "d-flex px-2 align-items-center mb-1 me-4 text-black",
      checkbox: "mr-2",
    },
    templates: {
      showMoreText: ({ isShowingMore }, { html }) => {
        return isShowingMore ? html`Weniger anzeigen…` : html`Mehr anzeigen…`;
      },
    },
  }),
  instantsearch.widgets.refinementList({
    container: "#party-list",
    attribute: "party",
    limit: 10,
    operator: "or",
    searchableIsAlwaysActive: true,
    cssClasses: {
      searchableInput: "form-control form-control-sm mb-2",
      searchableSubmit: "d-none",
      searchableReset: "d-none",
      showMore: "btn btn-secondary btn-sm",
      list: "list-unstyled",
      count: "badge counter ms-auto",
      label: "d-flex px-2 align-items-center mb-1 me-4 text-black",
      checkbox: "mr-2",
    },
    templates: {
      showMoreText: ({ isShowingMore }, { html }) => {
        return isShowingMore ? html`Weniger anzeigen…` : html`Mehr anzeigen…`;
      },
    },
  }),
  instantsearch.widgets.rangeSlider({
    container: "#year-menu",
    attribute: "year",
  }),
  /* instantsearch.widgets.hits({
    container: "#hits",
    templates: {
      empty:
        "<tr><td class='text-center mt-5'><h3>Keine Treffer gefunden</h3></td></tr>",
      item: `
          <tr>
          <td>
            <div class="hit-description">
              <p><a href="{{id}}.html" class="kgparl-link">{{title}}</a></p>
            </div>
            <div class="hit-breadcrumb">
              <span class="badge rounded-pill m-1 bg-success"
                >{{period}}</span
              >
              <span class="badge rounded-pill m-1 bg-info"
                >{{party}}</span
              >
              <span class="badge rounded-pill m-1 bg-warning"
                >{{date}}</span
              >
            </div>
            </td>
          </tr>
        `,
    },
  }),*/
  customHits({
    container: document.querySelector("#hits"),
  }),
  instantsearch.widgets.configure({
    attributesToSnippet: ["title"],
  }),
  instantsearch.widgets.hitsPerPage({
    container: "#hits-per-page",
    items: [
      { label: "30 Treffer je Seite", value: 30, default: true },
      { label: "50 Treffer je Seite", value: 50 },
      { label: "75 Treffer je Seite", value: 75 },
      { label: "100 Treffer je Seite", value: 100 },
    ],
  }),
]);

search.start();

// ======== Autocomplete

// Helper for the render function
var renderIndexListItem = ({ hits }) => `
          <table class="autocomplete-list" >
            ${hits
              .map(
                (hit) =>
                  `<tr class="autocomplete-list-item">${instantsearch.highlight(
                    {
                      attribute: "title",
                      hit,
                    },
                  )}</tr>`,
              )
              .join("")}
  </ol >
          `;
