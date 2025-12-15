var popups = [];
var observedBrowserCapabilities = {
  touch: false,
};

const LINK_WINDOW_TARGET = "_self";
var handleEnterDay = function (ev) {
  if (observedBrowserCapabilities.touch) {
    return;
  }
  var thisDayHasAnAssociatedPopover = ev.events.length !== 0;
  if (thisDayHasAnAssociatedPopover) {
    showExclusiveNewPopover(ev.events, ev.element, ev.date);
  }
};

var handleLeaveDay = function (ev) {
  if (observedBrowserCapabilities.touch) {
    return;
  }
  var thisDayHasAnAssociatedPopover = ev.events.length !== 0;
  if (thisDayHasAnAssociatedPopover) {
    startPopoverDestructionCountdown();
  }
};

var handleClickDay = function (ev) {
  if (observedBrowserCapabilities.touch) {
    console.log(observedBrowserCapabilities.touch);
    // Delay showing the popover slightly to avoid triggering pointer or mouse events
    // on the popover by accident; there are usually some stragglers
    window.setTimeout(() => {
      showExclusiveNewPopover(ev.events, ev.element, ev.date);
    }, 100);
  } else {
    openDateLink(ev);
  }
};

var openDateLink = function (e) {
  const dayEvents = e.events;
  console.log(dayEvents);
  if (dayEvents.length === 1) {
    const documentId = dayEvents[0].id;
    const documentUrl = mrpLogic.getDocumentUrlFromId(documentId);
    window.open(documentUrl, linkWindowTarget);
  } else if (dayEvents.length > 1) {
    showExclusiveNewPopover(dayEvents, e.element, e.date);
  }
};
var localCache = {
  data: {},
  remove: function (url) {
    delete localCache.data[url];
  },
  exist: function (url) {
    return localCache.data.hasOwnProperty(url) && localCache.data[url] !== null;
  },
  get: function (url) {
    return localCache.data[url];
  },
  set: function (url, cachedData) {
    localCache.remove(url);
    localCache.data[url] = cachedData;
  },
};

let KGParlColors = {
  Grüne: "#00FF00",
  Linke: "#FF0000",
  CDU_CSU: "#000000",
  CSU_LG: "#0080c8",
  SPD: "#FF0000",
  PDS: "#800080",
  FDP: "#FFFF00",
};

var response = KGParlData;
var result = JSON.stringify(response);
const jsonArray = JSON.parse(result);
const data = jsonArray.map((r) => ({
  id: r.id,
  startDate: new Date(r.startDate),
  endDate: new Date(r.startDate),
  fraction: r.fraktion,
  topics: r.topics,
  name: r.name,
  url: window.location.protocol + "//" + window.location.host + "/" + r.id,
  color:
    KGParlColors[r.fraktion.replace("-", "_").replace("/", "_")] || "#808080",
}));
console.log(data);

var calendar = new Calendar("#calendar", {
  language: "de",
  enableRangeSelection: true,
  minDate: new Date(1949, 07, 01),
  maxDate: new Date(1998, 12, 31),
  startYear: 1949,
  mouseOnDay: handleEnterDay,
  mouseOutDay: handleLeaveDay,
  dataSource: data,
  // Load data from js object
});
initializePopoversForJsYearCalendar("#calendar");
$("a[class='yearlink']").on("click", function () {
  calendar.setYear($(this).text());
});

// ============ Enhanced Year Navigation ============
(function() {
  const MIN_YEAR = 1949;
  const MAX_YEAR = 1998;

  // Populate year dropdown
  function populateYearDropdown() {
    const yearSelect = document.getElementById('year-select');
    if (!yearSelect) return;

    yearSelect.innerHTML = '';
    for (let year = MIN_YEAR; year <= MAX_YEAR; year++) {
      const option = document.createElement('option');
      option.value = year;
      option.textContent = year;
      yearSelect.appendChild(option);
    }

    // Set initial value to current calendar year
    yearSelect.value = calendar.getYear();
  }

  // Get current calendar year
  function getCurrentYear() {
    return calendar.getYear();
  }

  // Set calendar year and update dropdown
  function setYear(year) {
    const validYear = Math.max(MIN_YEAR, Math.min(MAX_YEAR, year));
    calendar.setYear(validYear);

    const yearSelect = document.getElementById('year-select');
    if (yearSelect) {
      yearSelect.value = validYear;
    }
  }

  // Initialize dropdown
  populateYearDropdown();

  // Year dropdown change handler
  document.getElementById('year-select').addEventListener('change', function(e) {
    const selectedYear = parseInt(e.target.value, 10);
    if (!isNaN(selectedYear)) {
      setYear(selectedYear);
    }
  });

  // Decade navigation buttons
  document.getElementById('decade-prev').addEventListener('click', function() {
    const currentYear = getCurrentYear();
    setYear(currentYear - 10);
  });

  document.getElementById('decade-next').addEventListener('click', function() {
    const currentYear = getCurrentYear();
    setYear(currentYear + 10);
  });

  // Single year navigation buttons
  document.getElementById('year-prev').addEventListener('click', function() {
    const currentYear = getCurrentYear();
    setYear(currentYear - 1);
  });

  document.getElementById('year-next').addEventListener('click', function() {
    const currentYear = getCurrentYear();
    setYear(currentYear + 1);
  });

  // Update dropdown when year changes via built-in calendar navigation
  // Listen for year changes in the calendar header
  const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      if (mutation.type === 'childList' || mutation.type === 'characterData') {
        const yearHeader = document.querySelector('.calendar-header th');
        if (yearHeader) {
          const yearMatch = yearHeader.textContent.match(/\d{4}/);
          if (yearMatch) {
            const displayedYear = parseInt(yearMatch[0], 10);
            const yearSelect = document.getElementById('year-select');
            if (yearSelect && yearSelect.value != displayedYear) {
              yearSelect.value = displayedYear;
            }
          }
        }
      }
    });
  });

  // Start observing calendar for year changes
  const calendarElement = document.getElementById('calendar');
  if (calendarElement) {
    observer.observe(calendarElement, {
      childList: true,
      subtree: true,
      characterData: true
    });
  }
})();
