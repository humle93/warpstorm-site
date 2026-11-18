/* Warpstorm UI progressive enhancement: WP core owns its responsive navigation. */
(() => {
  'use strict';
  const root = document.querySelector('#warpstorm-workshop-hub');
  if (root) {
    const buttons = [...root.querySelectorAll('[data-ws-filter]')];
    const cards = [...root.querySelectorAll('[data-ws-categories]')];
    const empty = root.querySelector('[data-ws-empty]');
    const applyFilter = (filter) => {
      let visible = 0;
      for (const card of cards) {
        const terms = (card.getAttribute('data-ws-categories') || '').split(/\s+/);
        const show = filter === 'all' || terms.includes(filter);
        card.hidden = !show;
        if (show) visible++;
      }
      for (const button of buttons) {
        const selected = button.dataset.wsFilter === filter;
        button.classList.toggle('is-active', selected);
        button.setAttribute('aria-pressed', String(selected));
      }
      if (empty) empty.hidden = visible > 0;
    };
    for (const button of buttons) {
      button.addEventListener('click', () => applyFilter(button.dataset.wsFilter || 'all'));
    }
  }

  // The block-navigation overlay sometimes stays open after clicking an in-page anchor.
  // Click the native close control; don't mutate its classes or scroll locking manually.
  document.addEventListener('click', (event) => {
    if (!(event.target instanceof Element)) return;
    const link = event.target.closest('.wp-block-navigation__responsive-container.is-menu-open a[href]');
    if (!link) return;
    const overlay = link.closest('.wp-block-navigation__responsive-container');
    const close = overlay && overlay.querySelector('.wp-block-navigation__responsive-container-close');
    if (close instanceof HTMLElement) close.click();
  });
})();
