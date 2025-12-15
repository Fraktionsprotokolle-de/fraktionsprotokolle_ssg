let allPopoverContainers = [];
let popoverDestructionCountdownActive = false;
let calendarJQueryElement = undefined;

const months = [
  "Januar",
  "Februar",
  "März",
  "April",
  "Mai",
  "Juni",
  "Juli",
  "August",
  "September",
  "Oktober",
  "November",
  "Dezember",
];
const POPOVER_DESTRUCTION_GRACE_PERIOD_MS = 750;
const POPOVER_HIDE_DELAY_MS = 400;

function initializePopoversForJsYearCalendar(calendarSelector) {
  calendarJQueryElement = $(calendarSelector);
  addPopoverHoverHandlers(calendarJQueryElement);
}

function initializePopoversForHeatmapCalendar(popoverData, heatmapElement) {
  calendarJQueryElement = $(heatmapElement).parent();
  addHeatmapDayHoverHandlers(
    popoverData,
    heatmapElement,
    calendarJQueryElement,
  );
  addPopoverHoverHandlers(calendarJQueryElement);
}

function addPopoverHoverHandlers(calendarJQueryElement) {
  calendarJQueryElement.on("inserted.bs.popover", function (insertEvent) {
    // Add pointer enter and leave functions to all popover bubbles
    let target = insertEvent.currentTarget;
    var popups;
    if (target.getElementsByClassName("popover").length != 0) {
      popups = target.getElementsByClassName("popover");
    } else {
      popups = document
        .getElementsByTagName("body")[0]
        .getElementsByClassName("popover");
    }
    let popoverElements = Array.from(popups);
    popoverElements.forEach((popover) => {
      popover.addEventListener("pointerleave", function (ev) {
        if (ev.pointerType === "touch") {
          return;
        }
        removeAllPopovers();
        abortPopoverDestructionCountdown();
      });
      popover.addEventListener("pointerenter", function (ev) {
        if (ev.pointerType === "touch") {
          return;
        }
        abortPopoverDestructionCountdown();
      });
      console.log("target2");
      let childElementBoxes = Array.from(
        popover.getElementsByClassName("event-tooltip-entry"),
      );
      childElementBoxes.forEach((tooltip) => {
        tooltip.addEventListener("pointerenter", function (ev) {
          console.log("target1");
          if (ev.pointerType === "touch") {
            return;
          }
          abortPopoverDestructionCountdown();
        });
        tooltip.addEventListener("pointerup", function (ev) {
          ev.target.click();
        });
      });
    });
  });
}

function addHeatmapDayHoverHandlers(
  popoverData,
  heatmapElement,
  popoverContainer,
) {
  for (let [isoDate, { documents, jsDate }] of Object.entries(popoverData)) {
    const selector = `g > title:contains("${isoDate}")`;
    const container = $(selector).parent();
    container.on("pointerenter", (jQueryEvent) => {
      const event = jQueryEvent.originalEvent;
      if (event.pointerType === "touch") {
        return;
      }
      showExclusiveNewPopover(documents, container, jsDate);
    });
    container.on("pointerleave", (jQueryEvent) => {
      const event = jQueryEvent.originalEvent;
      if (event.pointerType === "touch") {
        return;
      }
      startPopoverDestructionCountdown();
    });
    container.on("pointerup", (jQueryEvent) => {
      const event = jQueryEvent.originalEvent;
      if (event.pointerType === "touch") {
        // Delay showing the popover slightly to avoid triggering pointer or mouse events
        // on the popover by accident; there are usually some stragglers
        setTimeout(
          () => showExclusiveNewPopover(documents, container, jsDate),
          100,
        );
      }
    });
  }
}

function showExclusiveNewPopover(mrpDocuments, dayElement, date) {
  removeAllPopovers();

  let popoverContent = createPopoverContent(mrpDocuments);
  createAndShowNewPopover(dayElement, date, popoverContent);

  abortPopoverDestructionCountdown();
}

function startPopoverDestructionCountdown() {
  window.setTimeout(function () {
    if (popoverDestructionCountdownActive) {
      removeAllPopovers();
    }
  }, POPOVER_DESTRUCTION_GRACE_PERIOD_MS);

  popoverDestructionCountdownActive = true;
}

function abortPopoverDestructionCountdown() {
  popoverDestructionCountdownActive = false;
}

function removeAllPopovers() {
  while (allPopoverContainers.length > 0) {
    let existingContainer = allPopoverContainers.pop();
    existingContainer.popover("dispose");
  }
}

function registerPopoverContainer(container) {
  allPopoverContainers.push(container);
}

function createAndShowNewPopover(dayElement, date, content) {
  const container = $(dayElement);
  const dateString = new Date(date);
  const monthIndex = dateString.getMonth();
  const monthName = months[monthIndex];
  const day = String(dateString).split(" ")[2];
  const year = dateString.getFullYear();

  const datevalue = day + ". " + monthName + " " + year;
  const title = datevalue; //dateString.toDateString();//mrpUtility.jsDateToLocaleDateString(date);
  container.popover({
    container: "body",
    trigger: "manual",
    html: true,
    title: title,
    content: content,
    delay: { hide: POPOVER_HIDE_DELAY_MS },
    boundary: "window",
    placement: "right",
  });
  registerPopoverContainer(container);
  container.popover("show");
}

function createPopoverContent(mrpDocuments) {
  if (mrpDocuments.length > 0) {
    var host = window.location.protocol + "//" + window.location.host;
    return `<div class="event-tooltip-content">
		${mrpDocuments
      .map(
        (
          doc,
        ) => `<span class="event-tooltip-entry ${doc.fraction}"  target="${LINK_WINDOW_TARGET}">
				<h4>${doc.fraction}</h4>
				<!--<span>${new Date(doc.startDate).toLocaleString()}</span>--!>
			    ${doc.topics
            .map(
              (element) =>
                `<li class="turboline"><a href="${host}/${doc.id}${element.corresp}"  style="z-index:5;" target="_new">${element.title}</a></li>`,
            )
            .join("")}
				</span>`,
      )
      .join("<br/>")}
		</div>`;
  } else {
    return null;
  }
}

function eventItemsAsListItems(items, base_url) {
  if (!items.map) {
    return "";
  } else {
    return items.map((item) => `<li>${item.name}</li>`).join("");
  }
}

document.addEventListener("pointerup", function (ev) {
  // Any click removes all popovers
  removeAllPopovers();
  abortPopoverDestructionCountdown();
});
