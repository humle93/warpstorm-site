"""Contract tests that run without WordPress or network access."""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
PLUGIN = ROOT / "wordpress/plugins/warpstorm-ui"


class WarpstormUiContract(unittest.TestCase):
    def test_plugin_present_and_guarded(self):
        source = (PLUGIN / "warpstorm-ui.php").read_text()
        self.assertIn("Plugin Name: Warpstorm UI", source)
        self.assertIn("defined('ABSPATH')", source)
        self.assertIn("add_shortcode('warpstorm_hub'", source)
        self.assertIn("wp_enqueue_style(", source)
        self.assertIn("wp_enqueue_script(", source)

    def test_shortcode_uses_escaped_wordpress_data(self):
        source = (PLUGIN / "warpstorm-ui.php").read_text()
        for escaper in ("esc_html(", "esc_url(", "esc_attr("):
            self.assertIn(escaper, source)
        self.assertIn("'post_status' => 'publish'", source)
        self.assertIn("get_category_by_slug", source)
        self.assertIn("get_term_link", source)
        self.assertIn("is_wp_error", source)

    def test_mobile_and_accessibility(self):
        style = (PLUGIN / "assets/warpstorm-ui.css").read_text()
        js = (PLUGIN / "assets/warpstorm-ui.js").read_text()
        php = (PLUGIN / "warpstorm-ui.php").read_text()
        for expectation in (
            "@media (min-width: 640px)",
            "@media (min-width: 1024px)",
            "prefers-reduced-motion",
            ":focus-visible",
            "overflow-x: auto",
            "min-height: 44px",
        ):
            self.assertIn(expectation, style)
        for expectation in ("aria-pressed", "hidden", "wp-block-navigation__responsive-container-close"):
            self.assertIn(expectation, js)
        self.assertIn("aria-labelledby", php)
        self.assertIn("unofficial", php)

    def test_no_external_runtime_or_rewrite_of_navigation(self):
        style = (PLUGIN / "assets/warpstorm-ui.css").read_text()
        js = (PLUGIN / "assets/warpstorm-ui.js").read_text()
        self.assertNotIn("@import", style)
        self.assertNotIn("fetch(", js)
        self.assertNotIn("innerHTML", js)
        self.assertNotIn("classList.remove('is-menu-open')", js)


if __name__ == "__main__":
    unittest.main()
