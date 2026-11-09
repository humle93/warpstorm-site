<?php
/**
 * Plugin Name: Warpstorm Setup (Juno Grimdark Package v2)
 * Description: Permalinks + static front page + Dark Industrial CSS + GTM (GTM-TJRRTLMH) + ensures indexing allowed. Safe to delete after use.
 * Version: 2.0.0
 * Author: Juno
 */

if ( ! defined( 'ABSPATH' ) ) { exit; }

add_action( 'rest_api_init', function () {
	register_rest_route( 'warpstorm/v1', '/setup', array(
		'methods'             => 'POST',
		'permission_callback' => function () { return current_user_can( 'manage_options' ); },
		'callback'            => 'wps_setup_run',
	) );
} );

function wps_setup_run( WP_REST_Request $req ) {
	$out = array();

	$target = '/%postname%/';
	if ( get_option( 'permalink_structure' ) !== $target ) {
		update_option( 'permalink_structure', $target );
		$out['permalink_structure'] = 'set';
	} else {
		$out['permalink_structure'] = 'already-set';
	}

	update_option( 'show_on_front', 'page' );
	$out['show_on_front'] = 'page';

	// Sikr at s#gemaskiner ikke blokeres
	if ( (int) get_option( 'blog_public' ) !== 1 ) {
		update_option( 'blog_public', 1 );
		$out['blog_public'] = 'set-to-1';
	} else {
		$out['blog_public'] = 'already-1';
	}

	$front = get_page_by_path( sanitize_title( $req->get_param( 'front' ) ? $req->get_param( 'front' ) : 'forside' ) );
	if ( $front ) { update_option( 'page_on_front', $front->ID ); $out['page_on_front'] = (int) $front->ID; }

	$blog = get_page_by_path( sanitize_title( $req->get_param( 'blog' ) ? $req->get_param( 'blog' ) : 'start-her' ) );
	if ( $blog ) { update_option( 'page_for_posts', $blog->ID ); $out['page_for_posts'] = (int) $blog->ID; }

	flush_rewrite_rules( true );
	$out['rewrite_flushed'] = true;
	return rest_ensure_response( $out );
}

add_action( 'wp_enqueue_scripts', function () {
	wp_register_style( 'ws-dark-industrial', plugins_url( 'dark-industrial.css', __FILE__ ), array(), '2.0' );
	wp_enqueue_style( 'ws-dark-industrial' );
} );

add_filter( 'body_class', function ( $classes ) {
	$classes[] = 'grim-skin';
	return $classes;
} );

// Google Tag Manager (script, i head)
add_action( 'wp_head', function () { ?>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-TJRRTLMH');</script>
<?php }, 1 );

// Google Tag Manager (noscript, lige efter body-tag)
add_action( 'wp_body_open', function () { ?>
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-TJRRTLMH"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<?php } );
