<?php
/**
 * Plugin Name: Warpstorm AdSense (Juno)
 * Description: Injicerer Google AdSense verification-meta + head-script (ca-pub-8388762344150338) + serverer ads.txt på warpstorm.online.
 * Version: 1.3.0
 * Author: Juno
 */

if ( ! defined( 'ABSPATH' ) ) { exit; }

// Site-ownership verification (krævet for at tilføje sitet i AdSense)
add_action( 'wp_head', function () {
	echo '<meta name="google-adsense-account" content="ca-pub-8388762344150338">' . "\n";
}, 1 );

// AdSense loader-script
add_action( 'wp_head', function () { ?>
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-8388762344150338" crossorigin="anonymous"></script>
<?php }, 2 );

// Serverer /ads.txt dynamisk (hvis ingen fysisk fil findes)
add_action( 'init', function () {
	if ( ! empty( $_SERVER['REQUEST_URI'] ) && preg_match( '#^/ads\.txt(\?|$)#', $_SERVER['REQUEST_URI'] ) ) {
		if ( ! file_exists( ABSPATH . 'ads.txt' ) ) {
			header( 'Content-Type: text/plain; charset=utf-8' );
			echo 'google.com, pub-8388762344150338, DIRECT, f08c47fec0942fa0' . "\n";
			exit;
		}
	}
}, 1 );
