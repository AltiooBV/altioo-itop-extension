<?php
/**
 * @copyright   Copyright (C) 2026 Altioo
 * @license     https://www.gnu.org/licenses/agpl-3.0.html AGPL-3.0-or-later
 */

use PHPUnit\Framework\TestCase;

require_once __DIR__.'/../bootstrap.php';

/**
 * One real assertion, so `composer test:unit` proves the suite is wired up
 * rather than merely that PHPUnit starts.
 */
class ModuleVersionTest extends TestCase
{
	public function testExtensionAndDescriptorAgree(): void
	{
		$oExtension = simplexml_load_file(ALTIOO_TEMPLATE_SELFTEST_ROOT.'/extension.xml');
		$sDescriptor = (string) file_get_contents(ALTIOO_TEMPLATE_SELFTEST_ROOT.'/module.altioo-template-selftest.php');

		$this->assertStringContainsString("'altioo-template-selftest/".$oExtension->version."'", $sDescriptor);
	}
}
