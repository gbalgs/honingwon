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

package org.libspark.swfassist.swf.tags
{
	import org.libspark.swfassist.swf.structures.SoundInfo;
	
	public class DefineButtonSound extends AbstractTag
	{
		public function DefineButtonSound(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_DEFINE_BUTTON_SOUND);
		}
		
		private var _buttonId:uint = 0;
		private var _buttonSoundChar0:uint = 0;
		private var _buttonSoundInfo0:SoundInfo = new SoundInfo();
		private var _buttonSoundChar1:uint = 0;
		private var _buttonSoundInfo1:SoundInfo = new SoundInfo();
		private var _buttonSoundChar2:uint = 0;
		private var _buttonSoundInfo2:SoundInfo = new SoundInfo();
		private var _buttonSoundChar3:uint = 0;
		private var _buttonSoundInfo3:SoundInfo = new SoundInfo();
		
		public function get buttonId():uint
		{
			return _buttonId;
		}
		
		public function set buttonId(value:uint):void
		{
			_buttonId = value;
		}
		
		public function get buttonSoundChar0():uint
		{
			return _buttonSoundChar0;
		}
		
		public function set buttonSoundChar0(value:uint):void
		{
			_buttonSoundChar0 = value;
		}
		
		public function get buttonSoundInfo0():SoundInfo
		{
			return _buttonSoundInfo0;
		}
		
		public function set buttonSoundInfo0(value:SoundInfo):void
		{
			_buttonSoundInfo0 = value;
		}
		
		public function get buttonSoundChar1():uint
		{
			return _buttonSoundChar1;
		}
		
		public function set buttonSoundChar1(value:uint):void
		{
			_buttonSoundChar1 = value;
		}
		
		public function get buttonSoundInfo1():SoundInfo
		{
			return _buttonSoundInfo1;
		}
		
		public function set buttonSoundInfo1(value:SoundInfo):void
		{
			_buttonSoundInfo1 = value;
		}
		
		public function get buttonSoundChar2():uint
		{
			return _buttonSoundChar2;
		}
		
		public function set buttonSoundChar2(value:uint):void
		{
			_buttonSoundChar2 = value;
		}
		
		public function get buttonSoundInfo2():SoundInfo
		{
			return _buttonSoundInfo2;
		}
		
		public function set buttonSoundInfo2(value:SoundInfo):void
		{
			_buttonSoundInfo2 = value;
		}
		
		public function get buttonSoundChar3():uint
		{
			return _buttonSoundChar3;
		}
		
		public function set buttonSoundChar3(value:uint):void
		{
			_buttonSoundChar3 = value;
		}
		
		public function get buttonSoundInfo3():SoundInfo
		{
			return _buttonSoundInfo3;
		}
		
		public function set buttonSoundInfo3(value:SoundInfo):void
		{
			_buttonSoundInfo3 = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitDefineButtonSound(this);
		}
	}
}