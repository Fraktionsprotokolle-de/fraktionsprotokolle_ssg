
// Create the render function
var renderHits = (renderOptions, isFirstRender) => {
  var { items, widgetParams, results } = renderOptions;

  let currentAttribute = "year";
  let currentDirection = "asc";

  // Get current sort state - use results._state.index which is more reliable during rendering
  let currentIndex =
    results?._state?.index || results?.index || "kgparl";

  // Parse current sort from index name
  if (currentIndex.includes("/sort/")) {
    var sortPart = currentIndex.split("/sort/")[1];
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
          <th data-sort-attribute="title" style="cursor: pointer; user-select: none;">Titel${getSortIndicator("title")}</th>
        </tr>
      </thead>
      <tbody>
        ${items
          .map((item) =>
            // use item.reg_id and change .xml to .html
`
          <tr data-href="${item.id}.html" class="" style="cursor: pointer;" title="Seite aufrufen">

              <td>${item.title}</td>
            </tr>`)
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
  query_by: "title,  persons, full_text",
  sort_by: "title:asc",
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
  indexName: "kgparl_einleitung",
  routing: true,
});

// ============ Begin Widget Configuration
// Function to handle header click and trigger sorting
var handleHeaderClick = (attribute) => {
  // Get current sort state from the search instance
  var currentUiState = search.getUiState();
  var currentSortBy = currentUiState.kgparl?.sortBy || "kgparl";

  let currentAttribute = "title";
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
  var indexName = `kgparl_einleitung/sort/${attribute}:${newDirection}`;

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
    },
  }),
  instantsearch.widgets.pagination({
    container: "#pagination",
    cssClasses: {
      link: "border-0 text-black fs-3",
    },
  }),
  /*
  instantsearch.widgets.sortBy({
    container: "#sort-by",
    items: [
      { label: "Jahr", value: "kgparl", default: true },
      { label: "Jahr absteigend", value: "kgparl/sort/year:desc" },
      { label: "Wahlperiode", value: "kgparl/sort/period:asc" },
      { label: "Wahlperiode absteigend", value: "kgparl/sort/period:desc" },
      { label: "Fraktion", value: "kgparl/sort/party:asc" },
      { label: "Fraktion absteigend", value: "kgparl/sort/party:desc" },
      { label: "Datum", value: "kgparl/sort/date:asc" },
      { label: "Datum absteigend", value: "kgparl/sort/date:desc" },
    ],
  }),*/

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
