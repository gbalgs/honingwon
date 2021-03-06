/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the swfassist.
 *
 * The Initial Developer of the Original Code is
 * the BeInteractive!.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** */

package org.libspark.swfassist.swf.structures
{
	public class RGB
	{
		private var _red:uint = 0x00;
		private var _green:uint = 0x00;
		private var _blue:uint = 0x00;
		
		// UI8
		public function get red():uint
		{
			return _red;
		}
		
		public function set red(value:uint):void
		{
			_red = value;
		}
		
		// UI8
		public function get green():uint
		{
			return _green;
		}
		
		public function set green(value:uint):void
		{
			_green = value;
		}
		
		// UI8
		public function get blue():uint
		{
			return _blue;
		}
		
		public function set blue(value:uint):void
		{
			_blue = value;
		}
		
		public function fromUint(color:uint):void
		{
			red = (color >> 16) & 0xff;
			green = (color >> 8) & 0xff;
			blue = (color >> 0) & 0xff;
		}
		
		public function toUint():uint
		{
			return ((red & 0xff) << 16) | ((green & 0xff) << 8) | (blue & 0xff);
		}
	}
}