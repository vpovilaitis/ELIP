<?php
/**
 * This is a sample filter plugin which will hit a lot of bots, good and bad.
 *
 * Apparently it's hard work writing an encoder for multipart/form-data,
 * so generally only the browsers bother with it, and the bots send
 * application/x-www-form-urlencoded regardless of the form's enctype
 * attribute.
 */

$wgHooks['EditFilterMerged'][] = 'AntiBot_GenericFormEncoding::onEditFilterMerged';

class AntiBot_GenericFormEncoding {
	/**
	 * @param $editPage EditPage
	 * @param $text string
	 * @param $hookError
	 * @return bool
	 */
	public static function onEditFilterMerged( $editPage, $text, &$hookError ) {
		global $wgUser;

		$header = $editPage->getArticle()->getContext()->getRequest()->getHeader( 'Content-Type' );

		if ( $header === 'application/x-www-form-urlencoded' && !$wgUser->isAllowed( 'bot' )
			&& AntiBot::trigger( __CLASS__ ) == 'fail' ) {
			return false;
		}
		return true;
	}
}
