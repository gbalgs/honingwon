﻿/* ***** BEGIN LICENSE BLOCK *****
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

package org.libspark.swfassist.swf.io
{
	import flash.utils.ByteArray;
	
	import org.libspark.swfassist.errors.ErrorHandler;
	import org.libspark.swfassist.errors.ErrorIdConstants;
	import org.libspark.swfassist.errors.ErrorMessageConstants;
	import org.libspark.swfassist.errors.Warning;
	import org.libspark.swfassist.io.ByteArrayInputStream;
	import org.libspark.swfassist.io.DataInput;
	import org.libspark.swfassist.swf.actions.ActionRecords;
	import org.libspark.swfassist.swf.actions.UnknownAction;
	import org.libspark.swfassist.swf.filters.BevelFilter;
	import org.libspark.swfassist.swf.filters.BlurFilter;
	import org.libspark.swfassist.swf.filters.ColorMatrixFilter;
	import org.libspark.swfassist.swf.filters.ConvolutionFilter;
	import org.libspark.swfassist.swf.filters.DropShadowFilter;
	import org.libspark.swfassist.swf.filters.Filter;
	import org.libspark.swfassist.swf.filters.FilterConstants;
	import org.libspark.swfassist.swf.filters.FilterList;
	import org.libspark.swfassist.swf.filters.GlowFilter;
	import org.libspark.swfassist.swf.filters.GradientBevelFilter;
	import org.libspark.swfassist.swf.filters.GradientGlowFilter;
	import org.libspark.swfassist.swf.structures.ARGB;
	import org.libspark.swfassist.swf.structures.Asset;
	import org.libspark.swfassist.swf.structures.ButtonCondAction;
	import org.libspark.swfassist.swf.structures.ButtonRecord;
	import org.libspark.swfassist.swf.structures.CXForm;
	import org.libspark.swfassist.swf.structures.CXFormWithAlpha;
	import org.libspark.swfassist.swf.structures.ClipActionRecord;
	import org.libspark.swfassist.swf.structures.ClipActions;
	import org.libspark.swfassist.swf.structures.ClipEventFlags;
	import org.libspark.swfassist.swf.structures.CurvedEdgeRecord;
	import org.libspark.swfassist.swf.structures.FillStyle;
	import org.libspark.swfassist.swf.structures.FillStyleArray;
	import org.libspark.swfassist.swf.structures.FillStyleTypeConstants;
	import org.libspark.swfassist.swf.structures.FocalGradient;
	import org.libspark.swfassist.swf.structures.FrameLabelData;
	import org.libspark.swfassist.swf.structures.GlyphEntry;
	import org.libspark.swfassist.swf.structures.Gradient;
	import org.libspark.swfassist.swf.structures.GradientRecord;
	import org.libspark.swfassist.swf.structures.Header;
	import org.libspark.swfassist.swf.structures.JoinStyleConstants;
	import org.libspark.swfassist.swf.structures.KerningRecord;
	import org.libspark.swfassist.swf.structures.LanguageCode;
	import org.libspark.swfassist.swf.structures.LineStyle;
	import org.libspark.swfassist.swf.structures.LineStyle2;
	import org.libspark.swfassist.swf.structures.LineStyleArray;
	import org.libspark.swfassist.swf.structures.Matrix;
	import org.libspark.swfassist.swf.structures.MorphFillStyle;
	import org.libspark.swfassist.swf.structures.MorphFillStyleArray;
	import org.libspark.swfassist.swf.structures.MorphGradient;
	import org.libspark.swfassist.swf.structures.MorphGradientRecord;
	import org.libspark.swfassist.swf.structures.MorphLineStyle;
	import org.libspark.swfassist.swf.structures.MorphLineStyle2;
	import org.libspark.swfassist.swf.structures.MorphLineStyles;
	import org.libspark.swfassist.swf.structures.RGB;
	import org.libspark.swfassist.swf.structures.RGBA;
	import org.libspark.swfassist.swf.structures.Rect;
	import org.libspark.swfassist.swf.structures.SWF;
	import org.libspark.swfassist.swf.structures.SceneData;
	import org.libspark.swfassist.swf.structures.Shape;
	import org.libspark.swfassist.swf.structures.ShapeWithStyle;
	import org.libspark.swfassist.swf.structures.SoundData;
	import org.libspark.swfassist.swf.structures.SoundDataADPCM;
	import org.libspark.swfassist.swf.structures.SoundDataMP3;
	import org.libspark.swfassist.swf.structures.SoundDataMP3Stream;
	import org.libspark.swfassist.swf.structures.SoundDataNellymoser;
	import org.libspark.swfassist.swf.structures.SoundDataUncompressed;
	import org.libspark.swfassist.swf.structures.SoundEnvelope;
	import org.libspark.swfassist.swf.structures.SoundInfo;
	import org.libspark.swfassist.swf.structures.StraightEdgeRecord;
	import org.libspark.swfassist.swf.structures.StyleChangeRecord;
	import org.libspark.swfassist.swf.structures.TextRecord;
	import org.libspark.swfassist.swf.structures.ZoneData;
	import org.libspark.swfassist.swf.structures.ZoneRecord;
	import org.libspark.swfassist.swf.tags.BitmapFormatConstants;
	import org.libspark.swfassist.swf.tags.CSMTextSettings;
	import org.libspark.swfassist.swf.tags.DefineBinaryData;
	import org.libspark.swfassist.swf.tags.DefineBits;
	import org.libspark.swfassist.swf.tags.DefineBitsJPEG2;
	import org.libspark.swfassist.swf.tags.DefineBitsJPEG3;
	import org.libspark.swfassist.swf.tags.DefineBitsLossless;
	import org.libspark.swfassist.swf.tags.DefineBitsLossless2;
	import org.libspark.swfassist.swf.tags.DefineButton;
	import org.libspark.swfassist.swf.tags.DefineButton2;
	import org.libspark.swfassist.swf.tags.DefineButtonCxform;
	import org.libspark.swfassist.swf.tags.DefineButtonSound;
	import org.libspark.swfassist.swf.tags.DefineEditText;
	import org.libspark.swfassist.swf.tags.DefineFont;
	import org.libspark.swfassist.swf.tags.DefineFont2;
	import org.libspark.swfassist.swf.tags.DefineFont3;
	import org.libspark.swfassist.swf.tags.DefineFontAlignZones;
	import org.libspark.swfassist.swf.tags.DefineFontInfo;
	import org.libspark.swfassist.swf.tags.DefineFontInfo2;
	import org.libspark.swfassist.swf.tags.DefineFontName;
	import org.libspark.swfassist.swf.tags.DefineMorphShape;
	import org.libspark.swfassist.swf.tags.DefineMorphShape2;
	import org.libspark.swfassist.swf.tags.DefineScalingGrid;
	import org.libspark.swfassist.swf.tags.DefineSceneAndFrameLabelData;
	import org.libspark.swfassist.swf.tags.DefineShape;
	import org.libspark.swfassist.swf.tags.DefineShape2;
	import org.libspark.swfassist.swf.tags.DefineShape3;
	import org.libspark.swfassist.swf.tags.DefineShape4;
	import org.libspark.swfassist.swf.tags.DefineSound;
	import org.libspark.swfassist.swf.tags.DefineSprite;
	import org.libspark.swfassist.swf.tags.DefineText;
	import org.libspark.swfassist.swf.tags.DefineText2;
	import org.libspark.swfassist.swf.tags.DefineVideoStream;
	import org.libspark.swfassist.swf.tags.DoABC;
	import org.libspark.swfassist.swf.tags.DoAction;
	import org.libspark.swfassist.swf.tags.DoInitAction;
	import org.libspark.swfassist.swf.tags.EnableDebugger;
	import org.libspark.swfassist.swf.tags.EnableDebugger2;
	import org.libspark.swfassist.swf.tags.End;
	import org.libspark.swfassist.swf.tags.ExportAssets;
	import org.libspark.swfassist.swf.tags.FileAttributes;
	import org.libspark.swfassist.swf.tags.FrameLabel;
	import org.libspark.swfassist.swf.tags.ImportAssets;
	import org.libspark.swfassist.swf.tags.ImportAssets2;
	import org.libspark.swfassist.swf.tags.JPEGTables;
	import org.libspark.swfassist.swf.tags.Metadata;
	import org.libspark.swfassist.swf.tags.PlaceObject;
	import org.libspark.swfassist.swf.tags.PlaceObject2;
	import org.libspark.swfassist.swf.tags.PlaceObject3;
	import org.libspark.swfassist.swf.tags.Protect;
	import org.libspark.swfassist.swf.tags.RemoveObject;
	import org.libspark.swfassist.swf.tags.RemoveObject2;
	import org.libspark.swfassist.swf.tags.ScriptLimits;
	import org.libspark.swfassist.swf.tags.SetBackgroundColor;
	import org.libspark.swfassist.swf.tags.SetTabIndex;
	import org.libspark.swfassist.swf.tags.ShowFrame;
	import org.libspark.swfassist.swf.tags.SoundFormatConstants;
	import org.libspark.swfassist.swf.tags.SoundStreamBlock;
	import org.libspark.swfassist.swf.tags.SoundStreamHead;
	import org.libspark.swfassist.swf.tags.SoundStreamHead2;
	import org.libspark.swfassist.swf.tags.StartSound;
	import org.libspark.swfassist.swf.tags.StartSound2;
	import org.libspark.swfassist.swf.tags.SymbolClass;
	import org.libspark.swfassist.swf.tags.Tag;
	import org.libspark.swfassist.swf.tags.TagCodeConstants;
	import org.libspark.swfassist.swf.tags.Tags;
	import org.libspark.swfassist.swf.tags.Unknown;
	import org.libspark.swfassist.swf.tags.VideoFrame;
	
	public class SWFReader
	{
		private function error(context:ReadingContext, id:uint, message:String = ''):void
		{
			var e:Error = new Error(message, id);
			var handler:ErrorHandler = context.errorHandler;
			
			if (!handler || !handler.handleError(e)) {
				throw e;
			}
		}
		
		private function warning(context:ReadingContext, id:uint, message:String):void
		{
			var w:Warning = new Warning(message, id);
			var handler:ErrorHandler = context.errorHandler;
			
			if (!handler || !handler.handleWarning(w)) {
				throw w;
			}
		}
		
		public function readSWF(input:DataInput, context:ReadingContext, swf:SWF = null, tagLimit:uint = 0):SWF
		{
			if (!swf) {
				swf = new SWF();
			}
			
			readHeader(input, context, swf.header);
			
			if (context.version >= 8) {
				var pos:uint = input.position;
				var firstTagCode:uint = readTagCode(input);
				if (firstTagCode != TagCodeConstants.TAG_FILE_ATTRIBUTES) {
					error(context, ErrorIdConstants.FILE_ATTRIBUTES_ARE_NEEDED, ErrorMessageConstants.FILE_ATTRIBUTES_ARE_NEEDED);
				}
				else {
					input.seek(pos);
					readFileAttributes(input, context, swf.fileAttributes);
				}
			}
			
			readTags(input, context, swf.tags, tagLimit);
			
			return swf;
		}
		
		public function readHeader(input:DataInput, context:ReadingContext, header:Header = null):Header
		{
			if (!header) {
				header = new Header();
			}
			
			var signature:uint = input.readU8();
			
			switch (signature) {
				default:
					error(context, ErrorIdConstants.INVALID_SIGNATURE, ErrorMessageConstants.INVALID_SIGNATURE);
				case 0x46:
					header.isCompressed = false;
					break;
				case 0x43:
					header.isCompressed = true;
					break;
			}
			
			if (input.readU8() != 0x57) {
				error(context, ErrorIdConstants.INVALID_SIGNATURE, ErrorMessageConstants.INVALID_SIGNATURE);
			}
			
			if (input.readU8() != 0x53) {
				error(context, ErrorIdConstants.INVALID_SIGNATURE, ErrorMessageConstants.INVALID_SIGNATURE);
			}
			
			header.version = input.readU8();
			
			if (!context.ignoreFileVersion) {
				context.version = header.version;
			}
			
			var fileLength:uint = input.readU32();
			
			if (header.isCompressed) {
				input.uncompress(input.position);
			}
			
			if (input.length != fileLength) {
				error(context, ErrorIdConstants.INVALID_FILE_LENGTH, ErrorMessageConstants.INVALID_FILE_LENGTH);
			}
			
			readRect(input, context, header.frameSize);
			
			header.frameRate = input.readFixed8();
			header.numFrames = input.readU16();
			
			return header;
		}
		
		private function readTagCode(input:DataInput):uint
		{
			var c:uint = input.readU16() >> 6;
			
			input.skip(-2);
			
			return c;
		}
		
		private function readTagLength(input:DataInput, context:ReadingContext):uint
		{
			var length:uint = input.readU16() & 0x003f;
			
			if (length == 0x3f) {
				length = input.readS32();
			}
			
			if (length < 0) {
				error(context, ErrorIdConstants.INVALID_TAG_LENGTH, ErrorMessageConstants.INVALID_TAG_LENGTH);
				length = 0;
			}
			
			return length;
		}
		
		private function skipTagHeader(input:DataInput):void
		{
			if ((input.readU16() & 0x003f) == 0x3f) {
				input.readU32();
			}
		}
		
		public function readTags(input:DataInput, context:ReadingContext, tags:Tags = null, tagLimit:uint = 0):Tags
		{
			if (!tags) {
				tags = new Tags();
			}
			
			if (tagLimit == 0) {
				tagLimit = uint.MAX_VALUE;
			}
			
			tagLoop: for (var i:uint = 0; i < tagLimit; ++i) {
				
				if (input.bytesAvaliable < 1) {
					break;
				}
				
				var pos:uint = input.position;
			
				var code:uint = readTagCode(input);
				var length:uint = readTagLength(input, context);
				
				var bodyPos:uint = input.position;
				
				input.seek(pos);
				
				var tag:Tag = null;
				
				switch (code) {
					case TagCodeConstants.TAG_PLACE_OBJECT:
						tag = readPlaceObject(input, context);
						break;
					
					case TagCodeConstants.TAG_PLACE_OBJECT2:
						tag = readPlaceObject2(input, context);
						break;
						
					case TagCodeConstants.TAG_PLACE_OBJECT3:
						tag = readPlaceObject3(input, context);
						break;
						
					case TagCodeConstants.TAG_REMOVE_OBJECT:
						tag = readRemoveObject(input, context);
						break;
						
					case TagCodeConstants.TAG_REMOVE_OBJECT2:
						tag = readRemoveObject2(input, context);
						break;
					
					case TagCodeConstants.TAG_SHOW_FRAME:
						tag = readShowFrame(input, context);
						break;
						
					case TagCodeConstants.TAG_SET_BACKGROUND_COLOR:
						tag = readSetBackgroundColor(input, context);
						break;
					
					case TagCodeConstants.TAG_FRAME_LABEL:
						tag = readFrameLabel(input, context);
						break;
					
					case TagCodeConstants.TAG_PROTECT:
						tag = readProtect(input, context);
						break;
					
					case TagCodeConstants.TAG_END:
						tag = readEnd(input, context);
						break tagLoop;
					
					case TagCodeConstants.TAG_EXPORT_ASSETS:
						tag = readExportAssets(input, context);
						break;
					
					case TagCodeConstants.TAG_IMPORT_ASSETS:
						tag = readImportAssets(input, context);
						break;
					
					case TagCodeConstants.TAG_ENABLE_DEBUGGER:
						tag = readEnableDebugger(input, context);
						break;
					
					case TagCodeConstants.TAG_ENABLE_DEBUGGER2:
						tag = readEnableDebugger2(input, context);
						break;
						
					case TagCodeConstants.TAG_SCRIPT_LIMITS:
						tag = readScriptLimits(input, context);
						break;
					
					case TagCodeConstants.TAG_SET_TAB_INDEX:
						tag = readSetTabIndex(input, context);
						break;
						
					case TagCodeConstants.TAG_FILE_ATTRIBUTES:
						tag = readFileAttributes(input, context);
						break;
					
					case TagCodeConstants.TAG_IMPORT_ASSETS2:
						tag = readImportAssets2(input, context);
						break;
					
					case TagCodeConstants.TAG_SYMBOL_CLASS:
						tag = readSymbolClass(input, context);
						break;
					
					case TagCodeConstants.TAG_METADATA:
						tag = readMetadata(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_SCALING_GRID:
						tag = readDefineScalingGrid(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_SCENE_AND_FRAME_LABEL_DATA:
						tag = readDefineSceneAndFrameLabelData(input, context);
						break;
					
					case TagCodeConstants.TAG_DO_ACTION:
						tag = readDoAction(input, context);
						break;
					
					case TagCodeConstants.TAG_DO_INIT_ACTION:
						tag = readDoInitAction(input, context);
						break;
					
					case TagCodeConstants.TAG_DO_ABC:
						tag = readDoABC(input ,context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_SHAPE:
						tag = readDefineShape(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_SHAPE2:
						tag = readDefineShape2(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_SHAPE3:
						tag = readDefineShape3(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_SHAPE4:
						tag = readDefineShape4(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_BITS:
						tag = readDefineBits(input, context);
						break;
					
					case TagCodeConstants.TAG_JPEG_TABLES:
						tag = readJPEGTables(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_BITS_JPEG2:
						tag = readDefineBitsJPEG2(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_BITS_JPEG3:
						tag = readDefineBitsJPEG3(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_BITS_LOSSLESS:
						tag = readDefineBitsLossless(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_BITS_LOSSLESS2:
						tag = readDefineBitsLossless2(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_MORPH_SHAPE:
						tag = readDefineMorphShape(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_MORPH_SHAPE2:
						tag = readDefineMorphShape2(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_FONT:
						tag = readDefineFont(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_FONT_INFO:
						tag = readDefineFontInfo(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_FONT_INFO2:
						tag = readDefineFontInfo2(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_FONT2:
						tag = readDefineFont2(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_FONT3:
						tag = readDefineFont3(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_FONT_ALIGN_ZONES:
						tag = readDefineFontAlignZones(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_FONT_NAME:
						tag = readDefineFontName(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_TEXT:
						tag = readDefineText(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_TEXT2:
						tag = readDefineText2(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_EDIT_TEXT:
						tag = readDefineEditText(input, context);
						break;
					
					case TagCodeConstants.TAG_CSMTEXT_SETTINGS:
						tag = readCSMTextSettings(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_SOUND:
						tag = readDefineSound(input, context);
						break;
					
					case TagCodeConstants.TAG_START_SOUND:
						tag = readStartSound(input, context);
						break;
					
					case TagCodeConstants.TAG_START_SOUND2:
						tag = readStartSound2(input, context);
						break;
					
					case TagCodeConstants.TAG_SOUND_STREAM_HEAD:
						tag = readSoundStreamHead(input, context);
						break;
					
					case TagCodeConstants.TAG_SOUND_STREAM_HEAD2:
						tag = readSoundStreamHead2(input, context);
						break;
					
					case TagCodeConstants.TAG_SOUND_STREAM_BLOCK:
						tag = readSoundStreamBlock(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_BUTTON:
						tag = readDefineButton(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_BUTTON2:
						tag = readDefineButton2(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_BUTTON_CXFORM:
						tag = readDefineButtonCxform(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_BUTTON_SOUND:
						tag = readDefineButtonSound(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_SPRITE:
						tag = readDefineSprite(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_VIDEO_STREAM:
						tag = readDefineVideoStream(input, context);
						break;
					
					case TagCodeConstants.TAG_VIDEO_FRAME:
						tag = readVideoFrame(input, context);
						break;
					
					case TagCodeConstants.TAG_DEFINE_BINARY_DATA:
						tag = readDefineBinaryData(input, context);
						break;
				}
				
				if (!tag) {
					tag = readUnknown(input, context);
				}
				
				tags.addTag(tag);
				
				if (input.position != (bodyPos + length)) {
					error(context, ErrorIdConstants.INVALID_TAG_LENGTH, ErrorMessageConstants.INVALID_TAG_LENGTH + ' ' +
					      '(code<' + code + '> bodyPos<' + bodyPos + '> length<' + length + '> endPos<' + (bodyPos + length) + '>' +
					      ' currentPos<' + input.position + '> currentLength<' + (input.position - bodyPos) + '>)');
					input.skip(bodyPos + length);
				}
			}
			
			return tags;
		}
		
		public function readUnknown(input:DataInput, context:ReadingContext, tag:Unknown = null):Unknown
		{
			if (!tag) {
				tag = new Unknown(0);
			}
			
			tag.code = readTagCode(input);
			
			input.skip(readTagLength(input, context));
			
			return tag;
		}
		
		public function readString(input:DataInput, context:ReadingContext, length:uint = 0):String
		{
			if (context.version <= 5) {
				return input.readString(length, 'shift-jis');
			}
			return input.readUTF(length);
		}
		
		public function readLanguageCode(input:DataInput, context:ReadingContext, languageCode:LanguageCode = null):LanguageCode
		{
			if (!languageCode) {
				languageCode = new LanguageCode();
			}
			
			languageCode.code = input.readU8();
			
			return languageCode;
		}
		
		public function readRGB(input:DataInput, context:ReadingContext, rgb:RGB = null):RGB
		{
			if (!rgb) {
				rgb = new RGB();
			}
			
			rgb.red = input.readU8();
			rgb.green = input.readU8();
			rgb.blue = input.readU8();
			
			return rgb;
		}
		
		public function readRGBA(input:DataInput, context:ReadingContext, rgba:RGBA = null):RGBA
		{
			if (!rgba) {
				rgba = new RGBA();
			}
			
			readRGB(input, context, rgba);
			
			rgba.alpha = input.readU8();
			
			return rgba;
		}
		
		public function readARGB(input:DataInput, context:ReadingContext, argb:ARGB = null):ARGB
		{
			if (!argb) {
				argb = new ARGB();
			}
			
			argb.alpha = input.readU8();
			
			readRGB(input, context, argb);
			
			return argb;
		}
		
		public function readRect(input:DataInput, context:ReadingContext, rect:Rect = null):Rect
		{
			if (!rect) {
				rect = new Rect();
			}
			
			input.resetBitCursor();
			
			var numBits:uint = input.readUBits(5);
			
			rect.xMinTwips = input.readSBits(numBits);
			rect.xMaxTwips = input.readSBits(numBits);
			rect.yMinTwips = input.readSBits(numBits);
			rect.yMaxTwips = input.readSBits(numBits);
			
			return rect;
		}
		
		public function readMatrix(input:DataInput, context:ReadingContext, matrix:Matrix = null):Matrix
		{
			if (!matrix) {
				matrix = new Matrix();
			}
			
			input.resetBitCursor();
			
			matrix.hasScale = input.readBit();
			
			if (matrix.hasScale) {
				var scaleBits:uint = input.readUBits(5);
				matrix.scaleX = input.readFBits(scaleBits);
				matrix.scaleY = input.readFBits(scaleBits);
			}
			
			matrix.hasRotate = input.readBit();
			
			if (matrix.hasRotate) {
				var rotateBits:uint = input.readUBits(5);
				matrix.rotateSkew0 = input.readFBits(rotateBits);
				matrix.rotateSkew1 = input.readFBits(rotateBits);
			}
			
			var translateBits:uint = input.readUBits(5);
			matrix.translateXTwips = input.readSBits(translateBits);
			matrix.translateYTwips = input.readSBits(translateBits);
			
			return matrix;
		}
		
		public function readCXForm(input:DataInput, context:ReadingContext, cxform:CXForm = null):CXForm
		{
			if (!cxform) {
				cxform = new CXForm();
			}
			
			input.resetBitCursor();
			
			cxform.hasAddition = input.readBit();
			cxform.hasMultiplication = input.readBit();
			
			var numBits:uint = input.readUBits(4);
			
			if (cxform.hasMultiplication) {
				cxform.redMultiplication = input.readSBits(numBits);
				cxform.greenMultiplication = input.readSBits(numBits);
				cxform.blueMultiplication = input.readSBits(numBits);
			}
			
			if (cxform.hasAddition) {
				cxform.redAddition = input.readSBits(numBits);
				cxform.greenAddition = input.readSBits(numBits);
				cxform.blueAddition = input.readSBits(numBits);
			}
			
			return cxform;
		}
		
		public function readCXFormWithAlpha(input:DataInput, context:ReadingContext, cxform:CXFormWithAlpha = null):CXFormWithAlpha
		{
			if (!cxform) {
				cxform = new CXFormWithAlpha();
			}
			
			input.resetBitCursor();
			
			cxform.hasAddition = input.readBit();
			cxform.hasMultiplication = input.readBit();
			
			var numBits:uint = input.readUBits(4);
			
			if (cxform.hasMultiplication) {
				cxform.redMultiplication = input.readSBits(numBits);
				cxform.greenMultiplication = input.readSBits(numBits);
				cxform.blueMultiplication = input.readSBits(numBits);
				cxform.alphaMultiplication = input.readSBits(numBits);
			}
			
			if (cxform.hasAddition) {
				cxform.redAddition = input.readSBits(numBits);
				cxform.greenAddition = input.readSBits(numBits);
				cxform.blueAddition = input.readSBits(numBits);
				cxform.alphaAddition = input.readSBits(numBits);
			}
			
			return cxform;
		}
		
		public function readPlaceObject(input:DataInput, context:ReadingContext, tag:PlaceObject = null):PlaceObject
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new PlaceObject();
			}
			
			skipTagHeader(input);
			
			tag.characterId = input.readU16();
			tag.depth = input.readU16();
			readMatrix(input, context, tag.matrix);
			readCXForm(input, context, tag.colorTransform);
			
			return tag;
		}
		
		public function readPlaceObject2(input:DataInput, context:ReadingContext, tag:PlaceObject2 = null):PlaceObject2
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new PlaceObject2();
			}
			
			skipTagHeader(input);
			
			input.resetBitCursor();
			
			if (context.version >= 5) {
				tag.hasClipActions = input.readBit();
			}
			else {
				input.readBit();
			}
			tag.hasClipDepth = input.readBit();
			tag.hasName = input.readBit();
			tag.hasRatio = input.readBit();
			tag.hasColorTransform = input.readBit();
			tag.hasMatrix = input.readBit();
			tag.hasCharacter = input.readBit();
			tag.isMove = input.readBit();
			
			tag.depth = input.readU16();
			
			if (tag.hasCharacter) {
				tag.characterId = input.readU16();
			}
			if (tag.hasMatrix) {
				readMatrix(input, context, tag.matrix);
			}
			if (tag.hasColorTransform) {
				readCXFormWithAlpha(input, context, tag.colorTransform);
			}
			if (tag.hasRatio) {
				tag.ratio = input.readU16();
			}
			if (tag.hasName) {
				tag.name = readString(input, context);
			}
			if (tag.hasClipDepth) {
				tag.clipDepth = input.readU16();
			}
			if (context.version >= 5 && tag.hasClipActions) {
				readClipActions(input, context, tag.clipActions);
			}
			
			return tag;
		}
		
		public function readClipActions(input:DataInput, context:ReadingContext, clipActions:ClipActions = null):ClipActions
		{
			if (!clipActions) {
				clipActions = new ClipActions();
			}
			
			input.readU16();
			
			readClipEventFlags(input, context, clipActions.allEventFlags);
			
			context.actionRecordSize = 0;
			
			for (var eventFlags:ClipEventFlags = readClipEventFlags(input, context); eventFlags != null; eventFlags = readClipEventFlags(input, context)) {
				
				var clipActionRecord:ClipActionRecord = new ClipActionRecord();
				clipActionRecord.eventFlags = eventFlags;
				
				input.readU32();
				
				if (eventFlags.eventKeyPress) {
					clipActionRecord.keyCode = input.readU8();
				}
				
				readActionRecords(input, context, clipActionRecord.actions);
			}
			
			return clipActions;
		}
		
		public function readPlaceObject3(input:DataInput, context:ReadingContext, tag:PlaceObject3 = null):PlaceObject3
		{
			if (context.version < 8) {
				return null;
			}
			
			if (!tag) {
				tag = new PlaceObject3();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			var pos:uint = input.position;
			
			input.resetBitCursor();
			
			if (context.version >= 5) {
				tag.hasClipActions = input.readBit();
			}
			else {
				input.readBit();
			}
			tag.hasClipDepth = input.readBit();
			tag.hasName = input.readBit();
			tag.hasRatio = input.readBit();
			tag.hasColorTransform = input.readBit();
			tag.hasMatrix = input.readBit();
			tag.hasCharacter = input.readBit();
			tag.isMove = input.readBit();
			
			input.readUBits(3);
			
			tag.hasImage = input.readBit();
			tag.hasClassName = input.readBit();
			tag.hasCacheAsBitmap = input.readBit();
			tag.hasBlendMode = input.readBit();
			tag.hasFilterList = input.readBit();
			
			tag.depth = input.readU16();
			
			if (tag.hasClassName || (tag.hasImage && tag.hasCharacter)) {
				tag.className = readString(input, context);
			}
			if (tag.hasCharacter) {
				tag.characterId = input.readU16();
			}
			if (tag.hasMatrix) {
				readMatrix(input, context, tag.matrix);
			}
			if (tag.hasColorTransform) {
				readCXFormWithAlpha(input, context, tag.colorTransform);
			}
			if (tag.hasRatio) {
				tag.ratio = input.readU16();
			}
			if (tag.hasName) {
				tag.name = readString(input, context);
			}
			if (tag.hasClipDepth) {
				tag.clipDepth = input.readU16();
			}
			if (tag.hasFilterList) {
				readFilterList(input, context, tag.filterList);
			}
			if (tag.hasBlendMode) {
				tag.blendMode = input.readU8();
			}
			if (context.version >= 5 && tag.hasClipActions) {
				readClipActions(input, context, tag.clipActions);
			}
			
			if ((length - (input.position - pos)) == 1) {
				input.skip(1);
			}
			
			return tag;
		}
		
		public function readFilterList(input:DataInput, context:ReadingContext, list:FilterList = null):FilterList
		{
			if (!list) {
				list = new FilterList();
			}
			
			list.clearFilters();
			
			var numFilters:uint = input.readU8();
			
			for (var i:uint = 0; i < numFilters; ++i) {
				list.addFilter(readFilter(input, context));
			}
			
			return list;
		}
		
		public function readFilter(input:DataInput, context:ReadingContext):Filter
		{
			var filterId:uint = input.readU8();
			
			switch (filterId) {
				case FilterConstants.ID_DROP_SHADOW:
					return readDropShadowFilter(input, context);
				case FilterConstants.ID_BLUR:
					return readBlurFilter(input, context);
				case FilterConstants.ID_GLOW:
					return readGlowFilter(input, context);
				case FilterConstants.ID_BEVEL:
					return readBevelFilter(input, context);
				case FilterConstants.ID_GRADIENT_GLOW:
					return readGradientGlowFilter(input, context);
				case FilterConstants.ID_CONVOLUTION:
					return readConvolutionFilter(input, context);
				case FilterConstants.ID_COLOR_MATRIX:
					return readColorMatrixFilter(input, context);
				case FilterConstants.ID_GRADIENT_BEVEL:
					return readGradientBevelFilter(input, context);
			}
			
			return null;
		}
		
		public function readColorMatrixFilter(input:DataInput, context:ReadingContext, filter:ColorMatrixFilter = null):ColorMatrixFilter
		{
			if (!filter) {
				filter = new ColorMatrixFilter();
			}
			
			var matrix:Array = filter.matrix;
			
			if (matrix.length != 20) {
				matrix.length = 20;
			}
			
			for (var i:uint = 0; i < 20; ++i) {
				matrix[i] = input.readFloat();
			}
			
			return filter;
		}
		
		public function readConvolutionFilter(input:DataInput, context:ReadingContext, filter:ConvolutionFilter = null):ConvolutionFilter
		{
			if (!filter) {
				filter = new ConvolutionFilter();
			}
			
			filter.matrixX = input.readU8();
			filter.matrixY = input.readU8();
			filter.divisor = input.readFloat();
			filter.bias = input.readFloat();
			
			var matrix:Array = filter.matrix;
			var l:uint = filter.matrixX * filter.matrixY;
			
			if (matrix.length != l) {
				matrix.length = l;
			}
			
			for (var i:uint = 0; i < l; ++i) {
				matrix[i] = input.readFloat();
			}
			
			readRGBA(input, context, filter.defaultColor);
			
			input.resetBitCursor();
			input.readUBits(6);
			
			filter.clamp = input.readBit();
			filter.preserveAlpha = input.readBit();
			
			return filter;
		}
		
		public function readBlurFilter(input:DataInput, context:ReadingContext, filter:BlurFilter = null):BlurFilter
		{
			if (!filter) {
				filter = new BlurFilter();
			}
			
			filter.blurX = input.readFixed();
			filter.blurY = input.readFixed();
			
			input.resetBitCursor();
			
			filter.passes = input.readUBits(5);
			
			input.readUBits(3);
			
			return filter;
		}
		
		public function readDropShadowFilter(input:DataInput, context:ReadingContext, filter:DropShadowFilter = null):DropShadowFilter
		{
			if (!filter) {
				filter = new DropShadowFilter();
			}
			
			readRGBA(input, context, filter.dropShadowColor);
			
			filter.blurX = input.readFixed();
			filter.blurY = input.readFixed();
			filter.angle = input.readFixed();
			filter.distance = input.readFixed();
			filter.strength = input.readFixed8();
			
			input.resetBitCursor();
			
			filter.innerShadow = input.readBit();
			filter.knockout = input.readBit();
			
			input.readBit();
			
			filter.passes = input.readUBits(5);
			
			return filter;
		}
		
		public function readGlowFilter(input:DataInput, context:ReadingContext, filter:GlowFilter = null):GlowFilter
		{
			if (!filter) {
				filter = new GlowFilter();
			}
			
			readRGBA(input, context, filter.glowColor);
			
			filter.blurX = input.readFixed();
			filter.blurY = input.readFixed();
			filter.strength = input.readFixed8();
			
			input.resetBitCursor();
			
			filter.innerGlow = input.readBit();
			filter.knockout = input.readBit();
			
			input.readBit();
			
			filter.passes = input.readUBits(5);
			
			return filter;
		}
		
		public function readBevelFilter(input:DataInput, context:ReadingContext, filter:BevelFilter = null):BevelFilter
		{
			if (!filter) {
				filter = new BevelFilter();
			}
			
			readRGBA(input, context, filter.shadowColor);
			readRGBA(input, context, filter.highlightColor);
			
			filter.blurX = input.readFixed();
			filter.blurY = input.readFixed();
			filter.angle = input.readFixed();
			filter.distance = input.readFixed();
			filter.strength = input.readFixed8();
			
			input.resetBitCursor();
			
			filter.innerShadow = input.readBit();
			filter.knockout = input.readBit();
			
			input.readBit();
			
			filter.onTop = input.readBit();
			filter.passes = input.readUBits(4);
			
			return filter;
		}
		
		public function readGradientGlowFilter(input:DataInput, context:ReadingContext, filter:GradientGlowFilter = null):GradientGlowFilter
		{
			if (!filter) {
				filter = new GradientGlowFilter();
			}
			
			var numColors:uint = input.readU8();
			var colors:Array = filter.gradientColors;
			if (colors.length != numColors) {
				colors.length = numColors;
			}
			var ratio:Array = filter.gradientRatio;
			if (ratio.length != numColors) {
				ratio.length = numColors;
			}
			
			for (var i:uint = 0; i < numColors; ++i) {
				colors[i] = readRGBA(input, context);
			}
			for (var j:uint = 0; j < numColors; ++j) {
				ratio[j] = input.readU8();
			}
			
			filter.blurX = input.readFixed();
			filter.blurY = input.readFixed();
			filter.angle = input.readFixed();
			filter.distance = input.readFixed();
			filter.strength = input.readFixed8();
			
			input.resetBitCursor();
			
			filter.innerShadow = input.readBit();
			filter.knockout = input.readBit();
			
			input.readBit();
			
			filter.onTop = input.readBit();
			filter.passes = input.readUBits(4);
			
			return filter;
		}
		
		public function readGradientBevelFilter(input:DataInput, context:ReadingContext, filter:GradientBevelFilter = null):GradientBevelFilter
		{
			if (!filter) {
				filter = new GradientBevelFilter();
			}
			
			var numColors:uint = input.readU8();
			var colors:Array = filter.gradientColors;
			if (colors.length != numColors) {
				colors.length = numColors;
			}
			var ratio:Array = filter.gradientRatio;
			if (ratio.length != numColors) {
				ratio.length = numColors;
			}
			
			for (var i:uint = 0; i < numColors; ++i) {
				colors[i] = readRGBA(input, context);
			}
			for (var j:uint = 0; j < numColors; ++j) {
				ratio[j] = input.readU8();
			}
			
			filter.blurX = input.readFixed();
			filter.blurY = input.readFixed();
			filter.angle = input.readFixed();
			filter.distance = input.readFixed();
			filter.strength = input.readFixed8();
			
			input.resetBitCursor();
			
			filter.innerShadow = input.readBit();
			filter.knockout = input.readBit();
			
			input.readBit();
			
			filter.onTop = input.readBit();
			filter.passes = input.readUBits(4);
			
			return filter;
		}
		
		public function readClipEventFlags(input:DataInput, context:ReadingContext, flags:ClipEventFlags = null):ClipEventFlags
		{
			var a:uint = context.version >= 6 ? input.readU32() : input.readU16();
			
			if (a == 0) {
				return null;
			}
			
			if (!flags) {
				flags = new ClipEventFlags();
			}
			
			flags.eventKeyUp = (a & 0x00000080) != 0;
			flags.eventKeyDown = (a & 0x00000040) != 0;
			flags.eventMouseUp = (a & 0x00000020) != 0;
			flags.eventMouseDown = (a & 0x00000010) != 0;
			flags.eventMouseMove = (a & 0x00000008) != 0;
			flags.eventUnload = (a & 0x00000004) != 0;
			flags.eventEnterFrame = (a & 0x00000002) != 0;
			flags.eventLoad = (a & 0x00000001) != 0;
			
			if (context.version >= 6) {
				flags.eventDragOver = (a & 0x00008000) != 0;
				flags.eventRollOut = (a & 0x00004000) != 0;
				flags.eventRollOver = (a & 0x00002000) != 0;
				flags.eventReleaseOutSide = (a & 0x00001000) != 0;
				flags.eventRelease = (a & 0x00000800) != 0;
				flags.eventPress = (a & 0x00000400) != 0;
				flags.eventInitialize = (a & 0x00000200) != 0;
				flags.eventData = (a & 0x00000100) != 0;
				flags.eventConstruct = context.version >= 7 ? (a & 0x00040000) != 0 : false;
				flags.eventKeyPress = (a & 0x00020000) != 0;
				flags.eventDragOut = (a & 0x00010000) != 0;
			}
			
			return flags;
		}
		
		public function readRemoveObject(input:DataInput, context:ReadingContext, tag:RemoveObject = null):RemoveObject
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new RemoveObject();
			}
			
			skipTagHeader(input);
			
			tag.characterId = input.readU16();
			tag.depth = input.readU16();
			
			return tag;
		}
		
		public function readRemoveObject2(input:DataInput, context:ReadingContext, tag:RemoveObject2 = null):RemoveObject2
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new RemoveObject2();
			}
			
			skipTagHeader(input);
			
			tag.depth = input.readU16();
			
			return tag;
		}
		
		public function readShowFrame(input:DataInput, context:ReadingContext, tag:ShowFrame = null):ShowFrame
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new ShowFrame();
			}
			
			skipTagHeader(input);
			
			return tag;
		}
		
		public function readSetBackgroundColor(input:DataInput, context:ReadingContext, tag:SetBackgroundColor = null):SetBackgroundColor
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new SetBackgroundColor();
			}
			
			skipTagHeader(input);
			
			readRGB(input, context, tag.backgroundColor);
			
			return tag;
		}
		
		public function readFrameLabel(input:DataInput, context:ReadingContext, tag:FrameLabel = null):FrameLabel
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new FrameLabel();
			}
			
			var pos:uint = input.position;
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			tag.name = readString(input, context);
			
			if (input.position < (pos + length)) {
				if (input.readU8() == 0x01) {
					tag.isNamedAnchor = true;
				}
			}
			
			return tag;
		}
		
		public function readProtect(input:DataInput, context:ReadingContext, tag:Protect = null):Protect
		{
			if (context.version < 2) {
				return null;
			}
			
			if (!tag) {
				tag = new Protect();
			}
			
			skipTagHeader(input);
			
			return tag;
		}
		
		public function readEnd(input:DataInput, context:ReadingContext, tag:End = null):End
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new End();
			}
			
			skipTagHeader(input);
			
			return tag;
		}
		
		public function readExportAssets(input:DataInput, context:ReadingContext, tag:ExportAssets = null):ExportAssets
		{
			if (context.version < 5) {
				return null;
			}
			
			if (!tag) {
				tag = new ExportAssets();
			}
			
			skipTagHeader(input);
			
			var count:uint = input.readU16();
			
			var assets:Array = tag.assets;
			if (assets.length != count) {
				assets.length = count;
			}
			
			for (var i:uint = 0; i < count; ++i) {
				assets[i] = readAsset(input, context);
			}
			
			return tag;
		}
		
		public function readAsset(input:DataInput, context:ReadingContext, asset:Asset = null):Asset
		{
			if (!asset) {
				asset = new Asset();
			}
			
			asset.characterId = input.readU16();
			asset.name = readString(input, context);
			
			return asset;
		}
		
		public function readImportAssets(input:DataInput, context:ReadingContext, tag:ImportAssets = null):ImportAssets
		{
			if (context.version < 5 || context.version > 7) {
				return null;
			}
			
			if (!tag) {
				tag = new ImportAssets();
			}
			
			skipTagHeader(input);
			
			tag.url = readString(input, context);
			
			var count:uint = input.readU16();
			
			var assets:Array = tag.assets;
			if (assets.length != count) {
				assets.length = count;
			}
			
			for (var i:uint = 0; i < count; ++i) {
				assets[i] = readAsset(input, context);
			}
			
			return tag;
		}
		
		public function readEnableDebugger(input:DataInput, context:ReadingContext, tag:EnableDebugger = null):EnableDebugger
		{
			if (context.version < 5) {
				return null;
			}
			
			if (!tag) {
				tag = new EnableDebugger();
			}
			
			skipTagHeader(input);
			
			tag.password = readString(input, context);
			
			return tag;
		}
		
		public function readEnableDebugger2(input:DataInput, context:ReadingContext, tag:EnableDebugger2 = null):EnableDebugger2
		{
			if (context.version < 6) {
				return null;
			}
			
			if (!tag) {
				tag = new EnableDebugger2();
			}
			
			skipTagHeader(input);
			
			input.readU16();
			
			tag.password = readString(input, context);
			
			return tag;
		}
		
		public function readScriptLimits(input:DataInput, context:ReadingContext, tag:ScriptLimits = null):ScriptLimits
		{
			if (context.version < 7) {
				return null;
			}
			
			if (!tag) {
				tag = new ScriptLimits();
			}
			
			skipTagHeader(input);
			
			tag.maxRecursionDepth = input.readU16();
			tag.scriptTimeoutSeconds = input.readU16();
			
			return tag;
		}
		
		public function readSetTabIndex(input:DataInput, context:ReadingContext, tag:SetTabIndex = null):SetTabIndex
		{
			if (context.version < 7) {
				return null;
			}
			
			if (!tag) {
				tag = new SetTabIndex();
			}
			
			skipTagHeader(input);
			
			tag.depth = input.readU16();
			tag.tabIndex = input.readU16();
			
			return tag;
		}
		
		public function readFileAttributes(input:DataInput, context:ReadingContext, tag:FileAttributes = null):FileAttributes
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new FileAttributes();
			}
			
			skipTagHeader(input);
			
			input.resetBitCursor();
			input.readUBits(3);
			
			tag.hasMetadata = input.readBit();
			tag.isActionScript3 = input.readBit();
			
			input.readUBits(2);
			
			tag.useNetwork = input.readBit();
			
			input.readUBits(24);
			
			return tag;
		}
		
		public function readImportAssets2(input:DataInput, context:ReadingContext, tag:ImportAssets2 = null):ImportAssets2
		{
			if (context.version < 8) {
				return null;
			}
			
			if (!tag) {
				tag = new ImportAssets2();
			}
			
			skipTagHeader(input);
			
			tag.url = readString(input, context);
			
			input.readU8();
			input.readU8();
			
			var count:uint = input.readU16();
			
			var assets:Array = tag.assets;
			if (assets.length != count) {
				assets.length = count;
			}
			
			for (var i:uint = 0; i < count; ++i) {
				assets[i] = readAsset(input, context);
			}
			
			return tag;
		}
		
		public function readSymbolClass(input:DataInput, context:ReadingContext, tag:SymbolClass = null):SymbolClass
		{
			if (context.version < 9) {
				return null;
			}
			
			if (!tag) {
				tag = new SymbolClass();
			}
			
			skipTagHeader(input);
			
			var numSymbols:uint = input.readU16();
			
			var symbols:Array = tag.symbols;
			if (symbols.length != numSymbols) {
				symbols.length = numSymbols;
			}
			
			for (var i:uint = 0; i < numSymbols; ++i) {
				symbols[i] = readAsset(input, context);
			}
			
			return tag;
		}
		
		public function readMetadata(input:DataInput, context:ReadingContext, tag:Metadata = null):Metadata
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new Metadata();
			}
			
			skipTagHeader(input);
			
			tag.metadata = readString(input, context);
			
			return tag;
		}
		
		public function readDefineScalingGrid(input:DataInput, context:ReadingContext, tag:DefineScalingGrid = null):DefineScalingGrid
		{
			if (context.version < 8) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineScalingGrid();
			}
			
			skipTagHeader(input);
			
			tag.characterId = input.readU16();
			
			readRect(input, context, tag.splitter);
			
			return tag;
		}
		
		public function readDefineSceneAndFrameLabelData(input:DataInput, context:ReadingContext, tag:DefineSceneAndFrameLabelData = null):DefineSceneAndFrameLabelData
		{
			if (context.version < 9) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineSceneAndFrameLabelData();
			}
			
			skipTagHeader(input);
			
			var numScenes:uint = input.readEncodedU32();
			var scenes:Array = tag.scenes;
			if (scenes.length != numScenes) {
				scenes.length = numScenes;
			}
			
			for (var i:uint = 0; i < numScenes; ++i) {
				var sceneData:SceneData = new SceneData();
				sceneData.frameOffset = input.readEncodedU32();
				sceneData.name = readString(input, context);
				scenes[i] = sceneData;
			}
			
			var numFrameLabels:uint = input.readEncodedU32();
			var frameLabels:Array = tag.frameLabels;
			if (frameLabels.length != numFrameLabels) {
				frameLabels.length = numFrameLabels;
			}
			
			for (var j:uint = 0; j < numFrameLabels; ++j) {
				var frameData:FrameLabelData = new FrameLabelData();
				frameData.frameNumber = input.readEncodedU32();
				frameData.frameLabel = readString(input, context);
				frameLabels[j] = frameData;
			}
			
			return tag;
		}
		
		public function readDoAction(input:DataInput, context:ReadingContext, tag:DoAction = null):DoAction
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new DoAction();
			}
			
			skipTagHeader(input);
			
			context.actionRecordSize = 0;
			
			readActionRecords(input, context, tag.actionRecords);
			
			return tag;
		}
		
		public function readActionRecords(input:DataInput, context:ReadingContext, actions:ActionRecords = null):ActionRecords
		{
			if (!actions) {
				actions = new ActionRecords();
			}
			
			var pos:uint = input.position;
			var size:uint = context.actionRecordSize;
			var last:uint = size != 0 ? pos + size : input.length;
			var list:Array = actions.actions;
			
			for (;;) {
				if (input.position == last) {
					break;
				}
				var actionCode:uint = input.readU8();
				if (actionCode == 0x00) {
					break;
				}
				var actionLength:uint = actionCode >= 0x80 ? input.readU16() : 0;
				if (context.needsAction) {
					list.push(new UnknownAction(actionCode));
				}
				input.skip(actionLength);
			}
			
			return actions;
		}
		
		public function readDoInitAction(input:DataInput, context:ReadingContext, tag:DoInitAction = null):DoInitAction
		{
			if (context.version < 6) {
				return null;
			}
			
			if (!tag) {
				tag = new DoInitAction();
			}
			
			skipTagHeader(input);
			
			tag.spriteId = input.readU16();
			
			context.actionRecordSize = 0;
			
			readActionRecords(input, context, tag.actionRecords);
			
			return tag;
		}
		
		public function readDoABC(input:DataInput, context:ReadingContext, tag:DoABC = null):DoABC
		{
			if (context.version < 9) {
				return null;
			}
			
			if (!tag) {
				tag = new DoABC();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			var flags:uint = input.readU32();
			
			tag.isLazyInitialize = (flags & 0x01) != 0;
			
			var abcName:String = readString(input,context);
			
			if (context.needsABCData) {
				if ((length - 5) > 0) {
					input.readBytes(tag.abcData, length - 5);
				}
			}
			else {
				input.skip(length - 5);
			}
			
			return tag;
		}
		
		public function readFillStyleArray(input:DataInput, context:ReadingContext, fillStyleArray:FillStyleArray = null):FillStyleArray
		{
			if (!fillStyleArray) {
				fillStyleArray = new FillStyleArray();
			}
			
			var numFillStyles:uint = input.readU8();
			
			if (numFillStyles == 0xff) {
				numFillStyles = input.readU16();
			}
			
			var list:Array = fillStyleArray.fillStyles;
			if (list.length != numFillStyles) {
				list.length = numFillStyles;
			}
			
			for (var i:uint = 0; i < numFillStyles; ++i) {
				list[i] = readFillStyle(input, context);
			}
		
			return fillStyleArray;
		}
		
		public function readFillStyle(input:DataInput, context:ReadingContext, fillStyle:FillStyle = null):FillStyle
		{
			if (!fillStyle) {
				fillStyle = new FillStyle();
			}
			
			fillStyle.fillStyleType = input.readU8();
			
			if (fillStyle.fillStyleType == FillStyleTypeConstants.SOLID_FILL) {
				if (context.tagType == 3 || context.tagType == 4) {
					readRGBA(input, context, fillStyle.color);
				}
				else {
					readRGB(input, context, fillStyle.color);
				}
			}
			if (fillStyle.fillStyleType == FillStyleTypeConstants.LINEAR_GRADIENT_FILL ||
			    fillStyle.fillStyleType == FillStyleTypeConstants.RADIAL_GRADIENT_FILL) {
				readMatrix(input, context, fillStyle.matrix);
				readGradient(input, context, fillStyle.gradient);
			}
			if (context.version >= 8 && fillStyle.fillStyleType == FillStyleTypeConstants.FOCAL_RADIAL_GRADIENT_FILL) {
				readFocalGradient(input, context, fillStyle.gradient);
			}
			if (fillStyle.fillStyleType == FillStyleTypeConstants.REPEATING_BITMAP_FILL ||
			    fillStyle.fillStyleType == FillStyleTypeConstants.CLIPPED_BITMAP_FILL ||
			    fillStyle.fillStyleType == FillStyleTypeConstants.NON_SMOOTHED_REPEATING_BITMAP ||
			    fillStyle.fillStyleType == FillStyleTypeConstants.NON_SMOOTHED_CLIPPED_BITMAP) {
				fillStyle.bitmapId = input.readU16();
				readMatrix(input, context, fillStyle.bitmapMatrix);
			}
			
			return fillStyle;
		}
		
		public function readLineStyleArray(input:DataInput, context:ReadingContext, lineStyleArray:LineStyleArray = null):LineStyleArray
		{
			if (!lineStyleArray) {
				lineStyleArray = new LineStyleArray();
			}
			
			var numLineStyles:uint = input.readU8();
			
			if (numLineStyles == 0xff) {
				numLineStyles = input.readU16();
			}
			
			var list:Array = lineStyleArray.lineStyles;
			if (list.length != numLineStyles) {
				list.length = numLineStyles;
			}
			
			if (context.tagType == 4) {
				for (var i:uint = 0; i < numLineStyles; ++i) {
					list[i] = readLineStyle2(input, context);
				}
			}
			else {
				for (var j:uint = 0; j < numLineStyles; ++j) {
					list[j] = readLineStyle(input, context);
				}
			}
			
			return lineStyleArray;
		}
		
		public function readLineStyle(input:DataInput, context:ReadingContext, lineStyle:LineStyle = null):LineStyle
		{
			if (!lineStyle) {
				lineStyle = new LineStyle();
			}
			
			lineStyle.widthTwips = input.readU16();
			
			if (context.tagType == 3) {
				readRGBA(input, context, lineStyle.color);
			}
			else {
				readRGB(input, context, lineStyle.color);
			}
			
			return lineStyle;
		}
		
		public function readLineStyle2(input:DataInput, context:ReadingContext, style:LineStyle2 = null):LineStyle2
		{
			if (!style) {
				style = new LineStyle2();
			}
			
			style.widthTwips = input.readU16();
			
			input.resetBitCursor();
			
			style.startCapStyle = input.readUBits(2);
			style.joinStyle = input.readUBits(2);
			style.hasFill = input.readBit();
			style.noHorizontalScale = input.readBit();
			style.noVerticalScale = input.readBit();
			style.pixelHinting = input.readBit();
			
			input.readUBits(5);
			
			style.noClose = input.readBit();
			style.endCapStyle = input.readUBits(2);
			
			if (style.joinStyle == JoinStyleConstants.MITER_JOIN) {
				style.miterLimitFactor = input.readFixed8();
			}
			if (!style.hasFill) {
				readRGBA(input, context, style.color);
			}
			if (style.hasFill) {
				readFillStyle(input, context, style.fillType);
			}
			
			return style;
		}
		
		public function readShape(input:DataInput, context:ReadingContext, shape:Shape = null):Shape
		{
			if (!shape) {
				shape = new Shape();
			}
			
			input.resetBitCursor();
			
			var fillBits:uint = input.readUBits(4);
			var lineBits:uint = input.readUBits(4);
			var list:Array = shape.shapeRecords;
			
			for (;;) {
				if (input.readBit()) {
					if (input.readBit()) {
						// STRAIGHT EDGE RECORD
						var straight:StraightEdgeRecord = new StraightEdgeRecord();
						var stNumBits:uint = input.readUBits(4) + 2;
						straight.generalLine = input.readBit();
						if (!straight.generalLine) {
							straight.verticalLine = input.readBit();
						}
						if (straight.generalLine || straight.horizontalLine) {
							straight.deltaXTwips = input.readSBits(stNumBits);
						}
						if (straight.generalLine || straight.verticalLine) {
							straight.deltaYTwips = input.readSBits(stNumBits);
						}
						straight.isHighPrecision = context.isHighPrecision;
						list.push(straight);
					}
					else {
						// CURVED EDGE RECORD
						var curved:CurvedEdgeRecord = new CurvedEdgeRecord();
						var cvNumBits:uint = input.readUBits(4) + 2;
						curved.controlDeltaXTwips = input.readSBits(cvNumBits);
						curved.controlDeltaYTwips = input.readSBits(cvNumBits);
						curved.anchorDeltaXTwips = input.readSBits(cvNumBits);
						curved.anchorDeltaYTwips = input.readSBits(cvNumBits);
						curved.isHighPrecision = context.isHighPrecision;
						list.push(curved);
					}
				}
				else {
					var a:Boolean = input.readBit();
					var b:Boolean = input.readBit();
					var c:Boolean = input.readBit();
					var d:Boolean = input.readBit();
					var e:Boolean = input.readBit();
					// END SHAPE RECORD
					if (!(a || b || c || d || e)) {
						break;
					}
					// STYLE CHANGE RECORD
					var styleChange:StyleChangeRecord = new StyleChangeRecord();
					styleChange.stateNewStyles = context.tagType == 2 || context.tagType == 3 || context.tagType == 4 ? a : false;
					styleChange.stateLineStyle = b;
					styleChange.stateFillStyle1 = c;
					styleChange.stateFillStyle0 = d;
					styleChange.stateMoveTo = e;
					if (styleChange.stateMoveTo) {
						var styleMoveBits:uint = input.readUBits(5);
						styleChange.moveDeltaXTwips = input.readSBits(styleMoveBits);
						styleChange.moveDeltaYTwips = input.readSBits(styleMoveBits);
					}
					if (styleChange.stateFillStyle0) {
						styleChange.fillStyle0 = input.readUBits(fillBits);
					}
					if (styleChange.stateFillStyle1) {
						styleChange.fillStyle1 = input.readUBits(fillBits);
					}
					if (styleChange.stateLineStyle) {
						styleChange.lineStyle = input.readUBits(lineBits);
					}
					if (styleChange.stateNewStyles) {
						readFillStyleArray(input, context, styleChange.fillStyles);
						readLineStyleArray(input, context, styleChange.lineStyles);
						input.resetBitCursor();
						fillBits = input.readUBits(4);
						lineBits = input.readUBits(4);
					}
					styleChange.isHighPrecision = context.isHighPrecision;
					list.push(styleChange);
				}
			}
			
			return shape;
		}
		
		public function readShapeWithStyle(input:DataInput, context:ReadingContext, shape:ShapeWithStyle = null):ShapeWithStyle
		{
			if (!shape) {
				shape = new ShapeWithStyle();
			}
			
			readFillStyleArray(input, context, shape.fillStyles);
			readLineStyleArray(input, context, shape.lineStyles);
			readShape(input, context, shape);
			
			return shape;
		}
		
		public function readDefineShape(input:DataInput, context:ReadingContext, tag:DefineShape = null):DefineShape
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineShape();
			}
			
			skipTagHeader(input);
			
			context.tagType = 1;
			
			tag.shapeId = input.readU16();
			readRect(input, context, tag.shapeBounds);
			readShapeWithStyle(input, context, tag.shapes);
			
			context.tagType = 0;
			
			return tag;
		}
		
		public function readDefineShape2(input:DataInput, context:ReadingContext, tag:DefineShape2 = null):DefineShape2
		{
			if (context.version < 2) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineShape2();
			}
			
			skipTagHeader(input);
			
			context.tagType = 2;
			
			tag.shapeId = input.readU16();
			readRect(input, context, tag.shapeBounds);
			readShapeWithStyle(input, context, tag.shapes);
			
			context.tagType = 0;
			
			return tag;
		}
		
		public function readDefineShape3(input:DataInput, context:ReadingContext, tag:DefineShape3 = null):DefineShape3
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineShape3();
			}
			
			skipTagHeader(input);
			
			context.tagType = 3;
			
			tag.shapeId = input.readU16();
			readRect(input, context, tag.shapeBounds);
			readShapeWithStyle(input, context, tag.shapes);
			
			context.tagType = 0;
			
			return tag;
		}
		
		public function readDefineShape4(input:DataInput, context:ReadingContext, tag:DefineShape4 = null):DefineShape4
		{
			if (context.version < 8) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineShape4();
			}
			
			skipTagHeader(input);
			
			context.tagType = 4;
			
			tag.shapeId = input.readU16();
			readRect(input, context, tag.shapeBounds);
			readRect(input, context, tag.edgeBounds);
			
			input.resetBitCursor();
			
			input.readUBits(6);
			
			tag.useNonScalingStrokes = input.readBit();
			tag.useScalingStrokes = input.readBit();
			
			readShapeWithStyle(input, context, tag.shapes);
			
			context.tagType = 0;
			
			return tag;
		}
		
		public function readGradient(input:DataInput, context:ReadingContext, gradient:Gradient = null):Gradient
		{
			if (!gradient) {
				gradient = new Gradient();
			}
			
			input.resetBitCursor();
			
			gradient.spreadMode = input.readUBits(2);
			gradient.interpolationMode = input.readUBits(2);
			
			var numGradients:uint = input.readUBits(4);
			var gradients:Array = gradient.gradientRecords;
			if (gradients.length != numGradients) {
				gradients.length = numGradients;
			}
			
			for (var i:uint = 0; i < numGradients; ++i) {
				gradients[i] = readGradientRecord(input, context);
			}
			
			return gradient;
		}
		
		public function readFocalGradient(input:DataInput, context:ReadingContext, gradient:FocalGradient = null):FocalGradient
		{
			if (!gradient) {
				gradient = new FocalGradient();
			}
			
			readGradient(input, context, gradient);
			
			gradient.focalPoint = input.readFixed8();
			
			return gradient;
		}
		
		public function readGradientRecord(input:DataInput, context:ReadingContext, record:GradientRecord = null):GradientRecord
		{
			if (!record) {
				record = new GradientRecord();
			}
			
			record.ratio = input.readU8();
			
			if (context.tagType == 3 || context.tagType == 4) {
				readRGBA(input, context, record.color);
			}
			else {
				readRGB(input, context, record.color);
			}
			
			return record;
		}
		
		public function readDefineBits(input:DataInput, context:ReadingContext, tag:DefineBits = null):DefineBits
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineBits();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			tag.characterId = input.readU16();
			
			if (context.needsBitmapData) {
				if ((length - 2) > 0) {
					input.readBytes(tag.jpegData, length - 2);
				}
			}
			else {
				input.skip(length - 2);
			}
			
			return tag;
		}
		
		public function readJPEGTables(input:DataInput, context:ReadingContext, tag:JPEGTables = null):JPEGTables
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new JPEGTables();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			if (context.needsBitmapData) {
				if (length > 0) {
					input.readBytes(tag.jpegData, length);
				}
			}
			else {
				input.skip(length);
			}
			
			return tag;
		}
		
		public function readDefineBitsJPEG2(input:DataInput, context:ReadingContext, tag:DefineBitsJPEG2 = null):DefineBitsJPEG2
		{
			if (context.version < 2) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineBitsJPEG2();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			tag.characterId = input.readU16();
			
			if (context.needsBitmapData) {
				if ((length - 2) > 0) {
					input.readBytes(tag.jpegData, length - 2);
				}
			}
			else {
				input.skip(length - 2);
			}
			
			return tag;
		}
		
		public function readDefineBitsJPEG3(input:DataInput, context:ReadingContext, tag:DefineBitsJPEG3 = null):DefineBitsJPEG3
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineBitsJPEG3();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			tag.characterId = input.readU16();
			
			var alphaOffset:uint = input.readU32();
			
			if (context.needsBitmapData) {
				if (alphaOffset > 0) {
					input.readBytes(tag.jpegData, alphaOffset);
				}
				if (((length - 6) - alphaOffset) > 0) {
					input.readBytes(tag.bitmapAlphaData, (length - 6) - alphaOffset);
				}
			}
			else {
				input.skip(length - 6);
			}
			
			return tag;
		}
		
		public function readDefineBitsLossless(input:DataInput, context:ReadingContext, tag:DefineBitsLossless = null):DefineBitsLossless
		{
			if (context.version < 2) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineBitsLossless();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			tag.characterId = input.readU16();
			tag.bitmapFormat = input.readU8();
			tag.bitmapWidth = input.readU16();
			tag.bitmapHeight = input.readU16();
			
			if (tag.bitmapFormat == BitmapFormatConstants.COLORMAPPED8) {
				var colorTableSize:uint = input.readU8();
				if (context.needsBitmapData) {
					var bytes:ByteArray = new ByteArray();
					if ((length - 8) > 0) {
						input.readBytes(bytes, length - 8);
						bytes.uncompress();
					}
					var bytesInput:DataInput = new ByteArrayInputStream(bytes);
					var table:Array = tag.colorTable;
					if (table.length != colorTableSize) {
						table.length = colorTableSize;
					}
					for (var i:uint = 0; i < colorTableSize; ++i) {
						table[i] = readRGB(bytesInput, context);
					}
					bytesInput.readBytes(tag.data);
					bytes.length = 0;
				}
				else {
					input.skip(length - 8);
				}
			}
			else {
				if (context.needsBitmapData) {
					if ((length - 7) > 0) {
						input.readBytes(tag.data, length - 7);
						tag.data.uncompress();
					}
				}
				else {
					input.skip(length - 7);
				}
			}
			
			return tag;
		}
		
		public function readDefineBitsLossless2(input:DataInput, context:ReadingContext, tag:DefineBitsLossless2 = null):DefineBitsLossless2
		{
			if (context.version < 2) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineBitsLossless2();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			tag.characterId = input.readU16();
			tag.bitmapFormat = input.readU8();
			tag.bitmapWidth = input.readU16();
			tag.bitmapHeight = input.readU16();
			
			if (tag.bitmapFormat == BitmapFormatConstants.COLORMAPPED8) {
				var colorTableSize:uint = input.readU8();
				if (context.needsBitmapData) {
					var bytes:ByteArray = new ByteArray();
					if ((length - 8) > 0) {
						input.readBytes(bytes, length - 8);
						bytes.uncompress();
					}
					var bytesInput:DataInput = new ByteArrayInputStream(bytes);
					var table:Array = tag.colorTable;
					if (table.length != colorTableSize) {
						table.length = colorTableSize;
					}
					for (var i:uint = 0; i < colorTableSize; ++i) {
						table[i] = readRGBA(bytesInput, context);
					}
					bytesInput.readBytes(tag.data);
					bytes.length = 0;
				}
				else {
					input.skip(length - 8);
				}
			}
			else {
				if (context.needsBitmapData) {
					if ((length - 7) > 0) {
						input.readBytes(tag.data, length - 7);
						tag.data.uncompress();
					}
				}
				else {
					input.skip(length - 7);
				}
			}
			
			return tag;
		}
		
		public function readDefineMorphShape(input:DataInput, context:ReadingContext, tag:DefineMorphShape = null):DefineMorphShape
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineMorphShape();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			var pos:uint = input.position;
			
			context.tagType = 1;
			
			tag.characterId = input.readU16();
			
			readRect(input, context, tag.startBounds);
			readRect(input, context, tag.endBounds);
			
			if (isValidBounds(tag.startBounds) || isValidBounds(tag.endBounds)) {
				var offset:uint = input.readU32();
				
				readMorphFillStyleArray(input, context, tag.morphFillStyles);
				readMorphLineStyles(input, context, tag.morphLineStyles);
				
				readShape(input, context, tag.startEdges);
				readShape(input, context, tag.endEdges);
			}
			else {
				input.skip(length - (input.position - pos));
			}
			
			context.tagType = 0;
			
			return tag;
		}
		
		private function isValidBounds(bounds:Rect):Boolean
		{
			return bounds.xMaxTwips > 0 && bounds.xMinTwips > 0 && bounds.yMaxTwips > 0 && bounds.yMinTwips > 0;
		}
		
		public function readDefineMorphShape2(input:DataInput, context:ReadingContext, tag:DefineMorphShape2 = null):DefineMorphShape2
		{
			if (context.version < 8) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineMorphShape2();
			}
			
			skipTagHeader(input);
			
			context.tagType = 2;
			
			tag.characterId = input.readU16();
			readRect(input, context, tag.startBounds);
			readRect(input, context, tag.endBounds);
			readRect(input, context, tag.startEdgeBounds);
			readRect(input, context, tag.endEdgeBounds);
			
			input.resetBitCursor();
			
			input.readUBits(6);
			
			tag.useNonScalingStrokes = input.readBit();
			tag.useScalingStrokes = input.readBit();
			
			var offset:uint = input.readU32();
			
			readMorphFillStyleArray(input, context, tag.morphFillStyles);
			readMorphLineStyles(input, context, tag.morphLineStyles);
			
			context.tagType = 3;
			
			readShape(input, context, tag.startEdges);
			readShape(input, context, tag.endEdges);
			
			context.tagType = 0;
			
			return tag;
		}
		
		public function readMorphFillStyleArray(input:DataInput, context:ReadingContext, styleArray:MorphFillStyleArray = null):MorphFillStyleArray
		{
			if (!styleArray) {
				styleArray = new MorphFillStyleArray();
			}
			
			var numFillStyles:uint = input.readU8();
			
			if (numFillStyles == 0xff) {
				numFillStyles = input.readU16();
			}
			
			var list:Array = styleArray.fillStyles;
			if (list.length != numFillStyles) {
				list.length = numFillStyles;
			}
			
			for (var i:uint = 0; i < numFillStyles; ++i) {
				list[i] = readMorphFillStyle(input, context);
			}
			
			return styleArray;
		}
		
		public function readMorphFillStyle(input:DataInput, context:ReadingContext, style:MorphFillStyle = null):MorphFillStyle
		{
			if (!style) {
				style = new MorphFillStyle();
			}
			
			style.fillStyleType = input.readU8();
			
			if (style.fillStyleType == FillStyleTypeConstants.SOLID_FILL) {
				readRGBA(input, context, style.startColor);
				readRGBA(input, context, style.endColor);
			}
			if (style.fillStyleType == FillStyleTypeConstants.LINEAR_GRADIENT_FILL ||
			    style.fillStyleType == FillStyleTypeConstants.RADIAL_GRADIENT_FILL) {
				readMatrix(input, context, style.startGradientMatrix);
				readMatrix(input, context, style.endGradientMatrix);
				readMorphGradient(input, context, style.gradient);
			}
			if (style.fillStyleType == FillStyleTypeConstants.FOCAL_RADIAL_GRADIENT_FILL) {
				readMatrix(input, context, style.startGradientMatrix);
				readMatrix(input, context, style.endGradientMatrix);
				readMorphGradient(input, context, style.gradient);
				input.readS16();
				input.readS16();
			}
			/**/
			if (style.fillStyleType == FillStyleTypeConstants.REPEATING_BITMAP_FILL ||
			    style.fillStyleType == FillStyleTypeConstants.CLIPPED_BITMAP_FILL ||
			    style.fillStyleType == FillStyleTypeConstants.NON_SMOOTHED_REPEATING_BITMAP ||
			    style.fillStyleType == FillStyleTypeConstants.NON_SMOOTHED_CLIPPED_BITMAP) {
				style.bitmapId = input.readU16();
				readMatrix(input, context, style.startBitmapMatrix);
				readMatrix(input, context, style.endBitmapMatrix);
			}
			
			return style;
		}
		
		public function readMorphGradient(input:DataInput, context:ReadingContext, gradient:MorphGradient = null):MorphGradient
		{
			if (!gradient) {
				gradient = new MorphGradient();
			}
			
			var numGradients:uint = input.readU8() & 0x0f;
			var gradients:Array = gradient.gradientRecords;
			if (gradients.length != numGradients) {
				gradients.length = numGradients;
			}
			
			for (var i:uint = 0; i < numGradients; ++i) {
				gradients[i] = readMorphGradientRecord(input, context);
			}
			
			return gradient;
		}
		
		public function readMorphGradientRecord(input:DataInput, context:ReadingContext, record:MorphGradientRecord = null):MorphGradientRecord
		{
			if (!record) {
				record = new MorphGradientRecord();
			}
			
			record.startRatio = input.readU8();
			readRGBA(input, context, record.startColor);
			record.endRatio = input.readU8();
			readRGBA(input, context, record.endColor);
			
			return record;
		}
		
		public function readMorphLineStyles(input:DataInput, context:ReadingContext, lineStyles:MorphLineStyles = null):MorphLineStyles
		{
			if (!lineStyles) {
				lineStyles = new MorphLineStyles();
			}
			
			var numLineStyles:uint = input.readU8();
			
			if (numLineStyles == 0xff) {
				numLineStyles = input.readU16();
			}
			
			var list:Array = lineStyles.lineStyles;
			if (list.length != numLineStyles) {
				list.length = numLineStyles;
			}
			
			if (context.tagType == 1) {
				for (var i:uint = 0; i < numLineStyles; ++i) {
					list[i] = readMorphLineStyle(input, context);
				}
			}
			else {
				for (var j:uint = 0; j < numLineStyles; ++j) {
					list[j] = readMorphLineStyle2(input, context);
				}
			}
			
			return lineStyles;
		}
		
		public function readMorphLineStyle(input:DataInput, context:ReadingContext, style:MorphLineStyle = null):MorphLineStyle
		{
			if (!style) {
				style = new MorphLineStyle();
			}
			
			style.startWidth = input.readU16();
			style.endWidth = input.readU16();
			readRGBA(input, context, style.startColor);
			readRGBA(input, context, style.endColor);
			
			return style;
		}
		
		public function readMorphLineStyle2(input:DataInput, context:ReadingContext, style:MorphLineStyle2 = null):MorphLineStyle2
		{
			if (!style) {
				style = new MorphLineStyle2();
			}
			
			style.startWidth = input.readU16();
			style.endWidth = input.readU16();
			
			input.resetBitCursor();
			
			style.startCapStyle = input.readUBits(2);
			style.joinStyle = input.readUBits(2);
			style.hasFill = input.readBit();
			style.noHorizontalScale = input.readBit();
			style.noVerticalScale = input.readBit();
			style.pixelHinting = input.readBit();
			
			input.readUBits(5);
			
			style.noClose = input.readBit();
			style.endCapStyle = input.readUBits(2);
			
			if (style.joinStyle == JoinStyleConstants.MITER_JOIN) {
				style.miterLimitFactor = input.readFixed8();
			}
			if (!style.hasFill) {
				readRGBA(input, context, style.startColor);
				readRGBA(input, context, style.endColor);
			}
			if (style.hasFill) {
				readMorphFillStyle(input, context, style.fillType);
			}
			
			return style;
		}
		
		public function readDefineFont(input:DataInput, context:ReadingContext, tag:DefineFont = null):DefineFont
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineFont();
			}
			
			skipTagHeader(input);
			
			tag.fontId = input.readU16();
			
			var size:uint = input.readU16() / 2;
			
			for (var i:uint = 0; i < size; ++i) {
				input.readU16();
			}
			
			var shapeTable:Array = tag.glyphShapeTable;
			if (shapeTable.length != size) {
				shapeTable.length = size;
			}
			
			for (var j:uint = 0; j < size; ++j) {
				shapeTable[j] = readShape(input, context);
			}
			
			return tag;
		}
		
		public function readDefineFontInfo(input:DataInput, context:ReadingContext, tag:DefineFontInfo = null):DefineFontInfo
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineFontInfo();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			var pos:uint = input.position;
			
			tag.fontId = input.readU16();
			
			var nameLen:uint = input.readU8();
			
			tag.fontName = readString(input, context, nameLen);
			
			input.resetBitCursor();
			input.readUBits(2);
			
			if (context.version >= 7) {
				tag.isSmallText = input.readBit();
			}
			else {
				input.readBit();
			}
			tag.isShiftJIS = input.readBit();
			tag.isANSI = input.readBit();
			tag.isItalic = input.readBit();
			tag.isBold = input.readBit();
			tag.areWideCodes = input.readBit();
			
			var size:uint = length - (input.position - pos);
			var table:Array = tag.codeTable;
			
			if (tag.areWideCodes) {
				size /= 2;
				if (table.length != size) {
					table.length = size;
				}
				for (var i:uint = 0; i < size; ++i) {
					table[i] = input.readU16();
				}
			}
			else {
				if (table.length != size) {
					table.length = size;
				}
				for (var j:uint = 0; j < size; ++j) {
					table[j] = input.readU8();
				}
			}
			
			return tag;
		}
		
		public function readDefineFontInfo2(input:DataInput, context:ReadingContext, tag:DefineFontInfo2 = null):DefineFontInfo2
		{
			if (context.version < 6) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineFontInfo2();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			var pos:uint = input.position;
			
			tag.fontId = input.readU16();
			
			var nameLen:uint = input.readU8();
			
			tag.fontName = readString(input, context, nameLen);
			
			input.resetBitCursor();
			input.readUBits(2);
			
			if (context.version >= 7) {
				tag.isSmallText = input.readBit();
			}
			else {
				input.readBit();
			}
			tag.isShiftJIS = input.readBit();
			tag.isANSI = input.readBit();
			tag.isItalic = input.readBit();
			tag.isBold = input.readBit();
			tag.areWideCodes = input.readBit();
			
			readLanguageCode(input, context, tag.languageCode);
			
			var size:uint = (length - (input.position - pos)) / 2;
			
			var table:Array = tag.codeTable;
			if (table.length != size) {
				table.length = size;
			}
			
			for (var i:uint = 0; i < size; ++i) {
				table[i] = input.readU16();
			}
			
			return tag;
		}
		
		public function readDefineFont2(input:DataInput, context:ReadingContext, tag:DefineFont2 = null):DefineFont2
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineFont2();
			}
			
			skipTagHeader(input);
			
			tag.fontId = input.readU16();
			
			input.resetBitCursor();
			
			tag.hasLayout = input.readBit();
			tag.isShiftJIS = input.readBit();
			if (context.version >= 7) {
				tag.isSmallText = input.readBit();
			}
			else {
				input.readBit();
			}
			tag.isANSI = input.readBit();
			var areWideOffsets:Boolean = input.readBit();
			tag.areWideCodes = input.readBit();
			tag.isItalic = input.readBit();
			tag.isBold = input.readBit();
			
			context.areWideCodes = tag.areWideCodes;
			
			if (context.version < 6) {
				readLanguageCode(input, context);
			}
			else {
				readLanguageCode(input, context, tag.languageCode);
			}
			
			var nameLen:uint = input.readU8();
			
			tag.fontName = readString(input, context, nameLen);
			
			var numGlyphs:uint = input.readU16();
			
			tag.numGlyphs = numGlyphs;
			
			var shapeTable:Array = tag.glyphShapeTable;
			var codeTable:Array = tag.codeTable;
			
			if (shapeTable.length != numGlyphs) {
				shapeTable.length = numGlyphs;
			}
			if (codeTable.length != numGlyphs) {
				codeTable.length = numGlyphs;
			}
			
			if (areWideOffsets) {
				for (var i:uint = 0; i < numGlyphs; ++i) {
					input.readU32();
				}
				input.readU32();
			}
			else {
				for (var j:uint = 0; j < numGlyphs; ++j) {
					input.readU16();
				}
				input.readU16();
			}
			for (var k:uint = 0; k < numGlyphs; ++k) {
				shapeTable[k] = readShape(input, context);
			}
			if (tag.areWideCodes) {
				for (var l:uint = 0; l < numGlyphs; ++l) {
					codeTable[l] = input.readU16();
				}
			}
			else {
				for (var m:uint = 0; m < numGlyphs; ++m) {
					codeTable[m] = input.readU8();
				}
			}
			
			if (tag.hasLayout) {
				tag.fontAscent = input.readS16();
				tag.fontDescent = input.readS16();
				tag.fontLeading = input.readS16();
				
				var advanceTable:Array = tag.fontAdvancedTable;
				var boundsTable:Array = tag.fontBoundsTable;
				
				if (advanceTable.length != numGlyphs) {
					advanceTable.length = numGlyphs;
				}
				if (boundsTable.length != numGlyphs) {
					boundsTable.length = numGlyphs;
				}
				
				for (var n:uint = 0; n < numGlyphs; ++n) {
					advanceTable[n] = input.readS16();
				}
				for (var o:uint = 0; o < numGlyphs; ++o) {
					boundsTable[o] = readRect(input, context);
				}
				
				var numKernings:uint = input.readU16();
				var kernings:Array = tag.kerningTable;
				if (kernings.length != numKernings) {
					kernings.length = numKernings;
				}
				
				for (var p:uint = 0; p < numKernings; ++p) {
					kernings[p] = readKerningRecord(input, context);
				}
			}
			
			return tag;
		}
		
		public function readDefineFont3(input:DataInput, context:ReadingContext, tag:DefineFont3 = null):DefineFont3
		{
			if (context.version < 8) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineFont3();
			}
			
			context.isHighPrecision = true;
			
			tag = readDefineFont2(input, context, tag) as DefineFont3;
			
			context.isHighPrecision = false;
			
			return tag;
		}
		
		public function readDefineFontAlignZones(input:DataInput, context:ReadingContext, tag:DefineFontAlignZones = null):DefineFontAlignZones
		{
			if (context.version < 8) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineFontAlignZones();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			var last:uint = input.position + length;
			
			tag.fontId = input.readU16();
			
			input.resetBitCursor();
			
			tag.csmTableHint = input.readUBits(2);
			
			input.readUBits(6);
			
			tag.clearZoneTable();
			
			for (; input.position != last;) {
				tag.addZoneRecord(readZoneRecord(input, context));
			}
			
			return tag;
		}
		
		public function readZoneRecord(input:DataInput, context:ReadingContext, record:ZoneRecord = null):ZoneRecord
		{
			if (!record) {
				record = new ZoneRecord();
			}
			
			var numZoneData:uint = input.readU8();
			var list:Array = record.zoneData;
			if (list.length != numZoneData) {
				list.length = numZoneData;
			}
			
			for (var i:uint = 0; i < numZoneData; ++i) {
				list[i] = readZoneData(input, context);
			}
			
			input.resetBitCursor();
			
			record.zoneMaskX = input.readBit();
			record.zoneMaskY = input.readBit();
			
			input.readUBits(6);
			
			return record;
		}
		
		public function readZoneData(input:DataInput, context:ReadingContext, data:ZoneData = null):ZoneData
		{
			if (!data) {
				data = new ZoneData();
			}
			
			data.alignmentCoordinate = input.readFloat16();
			data.range = input.readFloat16();
			
			return data;
		}
		
		public function readKerningRecord(input:DataInput, context:ReadingContext, record:KerningRecord = null):KerningRecord
		{
			if (!record) {
				record = new KerningRecord();
			}
			
			if (context.areWideCodes) {
				record.fontKerningCode1 = input.readU16();
				record.fontKerningCode2 = input.readU16();
			}
			else {
				record.fontKerningCode1 = input.readU8();
				record.fontKerningCode2 = input.readU8();
			}
			
			record.fontKerningAdjustment = input.readS16();
			
			return record;
		}
		
		public function readDefineFontName(input:DataInput, context:ReadingContext, tag:DefineFontName = null):DefineFontName
		{
			if (context.version < 9) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineFontName();
			}
			
			skipTagHeader(input);
			
			tag.fontId = input.readU16();
			tag.fontName = readString(input, context);
			tag.fontCopyright = readString(input, context);
			
			return tag;
		}
		
		public function readDefineText(input:DataInput, context:ReadingContext, tag:DefineText = null):DefineText
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineText();
			}
			
			skipTagHeader(input);
			
			if (context.tagType == 0) {
				context.tagType = 1;
			}
			
			tag.characterId = input.readU16();
			readRect(input, context, tag.textBounds);
			readMatrix(input, context, tag.textMatrix);
			
			context.glyphBits = input.readU8();
			context.advanceBits = input.readU8();
			
			tag.clearTextRecords();
			
			var record:TextRecord;
			
			while ((record = readTextRecord(input, context)) != null) {
				tag.addTextRecord(record);
			}
			
			context.tagType = 0;
			
			return tag;
		}
		
		public function readTextRecord(input:DataInput, context:ReadingContext, record:TextRecord = null):TextRecord
		{
			var flags:uint = input.readU8();
			
			if (flags == 0x00) {
				return null;
			}
			
			if (!record) {
				record = new TextRecord();
			}
			
			record.hasFont = (flags & 0x08) != 0;
			record.hasColor = (flags & 0x04) != 0;
			record.hasYOffset = (flags & 0x02) != 0;
			record.hasXOffset = (flags & 0x01) != 0;
			
			if (record.hasFont) {
				record.fontId = input.readU16();
			}
			if (record.hasColor) {
				if (context.tagType == 2) {
					readRGBA(input, context, record.textColor);
				}
				else {
					readRGB(input, context, record.textColor);
				}
			}
			if (record.hasXOffset) {
				record.xOffset = input.readS16();
			}
			if (record.hasYOffset) {
				record.yOffset = input.readS16();
			}
			if (record.hasFont) {
				record.textHeight = input.readU16();
			}
			
			var numGlyphs:uint = input.readU8();
			var entries:Array = record.glyphEntries;
			if (entries.length != numGlyphs) {
				entries.length = numGlyphs;
			}
			
			input.resetBitCursor();
			
			for (var i:uint = 0; i < numGlyphs; ++i) {
				entries[i] = readGlyphEntry(input, context);
			}
			
			return record;
		}
		
		public function readGlyphEntry(input:DataInput, context:ReadingContext, entry:GlyphEntry = null):GlyphEntry
		{
			if (!entry) {
				entry = new GlyphEntry();
			}
			
			entry.glyphIndex = input.readUBits(context.glyphBits);
			entry.glyphAdvance = input.readSBits(context.advanceBits);
			
			return entry;
		}
		
		public function readDefineText2(input:DataInput, context:ReadingContext, tag:DefineText2 = null):DefineText2
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineText2();
			}
			
			context.tagType = 2;
			
			return readDefineText(input, context, tag) as DefineText2;
		}
		
		public function readDefineEditText(input:DataInput, context:ReadingContext, tag:DefineEditText = null):DefineEditText
		{
			if (context.version < 4) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineEditText();
			}
			
			skipTagHeader(input);
			
			tag.characterId = input.readU16();
			readRect(input, context, tag.bounds);
			
			input.resetBitCursor();
			
			tag.hasText = input.readBit();
			tag.wordWrap = input.readBit();
			tag.multiline = input.readBit();
			tag.password = input.readBit();
			tag.readOnly = input.readBit();
			tag.hasTextColor = input.readBit();
			tag.hasMaxLength = input.readBit();
			tag.hasFont = input.readBit();
			tag.hasFontClass = input.readBit();
			tag.autoSize = input.readBit();
			tag.hasLayout = input.readBit();
			tag.noSelect = input.readBit();
			tag.border = input.readBit();
			tag.wasStatic = input.readBit();
			tag.html = input.readBit();
			tag.useOutlines = input.readBit();
			
			if (tag.hasFont) {
				tag.fontId = input.readU16();
			}
			if (tag.hasFontClass) {
				tag.fontClass = readString(input, context);
			}
			if (tag.hasFont) {
				tag.fontHeight = input.readU16();
			}
			if (tag.hasTextColor) {
				readRGBA(input, context, tag.textColor);
			}
			if (tag.hasMaxLength) {
				tag.maxLength = input.readU16();
			}
			if (tag.hasLayout) {
				tag.align = input.readU8();
				tag.leftMargin = input.readU16();
				tag.rightMargin = input.readU16();
				tag.indent = input.readU16();
				tag.leading = input.readS16();
			}
			tag.variableName = readString(input, context);
			if (tag.hasText) {
				tag.initialText = readString(input, context);
			}
			
			return tag;
		}
		
		public function readCSMTextSettings(input:DataInput, context:ReadingContext, tag:CSMTextSettings = null):CSMTextSettings
		{
			if (context.version < 8) {
				return null;
			}
			
			if (!tag) {
				tag = new CSMTextSettings();
			}
			
			skipTagHeader(input);
			
			tag.textId = input.readU16();
			
			input.resetBitCursor();
			
			tag.useFlashType = input.readUBits(2) != 0;
			tag.gridFit = input.readUBits(3);
			
			input.readUBits(3);
			
			tag.thickness = input.readFloat();
			tag.sharpness = input.readFloat();
			
			input.readU8();
			
			return tag;
		}
		
		public function readDefineSound(input:DataInput, context:ReadingContext, tag:DefineSound = null):DefineSound
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineSound();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			tag.soundId = input.readU16();
			
			input.resetBitCursor();
			
			tag.soundFormat = input.readUBits(4);
			tag.soundRate = input.readUBits(2);
			tag.soundSize = input.readUBits(1);
			tag.soundType = input.readUBits(1);
			tag.numSoundSamples = input.readU32();
			
			if (context.needsSoundData) {
				tag.soundData = readSoundData(input, tag.soundFormat, length - 7);
			}
			else {
				input.skip(length - 7);
			}
			
			return tag;
		}
		
		public function readStartSound(input:DataInput, context:ReadingContext, tag:StartSound = null):StartSound
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new StartSound();
			}
			
			skipTagHeader(input);
			
			tag.soundId = input.readU16();
			readSoundInfo(input, context, tag.soundInfo);
			
			return tag;
		}
		
		public function readStartSound2(input:DataInput, context:ReadingContext, tag:StartSound2 = null):StartSound2
		{
			if (context.version < 9) {
				return null;
			}
			
			if (!tag) {
				tag = new StartSound2();
			}
			
			skipTagHeader(input);
			
			tag.soundClassName = readString(input, context);
			readSoundInfo(input, context, tag.soundInfo);
			
			return tag;
		}
		
		public function readSoundInfo(input:DataInput, context:ReadingContext, info:SoundInfo = null):SoundInfo
		{
			if (!info) {
				info = new SoundInfo();
			}
			
			input.resetBitCursor();
			
			input.readUBits(2);
			
			info.syncStop = input.readBit();
			info.syncNoMultiple = input.readBit();
			info.hasEnvelope = input.readBit();
			info.hasLoops = input.readBit();
			info.hasOutPoint = input.readBit();
			info.hasInPoint = input.readBit();
			
			if (info.hasInPoint) {
				info.inPoint = input.readU32();
			}
			if (info.hasOutPoint) {
				info.outPoint = input.readU32();
			}
			if (info.hasLoops) {
				info.loopCount = input.readU16();
			}
			if (info.hasEnvelope) {
				var envPoints:uint = input.readU8();
				var envRecords:Array = info.envelopeRecords;
				if (envRecords.length != envPoints) {
					envRecords.length = envPoints;
				}
				for (var i:uint = 0; i < envPoints; ++i) {
					envRecords[i] = readSoundEnvelope(input, context);
				}
			}
			
			return info;
		}
		
		public function readSoundEnvelope(input:DataInput, context:ReadingContext, env:SoundEnvelope = null):SoundEnvelope
		{
			if(!env) {
				env = new SoundEnvelope();
			}
			
			env.pos44 = input.readU32();
			env.leftLevel = input.readU16();
			env.rightLevel = input.readU16();
			
			return env;
		}
		
		public function readSoundStreamHead(input:DataInput, context:ReadingContext, tag:SoundStreamHead = null):SoundStreamHead
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new SoundStreamHead();
			}
			
			skipTagHeader(input);
			
			input.resetBitCursor();
			
			input.readUBits(4);
			
			tag.playbackSoundRate = input.readUBits(2);
			tag.playbackSoundSize = input.readUBits(1);
			tag.playbackSoundType = input.readUBits(1);
			tag.streamSoundCompression = input.readUBits(4);
			tag.streamSoundRate = input.readUBits(2);
			tag.streamSoundSize = input.readUBits(1);
			tag.streamSoundType = input.readUBits(1);
			tag.numStreamSoundSamples = input.readU16();
			
			if (tag.streamSoundCompression == SoundFormatConstants.MP3) {
				tag.latencySeek = input.readS16();
			}
			
			context.soundStreamFormat = tag.streamSoundCompression;
			
			return tag;
		}
		
		public function readSoundStreamHead2(input:DataInput, context:ReadingContext, tag:SoundStreamHead2 = null):SoundStreamHead2
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new SoundStreamHead2();
			}
			
			return readSoundStreamHead(input, context, tag) as SoundStreamHead2;
		}
		
		public function readSoundStreamBlock(input:DataInput, context:ReadingContext, tag:SoundStreamBlock = null):SoundStreamBlock
		{
			if (context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new SoundStreamBlock();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			if (context.needsSoundData) {
				tag.streamSoundData = readSoundData(input, context.soundStreamFormat, length, true);
			}
			else {
				input.skip(length);
			}
			
			return tag;
		}
		
		private function readSoundData(input:DataInput, format:uint, length:uint, isStream:Boolean = false):SoundData
		{
			switch (format) {
				case SoundFormatConstants.UNCOMPRESSED:
				case SoundFormatConstants.UNCOMPRESSED_LITTLE_ENDIAN:
					return readSoundDataUncompressed(input, length);
					
				case SoundFormatConstants.ADPCM:
					return readSoundDataADPCM(input, length);
				
				case SoundFormatConstants.MP3:
					return isStream ? readSoundDataMP3Stream(input, length) : readSoundDataMP3(input, length);
				
				case SoundFormatConstants.NELLYMOSER:
					return readSoundDataNellymoser(input, length);
			}
			return null;
		}
		
		private function readSoundDataUncompressed(input:DataInput, length:uint):SoundDataUncompressed
		{
			var data:SoundDataUncompressed = new SoundDataUncompressed();
			
			if (length > 0) {
				input.readBytes(data.soundData, length);
			}
			
			return data;
		}
		
		private function readSoundDataADPCM(input:DataInput, length:uint):SoundDataADPCM
		{
			var data:SoundDataADPCM = new SoundDataADPCM();
			
			if (length > 0) {
				input.readBytes(data.soundData, length);
			}
			
			return data;
		}
		
		private function readSoundDataMP3(input:DataInput, length:uint, data:SoundDataMP3 = null):SoundDataMP3
		{
			if (!data) {
				data = new SoundDataMP3();
			}
			
			data.seekSamples = input.readS16();
			
			if ((length - 2) > 0) {
				input.readBytes(data.mp3Frames, length - 2);
			}
			
			return data;
		}
		
		private function readSoundDataMP3Stream(input:DataInput, length:uint):SoundDataMP3Stream
		{
			var data:SoundDataMP3Stream = new SoundDataMP3Stream();
			
			data.numSamples = input.readU16();
			
			readSoundDataMP3(input, length - 2, data.mp3SoundData);
			
			return data;
		}
		
		private function readSoundDataNellymoser(input:DataInput, length:uint):SoundDataNellymoser
		{
			var data:SoundDataNellymoser = new SoundDataNellymoser();
			
			if (length > 0) {
				input.readBytes(data.soundData, length);
			}
			
			return data;
		}
		
		public function readButtonRecord(input:DataInput, context:ReadingContext, record:ButtonRecord = null):ButtonRecord
		{
			var flags:uint = input.readU8();
			
			if (flags == 0x00) {
				return null;
			}
			
			if (!record) {
				record = new ButtonRecord();
			}
			
			if (context.version >= 8) {
				record.hasBlendMode = (flags & 0x20) != 0;
				record.hasFilterList = (flags & 0x10) != 0;
			}
			
			record.stateHitTest = (flags & 0x08) != 0;
			record.stateDown = (flags & 0x04) != 0;
			record.stateOver = (flags & 0x02) != 0;
			record.stateUp = (flags & 0x01) != 0;
			
			record.characterId = input.readU16();
			record.placeDepth = input.readU16();
			readMatrix(input, context, record.placeMatrix);
			
			if (context.tagType == 2) {
				readCXFormWithAlpha(input, context, record.colorTransform);
				if (record.hasFilterList) {
					readFilterList(input, context, record.filterList);
				}
				if (record.hasBlendMode) {
					record.blendMode = input.readU8();
				}
			}
			
			return record;
		}
		
		public function readDefineButton(input:DataInput, context:ReadingContext, tag:DefineButton = null):DefineButton
		{
			if(context.version < 1) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineButton();
			}
			
			skipTagHeader(input);
			
			context.tagType = 1;
			
			tag.buttonId = input.readU16();
			
			tag.clearCharacters();
			
			var record:ButtonRecord;
			while ((record = readButtonRecord(input, context)) != null) {
				tag.addCharacter(record);
			}
			
			context.actionRecordSize = 0;
			
			readActionRecords(input, context, tag.actions);
			
			context.tagType = 0;
			
			return tag;
		}
		
		public function readDefineButton2(input:DataInput, context:ReadingContext, tag:DefineButton2 = null):DefineButton2
		{
			if(context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineButton2();
			}
			
			skipTagHeader(input);
			
			context.tagType = 2;
			
			tag.buttonId = input.readU16();
			
			input.resetBitCursor();
			input.readUBits(7);
			
			tag.trackAsMenu = input.readBit();
			
			var actionOffset:uint = input.readU16();
			
			tag.clearCharacters();
			
			var record:ButtonRecord;
			while ((record = readButtonRecord(input, context)) != null) {
				tag.addCharacter(record);
			}
			
			tag.clearActions();
			
			context.actionRecordSize = 0;
			
			while (actionOffset != 0) {
				var action:ButtonCondAction = new ButtonCondAction();
				actionOffset = input.readU16();
				input.resetBitCursor();
				action.condIdleToOverDown = input.readBit();
				action.condOutDownToIdle = input.readBit();
				action.condOutDownToOverDown = input.readBit();
				action.condOverDownToOutDown = input.readBit();
				action.condOverDownToOverUp = input.readBit();
				action.condOverUpToOverDown = input.readBit();
				action.condOverUpToIdle = input.readBit();
				action.condIdleToOverUp = input.readBit();
				action.condKeyPress = input.readUBits(7);
				if (context.version < 4) {
					action.condKeyPress = 0;
				}
				action.condOverDownToIdle = input.readBit();
				readActionRecords(input, context, action.actions);
				tag.addAction(action);
			}
			
			context.tagType = 0;
			
			return tag;
		}
		
		public function readDefineButtonCxform(input:DataInput, context:ReadingContext, tag:DefineButtonCxform = null):DefineButtonCxform
		{
			if (context.version < 2) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineButtonCxform();
			}
			
			skipTagHeader(input);
			
			tag.buttonId = input.readU16();
			readCXForm(input, context, tag.buttonColorTransform);
			
			return tag;
		}
		
		public function readDefineButtonSound(input:DataInput, context:ReadingContext, tag:DefineButtonSound = null):DefineButtonSound
		{
			if (context.version < 2) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineButtonSound();
			}
			
			skipTagHeader(input);
			
			tag.buttonId = input.readU16();
			tag.buttonSoundChar0 = input.readU16();
			if (tag.buttonSoundChar0 != 0x0000) {
				readSoundInfo(input, context, tag.buttonSoundInfo0);
			}
			tag.buttonSoundChar1 = input.readU16();
			if (tag.buttonSoundChar1 != 0X0000) {
				readSoundInfo(input, context, tag.buttonSoundInfo1);
			}
			tag.buttonSoundChar2 = input.readU16();
			if (tag.buttonSoundChar2 != 0x0000) {
				readSoundInfo(input, context, tag.buttonSoundInfo2);
			}
			tag.buttonSoundChar3 = input.readU16();
			if (tag.buttonSoundChar3 != 0x0000) {
				readSoundInfo(input, context, tag.buttonSoundInfo3);
			}
			
			return tag;
		}
		
		public function readDefineSprite(input:DataInput, context:ReadingContext, tag:DefineSprite = null):DefineSprite
		{
			if (context.version < 3) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineSprite();
			}
			
			skipTagHeader(input);
			
			tag.spriteId = input.readU16();
			tag.numFrames = input.readU16();
			readTags(input, context, tag.tags);
			
			return tag;
		}
		
		public function readDefineVideoStream(input:DataInput, context:ReadingContext, tag:DefineVideoStream = null):DefineVideoStream
		{
			if (context.version < 6) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineVideoStream();
			}
			
			skipTagHeader(input);
			
			tag.characterId = input.readU16();
			tag.numFrames = input.readU16();
			tag.width = input.readU16();
			tag.height = input.readU16();
			
			input.resetBitCursor();
			input.readUBits(4);
			
			tag.deblockingFlags = input.readUBits(3);
			tag.smoothing = input.readBit();
			tag.codecId = input.readU8();
			
			return tag;
		}
		
		public function readVideoFrame(input:DataInput, context:ReadingContext, tag:VideoFrame = null):VideoFrame
		{
			if (context.version < 6) {
				return null;
			}
			
			if (!tag) {
				tag = new VideoFrame();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			tag.streamId = input.readU16();
			tag.frameNumber = input.readU16();
			
			if (context.needsVideoData) {
				if ((length - 4) > 0) {
					input.readBytes(tag.videoData, length - 4);
				}
			}
			else {
				input.skip(length - 4);
			}
			
			return tag;
		}
		
		public function readDefineBinaryData(input:DataInput, context:ReadingContext, tag:DefineBinaryData = null):DefineBinaryData
		{
			if (context.version < 9) {
				return null;
			}
			
			if (!tag) {
				tag = new DefineBinaryData();
			}
			
			readTagCode(input);
			
			var length:uint = readTagLength(input, context);
			
			tag.characterId = input.readU16();
			
			input.readU32();
			
			if (context.needsBinaryData) {
				if ((length - 6) > 0) {
					input.readBytes(tag.data, length - 6);
				}
			}
			else {
				input.skip(length - 6);
			}
			
			return tag;
		}
	}
}