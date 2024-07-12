(() => {
  // Theme switch
  const body = document.body;
  const lamp = document.getElementById("mode");
  const themeMode = localStorage.getItem("theme");
  const systemDarkModePreference = window.matchMedia("(prefers-color-scheme: dark)");

  const toggleTheme = (state) => {
    if (state === "dark") {
      localStorage.setItem("theme", "light");
      body.removeAttribute("data-theme");
    } else if (state === "light") {
      localStorage.setItem("theme", "dark");
      body.setAttribute("data-theme", "dark");
    } else {
      initTheme(state);
    }
  };
    
  if (themeMode !== "system") {
    lamp.addEventListener("click", () =>
      toggleTheme(localStorage.getItem("theme"))
    );
  } else {
    lamp.remove();
    systemDarkModePreference.addEventListener("change", e => {
      if (e.matches) {
        toggleTheme("light")
      } else {
        toggleTheme("dark")
      }
    });
  }

  // Blur the content when the menu is open
  const cbox = document.getElementById("menu-trigger");

  cbox.addEventListener("change", function () {
    const area = document.querySelector(".wrapper");
    this.checked
      ? area.classList.add("blurry")
      : area.classList.remove("blurry");
  });
})();
