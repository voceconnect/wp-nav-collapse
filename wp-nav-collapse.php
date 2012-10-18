<?php
/*
Plugin Name: WP Nav Collapse
Plugin URI: https://github.com/voceconnect/wp-nav-collapse
Description: A brief description of the Plugin.
Version: 1.0
Author: markparolisi
Author URI: http://vocecommunications.com
License: GPL2
*/
if( !class_exists( 'WP_Nav_Collapse' ) ) {

    class WP_Nav_Collapse {

        public static function init() {
            add_action( 'admin_enqueue_scripts', array( __CLASS__, 'action_admin_enqueue_scripts' ) );
            add_action( 'admin_print_styles', array( __CLASS__, 'action_admin_print_styles' ) );
        }

        public static function action_admin_enqueue_scripts( $hook ) {
            if( 'nav-menus.php' == $hook )
                wp_enqueue_script( 'wp-nav-collapse', get_template_directory_uri() . '/plugins/menu-collapse/wp-nav-collapse.js' );
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
