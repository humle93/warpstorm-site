<?php
/**
 * Plugin Name: Warpstorm UI
 * Description: Mobile-first design layer and optional Workshop Hub for Warpstorm.
 * Version: 0.1.0
 * Requires at least: 6.3
 * Requires PHP: 8.0
 * Text Domain: warpstorm-ui
 */

if (!defined('ABSPATH')) {
    exit;
}

define('WARPSTORM_UI_VERSION', '0.1.0');

add_filter('body_class', static function (array $classes): array {
    if (!is_admin()) {
        $classes[] = 'warpstorm-ui';
    }
    return $classes;
});

add_action('wp_enqueue_scripts', static function (): void {
    $base = plugin_dir_url(__FILE__);
    $dir = plugin_dir_path(__FILE__);
    wp_enqueue_style(
        'warpstorm-ui',
        $base . 'assets/warpstorm-ui.css',
        [],
        (string) filemtime($dir . 'assets/warpstorm-ui.css')
    );
    wp_enqueue_script(
        'warpstorm-ui',
        $base . 'assets/warpstorm-ui.js',
        [],
        (string) filemtime($dir . 'assets/warpstorm-ui.js'),
        ['strategy' => 'defer', 'in_footer' => true]
    );
});

add_shortcode('warpstorm_hub', static function (): string {
    $sections = [
        'guides' => ['title' => 'Start Here', 'description' => 'Clear, practical guides for your first project.', 'icon' => '01'],
        'hobby'  => ['title' => 'The Workbench', 'description' => 'Build, paint and improve your miniatures.', 'icon' => '02'],
        'lore'   => ['title' => 'Original Lore', 'description' => 'Explore the independent Warpstorm universe.', 'icon' => '03'],
        'armies' => ['title' => 'Explore Armies', 'description' => 'Beginner-friendly orientation and resources.', 'icon' => '04'],
    ];
    $posts = get_posts([
        'numberposts' => 9,
        'post_type' => 'post',
        'post_status' => 'publish',
        'orderby' => 'date',
        'order' => 'DESC',
        'suppress_filters' => false,
    ]);

    ob_start();
    ?>
    <div class="ws-hub" id="warpstorm-workshop-hub">
        <section class="ws-hero" aria-labelledby="ws-hero-heading">
            <div class="ws-hero__eyebrow">THE WORKSHOP / FIELD NOTES / ORIGINAL WORLDS</div>
            <h1 id="ws-hero-heading">Build something <em>legendary.</em></h1>
            <p>Practical miniature painting, terrain and hobby guides, alongside an original grimdark universe. Start with one project. Get better with every build.</p>
            <div class="ws-actions">
                <a class="ws-button ws-button--primary" href="#ws-pathways">Explore the workshop <span aria-hidden="true">↗</span></a>
                <a class="ws-button ws-button--secondary" href="#ws-latest">Latest guides <span aria-hidden="true">↓</span></a>
            </div>
            <div class="ws-hero__meta" aria-label="Site principles"><span>Independent project</span><span>Beginner friendly</span><span>Hands-on guides</span></div>
        </section>

        <section id="ws-pathways" class="ws-section" aria-labelledby="ws-pathways-heading">
            <div class="ws-section__head"><span class="ws-kicker">EXPLORE</span><h2 id="ws-pathways-heading">Choose your path</h2></div>
            <div class="ws-pathways">
                <?php foreach ($sections as $slug => $section) :
                    $term = get_category_by_slug($slug);
                    // Never link to a non-existent archive or invent a category.
                    if (!$term) { continue; }
                    $term_url = get_term_link($term);
                    if (is_wp_error($term_url)) { continue; }
                    ?>
                    <a class="ws-pathway" href="<?php echo esc_url($term_url); ?>">
                        <span class="ws-pathway__number"><?php echo esc_html($section['icon']); ?> / <?php echo esc_html(strtoupper($slug)); ?></span>
                        <span class="ws-pathway__title"><?php echo esc_html($section['title']); ?></span>
                        <span class="ws-pathway__description"><?php echo esc_html($section['description']); ?></span>
                        <span class="ws-pathway__arrow" aria-hidden="true">↗</span>
                    </a>
                <?php endforeach; ?>
            </div>
        </section>

        <section id="ws-latest" class="ws-section" aria-labelledby="ws-latest-heading">
            <div class="ws-section__head"><span class="ws-kicker">LATEST ARTICLES</span><h2 id="ws-latest-heading">From the field</h2></div>
            <div class="ws-filters" role="group" aria-label="Filter articles by category">
                <button type="button" class="ws-filter is-active" data-ws-filter="all" aria-pressed="true">All</button>
                <?php foreach (array_keys($sections) as $slug) : ?>
                    <button type="button" class="ws-filter" data-ws-filter="<?php echo esc_attr($slug); ?>" aria-pressed="false"><?php echo esc_html(ucfirst($slug)); ?></button>
                <?php endforeach; ?>
            </div>
            <div class="ws-articles" data-ws-list>
                <?php foreach ($posts as $post) :
                    $categories = get_the_category($post->ID);
                    $slugs = array_map(static fn($cat) => $cat->slug, $categories);
                    $primary = $categories ? $categories[0]->name : 'Article';
                    $summary = get_the_excerpt($post);
                    ?>
                    <article class="ws-article" data-ws-categories="<?php echo esc_attr(implode(' ', $slugs)); ?>">
                        <div class="ws-article__meta"><span><?php echo esc_html($primary); ?></span><time datetime="<?php echo esc_attr(get_the_date('c', $post)); ?>"><?php echo esc_html(get_the_date('M j, Y', $post)); ?></time></div>
                        <h3><a href="<?php echo esc_url(get_permalink($post)); ?>"><?php echo esc_html(get_the_title($post)); ?></a></h3>
                        <p><?php echo esc_html(wp_trim_words(wp_strip_all_tags($summary), 23, '…')); ?></p>
                        <a class="ws-article__link" href="<?php echo esc_url(get_permalink($post)); ?>" aria-label="<?php echo esc_attr('Read: ' . get_the_title($post)); ?>">Read guide <span aria-hidden="true">↗</span></a>
                    </article>
                <?php endforeach; ?>
            </div>
            <p class="ws-empty" data-ws-empty hidden>No articles in this category yet. Try another filter.</p>
        </section>
        <p class="ws-notice">Warpstorm is an independent, unofficial hobby project and is not affiliated with or endorsed by Games Workshop.</p>
    </div>
    <?php
    return (string) ob_get_clean();
});

add_action('init', static function (): void {
    if (function_exists('register_block_pattern')) {
        register_block_pattern('warpstorm-ui/workshop-hub', [
            'title' => 'Warpstorm Workshop Hub',
            'description' => 'Dark mobile-first landing hub with real article categories and latest posts.',
            'categories' => ['featured'],
            'content' => '<!-- wp:shortcode -->[warpstorm_hub]<!-- /wp:shortcode -->',
        ]);
    }
});
