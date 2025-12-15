window.$ = jQuery;
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
window.TypesenseInstantSearchAdapter = TypesenseInstantSearchAdapter;
const additionalSearchParameters = {
  query_by: "title, party, period, persons, full_text",
  sort_by: "year:asc, party:asc",
  highlight_fields: "full_text",
  // group_by: "categories",
  // group_limit: 1
  // pinned_hits: "23:2"
};
const contextLength = 35;

/**
 * Highlight a search term with context (up to 35 chars before and after)
 * @param {string} text - The text to search in
 * @param {string} searchTerm - The term to highlight
 * @param {number} contextLength - Number of characters before/after (default: 35)
 * @returns {string|null} - HTML string with <mark> tags, or null if no match
 */
function highlightWithContext(text, searchTerm, contextLength = 35) {
  // Escape special regex characters in the search term
  const escapedTerm = searchTerm.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

  // Create regex to match the search term with context
  const regex = new RegExp(`(.{0,${contextLength}})(${escapedTerm})(.{0,${contextLength}})`, 'i');

  const match = text.match(regex);

  if (!match) {
    return null; // No match found
  }

  const before = match[1];
  const term = match[2];
  const after = match[3];

  // Wrap the matched term with <mark> tags
  return `${before}<mark>${term}</mark>${after}`;
}

/**
 * Highlight ALL occurrences of a search term with context
 * @param {string} text - The text to search in
 * @param {string} searchTerm - The term to highlight
 * @param {number} contextLength - Number of characters before/after (default: 35)
 * @returns {Array} - Array of highlighted strings with <mark> tags
 */
function highlightAllWithContext(text, searchTerm, contextLength = 35) {
  const escapedTerm = searchTerm.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const globalRegex = new RegExp(escapedTerm, 'gi');
  const matches = [];
  let match;

  while ((match = globalRegex.exec(text)) !== null) {
    const matchStart = match.index;
    const matchEnd = matchStart + match[0].length;

    const beforeStart = Math.max(0, matchStart - contextLength);
    const afterEnd = Math.min(text.length, matchEnd + contextLength);

    const before = text.substring(beforeStart, matchStart);
    const term = match[0];
    const after = text.substring(matchEnd, afterEnd);

    // Add ellipsis if truncated
    const prefix = beforeStart > 0 ? '...' : '';
    const suffix = afterEnd < text.length ? '...' : '';

    matches.push({
      highlighted: `${prefix}${before}<mark>${term}</mark>${after}${suffix}`,
      before: before,
      term: term,
      after: after,
      position: matchStart
    });
  }

  return matches;
}

// Create the render function
/*
const renderHits = (renderOptions, isFirstRender) => {
  const { items, widgetParams } = renderOptions;
const h = urlParams.get("kgparl[query]");
window.query = h;
  widgetParams.container.innerHTML = `
    <table class="table table-striped table-hover" id="toc-table">
      <tbody>
        ${items
          .map(
            (item) =>
              `
                <tr class="border rounded border-1 p-2 mb-2">
                <td> 
                <div class="hit-description"><p>
                  <a href="${item.id}.html?q=${window.query}" class="kgparl-link">${item.title}</a>
                </p>
                <p>
${
  
highlightWithContext(item._highlightResult?.full_text?.value, window.query, contextLength) || ''
}
                </p>
              </div>
              <div class="hit-breadcrumb">
                <span class="badge rounded-pill m-1 bg-success"
                  >${item.period}</span
                >
                <span class="badge rounded-pill m-1 bg-info">${item.party}</span>
                <span class="badge rounded-pill m-1 bg-warning"
                  >${item.date}</span
                >
              </div>
            </td>
            </tr>`,
          )
          .join("")}
      </tbody>
    </table>
  `;
};
*/


// Allow search params to be specified in the URL, for the test suite
var urlParams = new URLSearchParams(window.location.search);



["groupBy", "groupLimit", "pinnedHits"].forEach((attr) => {
  if (urlParams.has(attr)) {
    additionalSearchParameters[attr] = urlParams.get(attr);
  }
});

const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
  server: {
    connectionTimeoutSeconds: 10000,
    apiKey: "Hu52dwsas2AdxdE", // Be sure to use an API key that only has search permissions, since this is exposed in the browser
    nodes: [
      {
        host: "typesense.testserver.stephan-makowski.de",
        port: "8108",
        protocol: "https",
      },
    ],
  },
  // The following parameters are directly passed to Typesense's search API endpoint.
  //  So you can pass any parameters supported by the search endpoint below.
  //  query_by is required.
  additionalSearchParameters,
});


const searchClient = typesenseInstantsearchAdapter.searchClient;
const search = instantsearch({
  searchClient,
  indexName: "kgparl",
  routing: true,
});

// ============ Begin Widget Configuration
search.addWidgets([
  instantsearch.widgets.searchBox({
    container: "#searchbox",
    placeholder: "Durchsuche die Protokolle",
    autofocus: true,
    showReset: true,
    searchAsYouType: false,
    showSubmit: false,
    cssClasses: {
      input: "form-control",
    },
  }),
  instantsearch.widgets.hits({
    container: "#hits",
    templates: {
      empty:
        "<tr><td class='text-center mt-5'><h3>Keine Treffer gefunden</h3></td></tr>",
      item(hit) {
                // Access the query from search.helper.state.query here
        const query = search.helper.state.query;
        return `
          <tr>
          <td>
            <div class="hit-description">
              <p><a href="${hit.id}.html?q=${query}" class="kgparl-link">${hit.title}</a></p>
            </div>
            <div class="hit-snippet">
              ${hit._snippetResult.full_text.value}
            </div>
            <div class="hit-breadcrumb">
              <span class="badge rounded-pill m-1 bg-success"
                >${hit.period}</span
              >
              <span class="badge rounded-pill m-1 bg-info"
                >${hit.party}</span
              >
              <span class="badge rounded-pill m-1 bg-warning"
                >${hit.date}</span
              >
            </div>
            </td>
          </tr>`
        },
    },    transformItems(items) {
      const currentQuery = search.helper.state.query;
      // You now have the current query string here to use or annotate hits
      return items;
    }
  }),
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
  }),

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
  instantsearch.widgets.configure({
    attributesToSnippet: ["title", "full_text"],
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
  instantsearch.widgets.configure({
    attributesToSnippet: ["title", "full_text"],
  }),

]);

search.start();

// ======== Autocomplete

// Helper for the render function
const renderIndexListItem = ({ hits }) => `
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
