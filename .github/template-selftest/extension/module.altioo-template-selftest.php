<?php
/**
 * @copyright   Copyright (C) 2026 Altioo
 * @license     https://www.gnu.org/licenses/agpl-3.0.html AGPL-3.0-or-later
 */

SetupWebPage::AddModule(
	__FILE__,
	'altioo-template-selftest/0.0.1',
	array(
		'label' => 'Template self-test',
		'category' => 'business',
		'dependencies' => array(),
		'mandatory' => false,
		'visible' => true,
		'datamodel' => array(),
		'webservice' => array(),
		'data.struct' => array(),
		'data.sample' => array(),
		'doc.manual_setup' => '',
		'doc.more_information' => 'https://github.com/AltiooBV/altioo-itop-extension',
		'settings' => array(),
	)
);
