<?php

/*
  Plugin Name: WP Nav Collapse
  Plugin URI: https://github.com/voceconnect/wp-nav-collapse
  Description: Add togglers to the admin view for WP Nav Menus
  Version: 1.0
  Author: markparolisi, voceplatforms
  Author URI: http://vocecommunications.com
  License: GPL2
 */
if ( !class_exists( 'WP_Nav_Collapse' ) ) {

	class WP_Nav_Collapse {

		public static function init() {
			add_action( 'admin_enqueue_scripts', array( __CLASS__, 'action_admin_enqueue_scripts' ) );
			add_action( 'admin_print_styles', array( __CLASS__, 'action_admin_print_styles' ) );
		}

		/**
		 * @method plugins_url
		 * @param type $relative_path
		 * @param type $plugin_path
		 * @return string 
		 */
		public static function plugins_url( $relative_path, $plugin_path ) {
			$template_dir = get_template_directory();

			foreach (array( 'template_dir', 'plugin_path' ) as $var) {
				$$var = str_replace( '\\', '/', $$var ); // sanitize for Win32 installs
				$$var = preg_replace( '|/+|', '/', $$var );
			}
			if ( 0 === strpos( $plugin_path, $template_dir ) ) {
				$url = get_template_directory_uri();
				$folder = str_replace( $template_dir, '', dirname( $plugin_path ) );
				if ( '.' != $folder ) {
					$url .= '/' . ltrim( $folder, '/' );
				}
				if ( !empty( $relative_path ) && is_string( $relative_path ) && strpos( $relative_path, '..' ) === false ) {
					$url .= '/' . ltrim( $relative_path, '/' );
				}
				return $url;
			} else {
				return plugins_url( $relative_path, $plugin_path );
			}
		}

		public static function action_admin_enqueue_scripts( $hook ) {
			if ( 'nav-menus.php' == $hook ) {
				wp_enqueue_script( 'wp-nav-collapse', self::plugins_url( 'wp-nav-collapse.js', __FILE__ ) );
			}
		}

		public static function action_admin_print_styles() {
			echo "<style>
                a.toggler { float: left;
                            display: block !important;
                            left: 0px;
                            position: absolute;
                            margin: -35px 0 0 415px;
                            cursor: pointer;
                            padding: 10px;
                            }
                </style>";
		}

	}

	WP_Nav_Collapse::init();
}
