<?php
/**
 * Plugin Name: Warpstorm Setup (Juno Grimdark Package)
 * Description: One-shot helper: sets Post-name permalinks + static front page and enqueues Grimdark CSS v1.1. Safe to delete after use.
 * Version: 1.0.0
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

	$front = get_page_by_path( sanitize_title( $req->get_param( 'front' ) ? $req->get_param( 'front' ) : 'forside' ) );
	if ( $front ) { update_option( 'page_on_front', $front->ID ); $out['page_on_front'] = (int) $front->ID; }

	$blog = get_page_by_path( sanitize_title( $req->get_param( 'blog' ) ? $req->get_param( 'blog' ) : 'start-her' ) );
	if ( $blog ) { update_option( 'page_for_posts', $blog->ID ); $out['page_for_posts'] = (int) $blog->ID; }

	flush_rewrite_rules( true );
	$out['rewrite_flushed'] = true;
	return rest_ensure_response( $out );
}

add_action( 'wp_enqueue_scripts', function () {
	wp_register_style( 'grimdark-v1', plugins_url( 'grimdark-v1.css', __FILE__ ), array(), '1.1' );
	wp_enqueue_style( 'grimdark-v1' );
} );

add_filter( 'body_class', function ( $classes ) {
	$classes[] = 'grim-skin';
	return $classes;
} );
