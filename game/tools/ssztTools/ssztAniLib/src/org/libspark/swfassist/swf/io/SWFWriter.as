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

package org.libspark.swfassist.swf.io
{
    import flash.utils.ByteArray;
    
    import org.libspark.swfassist.errors.ErrorHandler;
    import org.libspark.swfassist.errors.Warning;
    import org.libspark.swfassist.io.ByteArrayOutputStream;
    import org.libspark.swfassist.io.DataOutput;
    import org.libspark.swfassist.swf.actions.ActionRecords;
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
    import org.libspark.swfassist.swf.structures.ShapeRecord;
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
    import org.libspark.swfassist.utils.BitwiseUtil;
    
    public class SWFWriter
    {
        private var _tagData:ByteArrayOutputStream = new ByteArrayOutputStream(new ByteArray());
        
        private function error(context:WritingContext, id:uint, message:String = ''):void
        {
            var e:Error = new Error(message, id);
            var handler:ErrorHandler = context.errorHandler;
            
            if (!handler || !handler.handleError(e)) {
                throw e;
            }
        }
        
        private function warning(context:WritingContext, id:uint, message:String):void
        {
            var w:Warning = new Warning(message, id);
            var handler:ErrorHandler = context.errorHandler;
            
            if (!handler || !handler.handleWarning(w)) {
                throw w;
            }
        }
        
        public function writeSWF(output:DataOutput, context:WritingContext, swf:SWF):void
        {
            if (!context.ignoreSWFVersion) {
                context.version = swf.header.version;
            }
            
            if (context.offset == 0) {
                writeHeader(output, context, swf.header);
                
                if (context.version >= 8) {
                    writeFileAttributes(output, context, swf.fileAttributes);
                }
            }
            
            writeTags(output, context, swf.tags);
            
            if (context.length == 0 || swf.tags.numTags < (context.offset + context.length)) {
                writeEnd(output, context, new End());
                
                if (context.fileLengthPosition != 0) {
                    output.position = context.fileLengthPosition;
                    output.writeU32(output.length);
                }
                
                if (swf.header.isCompressed) {
                    output.compress(8);
                }
            }
        }
        
        public function writeHeader(output:DataOutput, context:WritingContext, header:Header):void
        {
            output.writeU8(header.isCompressed ? 0x43 : 0x46);
            output.writeU8(0x57);
            output.writeU8(0x53);
            output.writeU8(header.version);
            context.fileLengthPosition = output.position;
            output.writeU32(0);
            writeRect(output, context, header.frameSize);
            output.writeFixed8(header.frameRate);
            output.writeU16(header.numFrames);
        }
        
        private function writeTagHeader(output:DataOutput, tag:Tag, length:uint = 0):void
        {
            if( tag is DoABC )
            {
                var tmp:ByteArray = new ByteArray();
                tmp[0] = 0x3f;
                tmp[1] = 0x12;
                output.writeBytes( tmp );
                output.writeU32(length);
                return;				
            }
            
            if( tag is End )
            {
                var tmp:ByteArray = new ByteArray();
                tmp[0] = 0x40;
                tmp[1] = 0x00;
                output.writeBytes( tmp );
                return;
            }
            
            
            
            if (length >= 0x3f) {
                output.writeU16((tag.code << 6) | 0x3f);
                output.writeU32(length);
                // trace(tag.code, uint((tag.code << 6) | 0x3f).toString(16), length.toString(16));
            }
            else {
                output.writeU16((tag.code << 6) | length);
                // trace(tag.code, uint((tag.code << 6) | length).toString(16));
            }
        }
        
        private function endTag(output:DataOutput, data:ByteArray, tag:Tag):void
        {
            writeTagHeader(output, tag, data.length);
            
            if (data.length > 0) {
                output.writeBytes(data);
                data.length = 0;
            }
        }
        
        private function writeTags(output:DataOutput, context:WritingContext, tags:Tags):void
        {
            var list:Array = tags.tags;
            var l:uint = context.length == 0 ? list.length : Math.min(list.length, context.offset + context.length);
            
            for (var i:uint = context.offset; i < l; ++i) {
                var tag:Tag = Tag(list[i]);
                
                if (tag is Unknown) {
                    continue;
                }
                
                switch (tag.code) {
                    case TagCodeConstants.TAG_PLACE_OBJECT:
                        writePlaceObject(output, context, PlaceObject(tag));
                        break;
                    
                    case TagCodeConstants.TAG_PLACE_OBJECT2:
                        writePlaceObject2(output, context, PlaceObject2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_PLACE_OBJECT3:
                        writePlaceObject3(output, context, PlaceObject3(tag));
                        break;
                    
                    case TagCodeConstants.TAG_REMOVE_OBJECT:
                        writeRemoveObject(output, context, RemoveObject(tag));
                        break;
                    
                    case TagCodeConstants.TAG_REMOVE_OBJECT2:
                        writeRemoveObject2(output, context, RemoveObject2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_SHOW_FRAME:
                        writeShowFrame(output, context, ShowFrame(tag));
                        break;
                    
                    case TagCodeConstants.TAG_SET_BACKGROUND_COLOR:
                        //writeSetBackgroundColor(output, context, SetBackgroundColor(tag));
                        break;
                    
                    case TagCodeConstants.TAG_FRAME_LABEL:
                        writeFrameLabel(output, context, FrameLabel(tag));
                        break;
                    
                    case TagCodeConstants.TAG_PROTECT:
                        writeProtect(output, context, Protect(tag));
                        break;
                    
                    case TagCodeConstants.TAG_END:
                        writeEnd(output, context, End(tag));
                        break;
                    
                    case TagCodeConstants.TAG_EXPORT_ASSETS:
                        writeExportAssets(output, context, ExportAssets(tag));
                        break;
                    
                    case TagCodeConstants.TAG_IMPORT_ASSETS:
                        writeImportAssets(output, context, ImportAssets(tag));
                        break;
                    
                    case TagCodeConstants.TAG_ENABLE_DEBUGGER:
                        writeEnableDebugger(output, context, EnableDebugger(tag));
                        break;
                    
                    case TagCodeConstants.TAG_ENABLE_DEBUGGER2:
                        writeEnableDebugger2(output, context, EnableDebugger2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_SCRIPT_LIMITS:
                        writeScriptLimits(output, context, ScriptLimits(tag));
                        break;
                    
                    case TagCodeConstants.TAG_SET_TAB_INDEX:
                        writeSetTabIndex(output, context, SetTabIndex(tag));
                        break;
                    
                    case TagCodeConstants.TAG_FILE_ATTRIBUTES:
                        writeFileAttributes(output, context, FileAttributes(tag));
                        break;
                    
                    case TagCodeConstants.TAG_IMPORT_ASSETS2:
                        writeImportAssets2(output, context, ImportAssets2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_SYMBOL_CLASS:
                        writeSymbolClass(output, context, SymbolClass(tag));
                        break;
                    
                    case TagCodeConstants.TAG_METADATA:
                        writeMetadata(output, context, Metadata(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_SCALING_GRID:
                        writeDefineScalingGrid(output, context, DefineScalingGrid(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_SCENE_AND_FRAME_LABEL_DATA:
                        writeDefineSceneAndFrameLabelData(output, context, DefineSceneAndFrameLabelData(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DO_ACTION:
                        writeDoAction(output, context, DoAction(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DO_INIT_ACTION:
                        writeDoInitAction(output, context, DoInitAction(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DO_ABC:
                        writeDoABC(output, context, DoABC(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_SHAPE:
                        writeDefineShape(output, context, DefineShape(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_SHAPE2:
                        writeDefineShape2(output, context, DefineShape2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_SHAPE3:
                        writeDefineShape3(output, context, DefineShape3(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_SHAPE4:
                        writeDefineShape4(output, context, DefineShape4(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_BITS:
                        writeDefineBits(output, context, DefineBits(tag));
                        break;
                    
                    case TagCodeConstants.TAG_JPEG_TABLES:
                        writeJPEGTables(output, context, JPEGTables(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_BITS_JPEG2:
                        writeDefineBitsJPEG2(output, context, DefineBitsJPEG2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_BITS_JPEG3:
                        writeDefineBitsJPEG3(output, context, DefineBitsJPEG3(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_BITS_LOSSLESS:
                        writeDefineBitsLossless(output, context, DefineBitsLossless(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_BITS_LOSSLESS2:
                        writeDefineBitsLossless2(output, context, DefineBitsLossless2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_MORPH_SHAPE:
                        writeDefineMorphShape(output, context, DefineMorphShape(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_MORPH_SHAPE2:
                        writeDefineMorphShape2(output, context, DefineMorphShape2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_FONT:
                        writeDefineFont(output, context, DefineFont(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_FONT_INFO:
                        writeDefineFontInfo(output, context, DefineFontInfo(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_FONT_INFO2:
                        writeDefineFontInfo2(output, context, DefineFontInfo2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_FONT2:
                        writeDefineFont2(output, context, DefineFont2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_FONT3:
                        writeDefineFont3(output, context, DefineFont3(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_FONT_ALIGN_ZONES:
                        writeDefineFontAlignZones(output, context, DefineFontAlignZones(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_FONT_NAME:
                        writeDefineFontName(output, context, DefineFontName(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_TEXT:
                        writeDefineText(output, context, DefineText(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_TEXT2:
                        writeDefineText2(output, context, DefineText2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_EDIT_TEXT:
                        writeDefineEditText(output, context, DefineEditText(tag));
                        break;
                    
                    case TagCodeConstants.TAG_CSMTEXT_SETTINGS:
                        writeCSMTextSettings(output, context, CSMTextSettings(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_SOUND:
                        writeDefineSound(output, context, DefineSound(tag));
                        break;
                    
                    case TagCodeConstants.TAG_START_SOUND:
                        writeStartSound(output, context, StartSound(tag));
                        break;
                    
                    case TagCodeConstants.TAG_START_SOUND2:
                        writeStartSound2(output, context, StartSound2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_SOUND_STREAM_HEAD:
                        writeSoundStreamHead(output, context, SoundStreamHead(tag));
                        break;
                    
                    case TagCodeConstants.TAG_SOUND_STREAM_HEAD2:
                        writeSoundStreamHead2(output, context, SoundStreamHead2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_SOUND_STREAM_BLOCK:
                        writeSoundStreamBlock(output, context, SoundStreamBlock(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_BUTTON:
                        writeDefineButton(output, context, DefineButton(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_BUTTON2:
                        writeDefineButton2(output, context, DefineButton2(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_BUTTON_CXFORM:
                        writeDefineButtonCxform(output, context, DefineButtonCxform(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_BUTTON_SOUND:
                        writeDefineButtonSound(output, context, DefineButtonSound(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_SPRITE:
                        writeDefineSprite(output, context, DefineSprite(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_VIDEO_STREAM:
                        writeDefineVideoStream(output, context, DefineVideoStream(tag));
                        break;
                    
                    case TagCodeConstants.TAG_VIDEO_FRAME:
                        writeVideoFrame(output, context, VideoFrame(tag));
                        break;
                    
                    case TagCodeConstants.TAG_DEFINE_BINARY_DATA:
                        writeDefineBinaryData(output, context, DefineBinaryData(tag));
                        break;
                }
            }
        }
        
        public function writeString(output:DataOutput, context:WritingContext, value:String, isNullTerminated:Boolean = true):void
        {
            if (context.version <= 5) {
                output.writeString(value, 'shift-jis', isNullTerminated);
            }
            else {
                output.writeUTF(value, isNullTerminated);
            }
        }
        
        public function writeLanguageCode(output:DataOutput, context:WritingContext, languageCode:LanguageCode):void
        {
            output.writeU8(languageCode.code);
        }
        
        public function writeRGB(output:DataOutput, context:WritingContext, rgb:RGB):void
        {
            output.writeU8(rgb.red);
            output.writeU8(rgb.green);
            output.writeU8(rgb.blue);
        }
        
        public function writeRGBA(output:DataOutput, context:WritingContext, rgba:RGBA):void
        {
            writeRGB(output, context, rgba);
            output.writeU8(rgba.alpha);
        }
        
        public function writeARGB(output:DataOutput, context:WritingContext, argb:ARGB):void
        {
            output.writeU8(argb.alpha);
            writeRGB(output, context, argb);
        }
        
        public function writeRect(output:DataOutput, context:WritingContext, rect:Rect):void
        {
            output.resetBitCursor();
            
            var numBits:uint = BitwiseUtil.getMinSBits(rect.xMinTwips, rect.xMaxTwips, rect.yMinTwips, rect.yMaxTwips);
            
            output.writeUBits(5, numBits);
            output.writeSBits(numBits, rect.xMinTwips);
            output.writeSBits(numBits, rect.xMaxTwips);
            output.writeSBits(numBits, rect.yMinTwips);
            output.writeSBits(numBits, rect.yMaxTwips);
        }
        
        public function writeMatrix(output:DataOutput, context:WritingContext, matrix:Matrix):void
        {
            output.resetBitCursor();
            
            output.writeBit(matrix.hasScale);
            
            if (matrix.hasScale) {
                var scaleBits:uint = BitwiseUtil.getMinFBits(matrix.scaleX, matrix.scaleY);
                output.writeUBits(5, scaleBits);
                output.writeFBits(scaleBits, matrix.scaleX);
                output.writeFBits(scaleBits, matrix.scaleY);
            }
            
            output.writeBit(matrix.hasRotate);
            
            if (matrix.hasRotate) {
                var rotateBits:uint = BitwiseUtil.getMinFBits(matrix.rotateSkew0, matrix.rotateSkew1);
                output.writeUBits(5, rotateBits);
                output.writeFBits(rotateBits, matrix.rotateSkew0);
                output.writeFBits(rotateBits, matrix.rotateSkew1);
            }
            
            var translateBits:uint = BitwiseUtil.getMinSBits(matrix.translateXTwips, matrix.translateYTwips);
            output.writeUBits(5, translateBits);
            output.writeSBits(translateBits, matrix.translateXTwips);
            output.writeSBits(translateBits, matrix.translateYTwips);
        }
        
        public function writeCXForm(output:DataOutput, context:WritingContext, cxform:CXForm):void
        {
            output.resetBitCursor();
            
            output.writeBit(cxform.hasAddition);
            output.writeBit(cxform.hasMultiplication);
            
            var numBits:uint = Math.max(BitwiseUtil.getMinSBits(cxform.redMultiplication, cxform.greenMultiplication, cxform.blueMultiplication),
                BitwiseUtil.getMinSBits(cxform.redAddition, cxform.greenAddition, cxform.blueAddition));
            
            output.writeUBits(4, numBits);
            
            if (cxform.hasMultiplication) {
                output.writeSBits(numBits, cxform.redMultiplication);
                output.writeSBits(numBits, cxform.greenMultiplication);
                output.writeSBits(numBits, cxform.blueMultiplication);
            }
            
            if (cxform.hasAddition) {
                output.writeSBits(numBits, cxform.redAddition);
                output.writeSBits(numBits, cxform.greenAddition);
                output.writeSBits(numBits, cxform.blueAddition);
            }
        }
        
        public function writeCXFormWithAlpha(output:DataOutput, context:WritingContext, cxform:CXFormWithAlpha):void
        {
            output.resetBitCursor();
            
            output.writeBit(cxform.hasAddition);
            output.writeBit(cxform.hasMultiplication);
            
            var numBits:uint = Math.max(BitwiseUtil.getMinSBits(cxform.redMultiplication, cxform.greenMultiplication, cxform.blueMultiplication, cxform.alphaMultiplication),
                BitwiseUtil.getMinSBits(cxform.redAddition, cxform.greenAddition, cxform.blueAddition, cxform.alphaAddition));
            
            output.writeUBits(4, numBits);
            
            if (cxform.hasMultiplication) {
                output.writeSBits(numBits, cxform.redMultiplication);
                output.writeSBits(numBits, cxform.greenMultiplication);
                output.writeSBits(numBits, cxform.blueMultiplication);
                output.writeSBits(numBits, cxform.alphaMultiplication);
            }
            
            if (cxform.hasAddition) {
                output.writeSBits(numBits, cxform.redAddition);
                output.writeSBits(numBits, cxform.greenAddition);
                output.writeSBits(numBits, cxform.blueAddition);
                output.writeSBits(numBits, cxform.alphaAddition);
            }
        }
        
        public function writePlaceObject(output:DataOutput, context:WritingContext, tag:PlaceObject):void
        {
            if (context.version < 1) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            _tagData.writeU16(tag.depth);
            writeMatrix(_tagData, context, tag.matrix);
            writeCXForm(_tagData, context, tag.colorTransform);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writePlaceObject2(output:DataOutput, context:WritingContext, tag:PlaceObject2):void
        {
            if (context.version < 3) {
                return;
            }
            
            _tagData.resetBitCursor();
            _tagData.writeBit(context.version >= 5 ? tag.hasClipActions : false);
            _tagData.writeBit(tag.hasClipDepth);
            _tagData.writeBit(tag.hasName);
            _tagData.writeBit(tag.hasRatio);
            _tagData.writeBit(tag.hasColorTransform);
            _tagData.writeBit(tag.hasMatrix);
            _tagData.writeBit(tag.hasCharacter);
            _tagData.writeBit(tag.isMove);
            
            _tagData.writeU16(tag.depth);
            
            if (tag.hasCharacter) {
                _tagData.writeU16(tag.characterId);
            }
            if (tag.hasMatrix) {
                writeMatrix(_tagData, context, tag.matrix);
            }
            if (tag.hasColorTransform) {
                writeCXFormWithAlpha(_tagData, context, tag.colorTransform);
            }
            if (tag.hasRatio) {
                _tagData.writeU16(tag.ratio);
            }
            if (tag.hasName) {
                writeString(_tagData, context, tag.name);
            }
            if (tag.hasClipDepth) {
                _tagData.writeU16(tag.clipDepth);
            }
            if (context.version >= 5 && tag.hasClipActions) {
                writeClipActions(_tagData, context, tag.clipActions);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeClipActions(output:DataOutput, context:WritingContext, clipActions:ClipActions):void
        {
            output.writeU16(0x00);
            
            writeClipEventFlags(output, context, clipActions.allEventFlags);
            
            var begin:uint;
            
            for each (var record:ClipActionRecord in clipActions.clipActionRecords) {
                writeClipEventFlags(output, context, record.eventFlags);
                
                begin = output.position;
                
                output.writeU32(0x00);
                
                if (record.eventFlags.eventKeyPress) {
                    output.writeU8(record.keyCode);
                }
                
                writeActionRecords(output, context, record.actions);
                
                var end:uint = output.position;
                
                output.position = begin;
                output.writeU32(end - (begin + 4));
                output.position = end;
            }
            
            if (context.version >= 6) {
                output.writeU32(0x00);
            }
            else {
                output.writeU16(0x00);
            }
        }
        
        public function writePlaceObject3(output:DataOutput, context:WritingContext, tag:PlaceObject3):void
        {
            if (context.version < 8) {
                return;
            }
            
            _tagData.resetBitCursor();
            _tagData.writeBit(context.version >= 5 ? tag.hasClipActions : false);
            _tagData.writeBit(tag.hasClipDepth);
            _tagData.writeBit(tag.hasName);
            _tagData.writeBit(tag.hasRatio);
            _tagData.writeBit(tag.hasColorTransform);
            _tagData.writeBit(tag.hasMatrix);
            _tagData.writeBit(tag.hasCharacter);
            _tagData.writeBit(tag.isMove);
            
            _tagData.writeUBits(3, 0x00);
            
            _tagData.writeBit(tag.hasImage);
            _tagData.writeBit(tag.hasClassName);
            _tagData.writeBit(tag.hasCacheAsBitmap);
            _tagData.writeBit(tag.hasBlendMode);
            _tagData.writeBit(tag.hasFilterList);
            
            _tagData.writeU16(tag.depth);
            
            if (tag.hasClassName || (tag.hasImage && tag.hasCharacter)) {
                writeString(_tagData, context, tag.className);
            }
            if (tag.hasCharacter) {
                _tagData.writeU16(tag.characterId);
            }
            if (tag.hasMatrix) {
                writeMatrix(_tagData, context, tag.matrix);
            }
            if (tag.hasColorTransform) {
                writeCXFormWithAlpha(_tagData, context, tag.colorTransform);
            }
            if (tag.hasRatio) {
                _tagData.writeU16(tag.ratio);
            }
            if (tag.hasName) {
                writeString(_tagData, context, tag.name);
            }
            if (tag.hasClipDepth) {
                _tagData.writeU16(tag.clipDepth);
            }
            if (tag.hasFilterList) {
                writeFilterList(_tagData, context, tag.filterList);
            }
            if (tag.hasBlendMode) {
                _tagData.writeU8(tag.blendMode);
            }
            if (context.version >= 5 && tag.hasClipActions) {
                writeClipActions(_tagData, context, tag.clipActions);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeFilterList(output:DataOutput, context:WritingContext, list:FilterList):void
        {
            output.writeU8(list.numFilters);
            
            for each (var filter:Filter in list.filters) {
                writeFilter(output, context, filter);
            }
        }
        
        public function writeFilter(output:DataOutput, context:WritingContext, filter:Filter):void
        {
            output.writeU8(filter.filterId);
            
            switch (filter.filterId) {
                case FilterConstants.ID_DROP_SHADOW:
                    writeDropShadowFilter(output, context, DropShadowFilter(filter));
                    break;
                case FilterConstants.ID_BLUR:
                    writeBlurFilter(output, context, BlurFilter(filter));
                    break;
                case FilterConstants.ID_GLOW:
                    writeGlowFilter(output, context, GlowFilter(filter));
                    break;
                case FilterConstants.ID_BEVEL:
                    writeBevelFilter(output, context, BevelFilter(filter));
                    break;
                case FilterConstants.ID_GRADIENT_GLOW:
                    writeGradientGlowFilter(output, context, GradientGlowFilter(filter));
                    break;
                case FilterConstants.ID_CONVOLUTION:
                    writeConvolutionFilter(output, context, ConvolutionFilter(filter));
                    break;
                case FilterConstants.ID_COLOR_MATRIX:
                    writeColorMatrixFilter(output, context, ColorMatrixFilter(filter));
                    break;
                case FilterConstants.ID_GRADIENT_BEVEL:
                    writeGradientBevelFilter(output, context, GradientBevelFilter(filter));
                    break;
            }
        }
        
        public function writeColorMatrixFilter(output:DataOutput, context:WritingContext, filter:ColorMatrixFilter):void
        {
            var matrix:Array = filter.matrix;
            
            for (var i:uint = 0; i < 20; ++i) {
                output.writeFloat(matrix[i]);
            }
        }
        
        public function writeConvolutionFilter(output:DataOutput, context:WritingContext, filter:ConvolutionFilter):void
        {
            output.writeU8(filter.matrixX);
            output.writeU8(filter.matrixY);
            output.writeFloat(filter.divisor);
            output.writeFloat(filter.bias);
            
            var matrix:Array = filter.matrix;
            var l:uint = filter.matrixX * filter.matrixY;
            
            for (var i:uint = 0; i < l; ++i) {
                output.writeFloat(matrix[i]);
            }
            
            writeRGBA(output, context, filter.defaultColor);
            
            output.resetBitCursor();
            output.writeUBits(6, 0x00);
            output.writeBit(filter.clamp);
            output.writeBit(filter.preserveAlpha);
        }
        
        public function writeBlurFilter(output:DataOutput, context:WritingContext, filter:BlurFilter):void
        {
            output.writeFixed(filter.blurX);
            output.writeFixed(filter.blurY);
            output.resetBitCursor();
            output.writeUBits(5, filter.passes);
            output.writeUBits(3, 0x00);
        }
        
        public function writeDropShadowFilter(output:DataOutput, context:WritingContext, filter:DropShadowFilter):void
        {
            writeRGBA(output, context, filter.dropShadowColor);
            
            output.writeFixed(filter.blurX);
            output.writeFixed(filter.blurY);
            output.writeFixed(filter.angle);
            output.writeFixed(filter.distance);
            output.writeFixed8(filter.strength);
            output.resetBitCursor();
            output.writeBit(filter.innerShadow);
            output.writeBit(filter.knockout);
            output.writeBit(true);
            output.writeUBits(5, filter.passes);
        }
        
        public function writeGlowFilter(output:DataOutput, context:WritingContext, filter:GlowFilter):void
        {
            writeRGBA(output, context, filter.glowColor);
            
            output.writeFixed(filter.blurX);
            output.writeFixed(filter.blurY);
            output.writeFixed8(filter.strength);
            
            output.resetBitCursor();
            
            output.writeBit(filter.innerGlow);
            output.writeBit(filter.knockout);
            output.writeBit(true);
            output.writeUBits(5, filter.passes);
        }
        
        public function writeBevelFilter(output:DataOutput, context:WritingContext, filter:BevelFilter):void
        {
            writeRGBA(output, context, filter.shadowColor);
            writeRGBA(output, context, filter.highlightColor);
            
            output.writeFixed(filter.blurX);
            output.writeFixed(filter.blurY);
            output.writeFixed(filter.angle);
            output.writeFixed(filter.distance);
            output.writeFixed8(filter.strength);
            
            output.resetBitCursor();
            
            output.writeBit(filter.innerShadow);
            output.writeBit(filter.knockout);
            output.writeBit(true);
            output.writeBit(filter.onTop);
            output.writeUBits(4, filter.passes);
        }
        
        public function writeGradientGlowFilter(output:DataOutput, context:WritingContext, filter:GradientGlowFilter):void
        {
            var colors:Array = filter.gradientColors;
            var ratios:Array = filter.gradientRatio;
            
            var numColors:uint = colors.length;
            
            output.writeU8(numColors);
            
            for (var i:uint = 0; i < numColors; ++i) {
                writeRGBA(output, context, colors[i]);
            }
            for (var j:uint = 0; j < numColors; ++j) {
                output.writeU8(ratios[j]);
            }
            
            output.writeFixed(filter.blurX);
            output.writeFixed(filter.blurY);
            output.writeFixed(filter.angle);
            output.writeFixed(filter.distance);
            output.writeFixed8(filter.strength);
            
            output.resetBitCursor();
            
            output.writeBit(filter.innerShadow);
            output.writeBit(filter.knockout);
            output.writeBit(true);
            output.writeBit(filter.onTop);
            output.writeUBits(4, filter.passes);
        }
        
        public function writeGradientBevelFilter(output:DataOutput, context:WritingContext, filter:GradientBevelFilter):void
        {
            var colors:Array = filter.gradientColors;
            var ratios:Array = filter.gradientRatio;
            
            var numColors:uint = colors.length;
            
            output.writeU8(numColors);
            
            for (var i:uint = 0; i < numColors; ++i) {
                writeRGBA(output, context, colors[i]);
            }
            for (var j:uint = 0; j < numColors; ++j) {
                output.writeU8(ratios[j]);
            }
            
            output.writeFixed(filter.blurX);
            output.writeFixed(filter.blurY);
            output.writeFixed(filter.angle);
            output.writeFixed(filter.distance);
            output.writeFixed8(filter.strength);
            
            output.resetBitCursor();
            
            output.writeBit(filter.innerShadow);
            output.writeBit(filter.knockout);
            output.writeBit(true);
            output.writeBit(filter.onTop);
            output.writeUBits(4, filter.passes);
        }
        
        public function writeClipEventFlags(output:DataOutput, context:WritingContext, flags:ClipEventFlags):void
        {
            var a:uint = 0;
            
            a |= flags.eventKeyUp ? 0x00000080 : 0;
            a |= flags.eventKeyDown ? 0x00000040 : 0;
            a |= flags.eventMouseUp ? 0x00000020 : 0;
            a |= flags.eventMouseDown ? 0x00000010 : 0;
            a |= flags.eventMouseMove ? 0x00000008 : 0;
            a |= flags.eventUnload ? 0x00000004 : 0;
            a |= flags.eventEnterFrame ? 0x00000002 : 0;
            a |= flags.eventLoad ? 0x00000001 : 0;
            
            if (context.version >= 6) {
                a |= flags.eventDragOver ? 0x00008000 : 0;
                a |= flags.eventRollOut ? 0x00004000 : 0;
                a |= flags.eventRollOver ? 0x00000200 : 0;
                a |= flags.eventReleaseOutSide ? 0x00001000 : 0;
                a |= flags.eventRelease ? 0x00000800 : 0;
                a |= flags.eventInitialize ? 0x00000200 : 0;
                a |= flags.eventData ? 0x00000100 : 0;
                if (context.version >= 7) {
                    a |= flags.eventConstruct ? 0x00040000 : 0;
                }
                a |= flags.eventKeyPress ? 0x00020000 : 0;
                a |= flags.eventDragOut ? 0x00010000 : 0;
                
                output.writeU32(a);
            }
            else {
                output.writeU16(a);
            }
        }
        
        public function writeRemoveObject(output:DataOutput, context:WritingContext, tag:RemoveObject):void
        {
            if (context.version < 1) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            _tagData.writeU16(tag.depth);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeRemoveObject2(output:DataOutput, context:WritingContext, tag:RemoveObject2):void
        {
            if (context.version < 3) {
                return;
            }
            
            _tagData.writeU16(tag.depth);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeShowFrame(output:DataOutput, context:WritingContext, tag:ShowFrame):void
        {
            if (context.version < 1) {
                return;
            }
            
            writeTagHeader(output, tag);
        }
        
        public function writeSetBackgroundColor(output:DataOutput, context:WritingContext, tag:SetBackgroundColor):void
        {
            if (context.version < 1) {
                return;
            }
            
            writeRGB(_tagData, context, tag.backgroundColor);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeFrameLabel(output:DataOutput, context:WritingContext, tag:FrameLabel):void
        {
            if (context.version < 3) {
                return;
            }
            
            writeString(_tagData, context, tag.name);
            
            if (tag.isNamedAnchor) {
                _tagData.writeU8(0x01);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeProtect(output:DataOutput, context:WritingContext, tag:Protect):void
        {
            if (context.version < 2) {
                return;
            }
            
            writeTagHeader(output, tag);
        }
        
        public function writeEnd(output:DataOutput, context:WritingContext, tag:End):void
        {
            if (context.version < 1) {
                return;
            }
            
            writeTagHeader(output, tag);
        }
        
        public function writeExportAssets(output:DataOutput, context:WritingContext, tag:ExportAssets):void
        {
            if (context.version < 5) {
                return;
            }
            
            _tagData.writeU16(tag.numAssets);
            
            for each (var asset:Asset in tag.assets) {
                writeAsset(_tagData, context, asset);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeAsset(output:DataOutput, context:WritingContext, asset:Asset):void
        {
            output.writeU16(asset.characterId);
            writeString(output, context, asset.name);
        }
        
        public function writeImportAssets(output:DataOutput, context:WritingContext, tag:ImportAssets):void
        {
            if (context.version < 5 || context.version > 7) {
                return;
            }
            
            writeString(_tagData, context, tag.url);
            
            _tagData.writeU16(tag.numAssets);
            
            for each (var asset:Asset in tag.assets) {
                writeAsset(_tagData, context, asset);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeEnableDebugger(output:DataOutput, context:WritingContext, tag:EnableDebugger):void
        {
            if (context.version < 5) {
                return;
            }
            
            writeString(_tagData, context, tag.password);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeEnableDebugger2(output:DataOutput, context:WritingContext, tag:EnableDebugger2):void
        {
            if (context.version < 6) {
                return;
            }
            
            _tagData.writeU16(0x00);
            
            writeString(_tagData, context, tag.password);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeScriptLimits(output:DataOutput, context:WritingContext, tag:ScriptLimits):void
        {
            if (context.version < 7) {
                return;
            }
            
            _tagData.writeU16(tag.maxRecursionDepth);
            _tagData.writeU16(tag.scriptTimeoutSeconds);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeSetTabIndex(output:DataOutput, context:WritingContext, tag:SetTabIndex):void
        {
            if (context.version < 7) {
                return;
            }
            
            _tagData.writeU16(tag.depth);
            _tagData.writeU16(tag.tabIndex);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeFileAttributes(output:DataOutput, context:WritingContext, tag:FileAttributes):void
        {
            if (context.version < 1) {
                return;
            }
            
            _tagData.resetBitCursor();
            _tagData.writeUBits(3, 0x00);
            _tagData.writeBit(tag.hasMetadata);
            _tagData.writeBit(tag.isActionScript3);
            _tagData.writeUBits(2, 0x00);
            _tagData.writeBit(tag.useNetwork);
            _tagData.writeUBits(24, 0x00);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeImportAssets2(output:DataOutput, context:WritingContext, tag:ImportAssets2):void
        {
            if (context.version < 8) {
                return;
            }
            
            writeString(_tagData, context, tag.url);
            
            _tagData.writeU8(0x00);
            _tagData.writeU8(0x00);
            
            _tagData.writeU16(tag.numAssets);
            
            for each (var asset:Asset in tag.assets) {
                writeAsset(_tagData, context, asset);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeSymbolClass(output:DataOutput, context:WritingContext, tag:SymbolClass):void
        {
            if (context.version < 9) {
                return;
            }
            
            _tagData.writeU16(tag.numSymbols);
            
            for each (var symbol:Asset in tag.symbols) {
                writeAsset(_tagData, context, symbol);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeMetadata(output:DataOutput, context:WritingContext, tag:Metadata):void
        {
            if (context.version < 1) {
                return;
            }
            
            writeString(_tagData, context, tag.metadata);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineScalingGrid(output:DataOutput, context:WritingContext, tag:DefineScalingGrid):void
        {
            if (context.version < 8) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            writeRect(_tagData, context, tag.splitter);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineSceneAndFrameLabelData(output:DataOutput, context:WritingContext, tag:DefineSceneAndFrameLabelData):void
        {
            if (context.version < 9) {
                return;
            }
            
            _tagData.writeEncodedU32(tag.numScenes);
            
            for each (var data:SceneData in tag.scenes) {
                _tagData.writeEncodedU32(data.frameOffset);
                writeString(_tagData, context, data.name);
            }
            
            _tagData.writeEncodedU32(tag.numFrameLabels);
            
            for each (var label:FrameLabelData in tag.frameLabels) {
                _tagData.writeEncodedU32(label.frameNumber);
                writeString(_tagData, context, label.frameLabel);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDoAction(output:DataOutput, context:WritingContext, tag:DoAction):void
        {
            if (context.version < 3) {
                return;
            }
            
            writeActionRecords(_tagData, context, tag.actionRecords);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeActionRecords(output:DataOutput, context:WritingContext, actions:ActionRecords):void
        {
            // Ignore actions in this version.
            
            output.writeU8(0x00);
        }
        
        public function writeDoInitAction(output:DataOutput, context:WritingContext, tag:DoInitAction):void
        {
            if (context.version < 6) {
                return;
            }
            
            _tagData.writeU16(tag.spriteId);
            
            writeActionRecords(_tagData, context, tag.actionRecords);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDoABC(output:DataOutput, context:WritingContext, tag:DoABC):void
        {
            if (context.version < 9) {
                return;
            }
            
            //_tagData.writeU32(tag.isLazyInitialize ? 0x01 : 0x00);
            
            if (tag.abcData) {
                _tagData.writeBytes(tag.abcData);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeFillStyleArray(output:DataOutput, context:WritingContext, fillStyleArray:FillStyleArray):void
        {
            if (fillStyleArray.numFillStyles >= 0xff) {
                output.writeU8(0xff);
                output.writeU16(fillStyleArray.numFillStyles);
            }
            else {
                output.writeU8(fillStyleArray.numFillStyles);
            }
            
            for each (var style:FillStyle in fillStyleArray.fillStyles) {
                writeFillStyle(output, context, style);
            }
        }
        
        public function writeFillStyle(output:DataOutput, context:WritingContext, style:FillStyle):void
        {
            output.writeU8(style.fillStyleType);
            
            if (style.fillStyleType == FillStyleTypeConstants.SOLID_FILL) {
                if (context.tagType == 3 || context.tagType == 4) {
                    writeRGBA(output, context, style.color);
                }
                else {
                    writeRGB(output, context, style.color);
                }
            }
            if (style.fillStyleType == FillStyleTypeConstants.LINEAR_GRADIENT_FILL ||
                style.fillStyleType == FillStyleTypeConstants.RADIAL_GRADIENT_FILL) {
                writeMatrix(output, context, style.matrix);
                writeGradient(output, context, style.gradient);
            }
            if (context.version >= 8 && style.fillStyleType == FillStyleTypeConstants.FOCAL_RADIAL_GRADIENT_FILL) {
                writeFocalGradient(output, context, style.gradient);
            }
            if (style.fillStyleType == FillStyleTypeConstants.REPEATING_BITMAP_FILL ||
                style.fillStyleType == FillStyleTypeConstants.CLIPPED_BITMAP_FILL ||
                style.fillStyleType == FillStyleTypeConstants.NON_SMOOTHED_REPEATING_BITMAP ||
                style.fillStyleType == FillStyleTypeConstants.NON_SMOOTHED_CLIPPED_BITMAP) {
                output.writeU16(style.bitmapId);
                writeMatrix(output, context, style.bitmapMatrix);
            }
        }
        
        public function writeLineStyleArray(output:DataOutput, context:WritingContext, lineStyleArray:LineStyleArray):void
        {
            if (lineStyleArray.numLineStyles >= 0xff) {
                output.writeU8(0xff);
                output.writeU16(lineStyleArray.numLineStyles);
            }
            else {
                output.writeU8(lineStyleArray.numLineStyles);
            }
            
            if (context.tagType == 4) {
                for each (var style2:LineStyle2 in lineStyleArray.lineStyles) {
                    writeLineStyle2(output, context, style2);
                }
            }
            else {
                for each (var style:LineStyle in lineStyleArray.lineStyles) {
                    writeLineStyle(output, context, style);
                }
            }
        }
        
        public function writeLineStyle(output:DataOutput, context:WritingContext, style:LineStyle):void
        {
            output.writeU16(style.widthTwips);
            
            if (context.tagType == 3) {
                writeRGBA(output, context, style.color);
            }
            else {
                writeRGB(output, context, style.color);
            }
        }
        
        public function writeLineStyle2(output:DataOutput, context:WritingContext, style:LineStyle2):void
        {
            output.writeU16(style.widthTwips);
            output.resetBitCursor();
            output.writeUBits(2, style.startCapStyle);
            output.writeUBits(2, style.joinStyle);
            output.writeBit(style.hasFill);
            output.writeBit(style.noHorizontalScale);
            output.writeBit(style.noVerticalScale);
            output.writeBit(style.pixelHinting);
            output.writeUBits(5, 0x00);
            output.writeBit(style.noClose);
            output.writeUBits(2, style.endCapStyle);
            
            if (style.joinStyle == JoinStyleConstants.MITER_JOIN) {
                output.writeFixed8(style.miterLimitFactor);
            }
            if (!style.hasFill) {
                writeRGBA(output, context, style.color);
            }
            if (style.hasFill) {
                writeFillStyle(output, context, style.fillType);
            }
        }
        
        public function writeShape(output:DataOutput, context:WritingContext, shape:Shape):void
        {
            output.resetBitCursor();
            
            var fillBits:uint = BitwiseUtil.getMinBits(context.numFillStyles);
            var lineBits:uint = BitwiseUtil.getMinBits(context.numLineStyles);
            
            output.writeUBits(4, fillBits);
            output.writeUBits(4, lineBits);
            
            for each (var record:ShapeRecord in shape.shapeRecords) {
                if (record is StraightEdgeRecord) {
                    var straight:StraightEdgeRecord = StraightEdgeRecord(record);
                    var stNumBits:uint = Math.max(2, BitwiseUtil.getMinSBits(straight.generalLine || straight.horizontalLine ? straight.deltaXTwips : 0, straight.generalLine || straight.verticalLine ? straight.deltaYTwips : 0));
                    output.writeBit(true);
                    output.writeBit(true);
                    output.writeUBits(4, stNumBits - 2);
                    output.writeBit(straight.generalLine);
                    if (!straight.generalLine) {
                        output.writeBit(straight.verticalLine);
                    }
                    if (straight.generalLine || !straight.verticalLine) {
                        output.writeSBits(stNumBits, straight.deltaXTwips);
                    }
                    if (straight.generalLine || straight.verticalLine) {
                        output.writeSBits(stNumBits, straight.deltaYTwips);
                    }
                    continue;
                }
                if (record is CurvedEdgeRecord) {
                    var curved:CurvedEdgeRecord = CurvedEdgeRecord(record);
                    var cvNumBits:uint = Math.max(2, BitwiseUtil.getMinSBits(curved.controlDeltaXTwips, curved.controlDeltaYTwips, curved.anchorDeltaXTwips, curved.anchorDeltaYTwips));
                    output.writeBit(true);
                    output.writeBit(false);
                    output.writeUBits(4, cvNumBits - 2);
                    output.writeSBits(cvNumBits, curved.controlDeltaXTwips);
                    output.writeSBits(cvNumBits, curved.controlDeltaYTwips);
                    output.writeSBits(cvNumBits, curved.anchorDeltaXTwips);
                    output.writeSBits(cvNumBits, curved.anchorDeltaYTwips);
                    continue;
                }
                if (record is StyleChangeRecord) {
                    var style:StyleChangeRecord = StyleChangeRecord(record);
                    output.writeBit(false);
                    output.writeBit(context.tagType == 2 || context.tagType == 3 || context.tagType == 4 ? style.stateNewStyles : false);
                    output.writeBit(style.stateLineStyle);
                    output.writeBit(style.stateFillStyle1);
                    output.writeBit(style.stateFillStyle0);
                    output.writeBit(style.stateMoveTo);
                    if (style.stateMoveTo) {
                        var moveBits:uint = BitwiseUtil.getMinSBits(style.moveDeltaXTwips, style.moveDeltaYTwips);
                        output.writeUBits(5, moveBits);
                        output.writeSBits(moveBits, style.moveDeltaXTwips);
                        output.writeSBits(moveBits, style.moveDeltaYTwips);
                    }
                    if (style.stateFillStyle0) {
                        output.writeUBits(fillBits, style.fillStyle0);
                    }
                    if (style.stateFillStyle1) {
                        output.writeUBits(fillBits, style.fillStyle1);
                    }
                    if (style.stateLineStyle) {
                        output.writeUBits(lineBits, style.lineStyle);
                    }
                    if (style.stateNewStyles) {
                        writeFillStyleArray(output, context, style.fillStyles);
                        writeLineStyleArray(output, context, style.lineStyles);
                        fillBits = BitwiseUtil.getMinBits(context.numFillStyles = style.fillStyles.numFillStyles);
                        lineBits = BitwiseUtil.getMinBits(context.numLineStyles = style.lineStyles.numLineStyles);
                        output.resetBitCursor();
                        output.writeUBits(4, fillBits);
                        output.writeUBits(4, lineBits);
                    }
                }
            }
            output.writeBit(false);
            output.writeUBits(5, 0x00);
        }
        
        public function writeShapeWithStyle(output:DataOutput, context:WritingContext, shape:ShapeWithStyle):void
        {
            writeFillStyleArray(output, context, shape.fillStyles);
            writeLineStyleArray(output, context, shape.lineStyles);
            
            context.numFillStyles = shape.fillStyles.numFillStyles;
            context.numLineStyles = shape.lineStyles.numLineStyles;
            
            writeShape(output, context, shape);
            
            context.numFillStyles = 0;
            context.numLineStyles = 0;
        }
        
        public function writeDefineShape(output:DataOutput, context:WritingContext, tag:DefineShape):void
        {
            if (context.version < 1) {
                return;
            }
            
            context.tagType = 1;
            
            _tagData.writeU16(tag.shapeId);
            writeRect(_tagData, context, tag.shapeBounds);
            writeShapeWithStyle(_tagData, context, tag.shapes);
            
            context.tagType = 0;
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineShape2(output:DataOutput, context:WritingContext, tag:DefineShape2):void
        {
            if (context.version < 2) {
                return;
            }
            
            context.tagType = 2;
            
            _tagData.writeU16(tag.shapeId);
            writeRect(_tagData, context, tag.shapeBounds);
            writeShapeWithStyle(_tagData, context, tag.shapes);
            
            context.tagType = 0;
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineShape3(output:DataOutput, context:WritingContext, tag:DefineShape3):void
        {
            if (context.version < 3) {
                return;
            }
            
            context.tagType = 3;
            
            _tagData.writeU16(tag.shapeId);
            writeRect(_tagData, context, tag.shapeBounds);
            writeShapeWithStyle(_tagData, context, tag.shapes);
            
            context.tagType = 0;
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineShape4(output:DataOutput, context:WritingContext, tag:DefineShape4):void
        {
            if (context.version < 8) {
                return;
            }
            
            context.tagType = 4;
            
            _tagData.writeU16(tag.shapeId);
            writeRect(_tagData, context, tag.shapeBounds);
            writeRect(_tagData, context, tag.edgeBounds);
            
            _tagData.resetBitCursor();
            
            _tagData.writeUBits(6, 0x00);
            
            _tagData.writeBit(tag.useNonScalingStrokes);
            _tagData.writeBit(tag.useScalingStrokes);
            
            writeShapeWithStyle(_tagData, context, tag.shapes);
            
            context.tagType = 0;
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeGradient(output:DataOutput, context:WritingContext, gradient:Gradient):void
        {
            output.resetBitCursor();
            
            output.writeUBits(2, gradient.spreadMode);
            output.writeUBits(2, gradient.interpolationMode);
            
            output.writeUBits(4, gradient.numGradientRecords);
            
            for each (var record:GradientRecord in gradient.gradientRecords) {
                writeGradientRecord(output, context, record);
            }
        }
        
        public function writeFocalGradient(output:DataOutput, context:WritingContext, gradient:FocalGradient):void
        {
            writeGradient(output, context, gradient);
            
            output.writeFixed8(gradient.focalPoint);
        }
        
        public function writeGradientRecord(output:DataOutput, context:WritingContext, record:GradientRecord):void
        {
            output.writeU8(record.ratio);
            
            if (context.tagType == 3 || context.tagType == 4) {
                writeRGBA(output, context, record.color);
            }
            else {
                writeRGB(output, context, record.color);
            }
        }
        
        public function writeDefineBits(output:DataOutput, context:WritingContext, tag:DefineBits):void
        {
            if (context.version < 1) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            
            if (tag.jpegData) {
                _tagData.writeBytes(tag.jpegData);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeJPEGTables(output:DataOutput, context:WritingContext, tag:JPEGTables):void
        {
            if (context.version < 1) {
                return;
            }
            
            if (tag.jpegData) {
                _tagData.writeBytes(tag.jpegData);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineBitsJPEG2(output:DataOutput, context:WritingContext, tag:DefineBitsJPEG2):void
        {
            if (context.version < 2) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            
            if (tag.jpegData) {
                _tagData.writeBytes(tag.jpegData);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineBitsJPEG3(output:DataOutput, context:WritingContext, tag:DefineBitsJPEG3):void
        {
            if (context.version < 3) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            _tagData.writeU32(tag.jpegData ? tag.jpegData.length : 0);
            
            if (tag.jpegData) {
                _tagData.writeBytes(tag.jpegData);
            }
            if (tag.bitmapAlphaData) {
                _tagData.writeBytes(tag.bitmapAlphaData);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineBitsLossless(output:DataOutput, context:WritingContext, tag:DefineBitsLossless):void
        {
            if (context.version < 2) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            _tagData.writeU8(tag.bitmapFormat);
            _tagData.writeU16(tag.bitmapWidth);
            _tagData.writeU16(tag.bitmapHeight);
            
            var bytes:ByteArray = new ByteArray();
            
            if (tag.bitmapFormat == BitmapFormatConstants.COLORMAPPED8) {
                _tagData.writeU8(tag.colorTable.length);
                var bytesOutput:DataOutput = new ByteArrayOutputStream(bytes);
                for each (var rgb:RGB in tag.colorTable) {
                    writeRGB(bytesOutput, context, rgb);
                }
            }
            
            if (tag.data) {
                bytes.writeBytes(tag.data);
            }
            
            bytes.compress();
            
            _tagData.writeBytes(bytes);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineBitsLossless2(output:DataOutput, context:WritingContext, tag:DefineBitsLossless2):void
        {
            if (context.version < 2) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            _tagData.writeU8(tag.bitmapFormat);
            _tagData.writeU16(tag.bitmapWidth);
            _tagData.writeU16(tag.bitmapHeight);
            
            var bytes:ByteArray = new ByteArray();
            
            if (tag.bitmapFormat == BitmapFormatConstants.COLORMAPPED8) {
                _tagData.writeU8(tag.colorTable.length);
                var bytesOutput:DataOutput = ByteArrayOutputStream(bytes);
                for each (var rgb:RGBA in tag.colorTable) {
                    writeRGBA(bytesOutput, context, rgb);
                }
            }
            
            if (tag.data) {
                bytes.writeBytes(tag.data);
            }
            
            bytes.compress();
            
            _tagData.writeBytes(bytes);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineMorphShape(output:DataOutput, context:WritingContext, tag:DefineMorphShape):void
        {
            if (context.version < 3) {
                return;
            }
            
            context.tagType = 1;
            
            _tagData.writeU16(tag.characterId);
            
            writeRect(_tagData, context, tag.startBounds);
            writeRect(_tagData, context, tag.endBounds);
            
            var begin:uint = _tagData.position;
            
            _tagData.writeU32(0x00);
            
            writeMorphFillStyleArray(_tagData, context, tag.morphFillStyles);
            writeMorphLineStyles(_tagData, context, tag.morphLineStyles);
            
            writeShape(_tagData, context, tag.startEdges);
            
            var end:uint = _tagData.position;
            
            _tagData.position = begin;
            _tagData.writeU32(end - (begin + 4));
            _tagData.position = end;
            
            writeShape(_tagData, context, tag.endEdges);
            
            context.tagType = 0;
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineMorphShape2(output:DataOutput, context:WritingContext, tag:DefineMorphShape2):void
        {
            if (context.version < 8) {
                return;
            }
            
            context.tagType = 2;
            
            _tagData.writeU16(tag.characterId);
            
            writeRect(_tagData, context, tag.startBounds);
            writeRect(_tagData, context, tag.endBounds);
            writeRect(_tagData, context, tag.startEdgeBounds);
            writeRect(_tagData, context, tag.endEdgeBounds);
            
            _tagData.resetBitCursor();
            
            _tagData.writeUBits(6, 0x00);
            
            _tagData.writeBit(tag.useNonScalingStrokes);
            _tagData.writeBit(tag.useScalingStrokes);
            
            var begin:uint = _tagData.position;
            
            _tagData.writeU32(0x00);
            
            writeMorphFillStyleArray(_tagData, context, tag.morphFillStyles);
            writeMorphLineStyles(_tagData, context, tag.morphLineStyles);
            
            context.tagType = 3;
            
            writeShape(_tagData, context, tag.startEdges);
            
            var end:uint = _tagData.position;
            
            _tagData.position = begin;
            _tagData.writeU32(end - (begin + 4));
            _tagData.position = end;
            
            writeShape(_tagData, context, tag.endEdges);
            
            context.tagType = 0;
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeMorphFillStyleArray(output:DataOutput, context:WritingContext, styleArray:MorphFillStyleArray):void
        {
            if (styleArray.numFillStyles >= 0xff) {
                output.writeU8(0xff);
                output.writeU16(styleArray.numFillStyles);
            }
            else {
                output.writeU8(styleArray.numFillStyles);
            }
            
            for each (var style:MorphFillStyle in styleArray.fillStyles) {
                writeMorphFillStyle(output, context, style);
            }
        }
        
        public function writeMorphFillStyle(output:DataOutput, context:WritingContext, style:MorphFillStyle):void
        {
            output.writeU8(style.fillStyleType);
            
            if (style.fillStyleType == FillStyleTypeConstants.SOLID_FILL) {
                writeRGBA(output, context, style.startColor);
                writeRGBA(output, context, style.endColor);
            }
            if (style.fillStyleType == FillStyleTypeConstants.LINEAR_GRADIENT_FILL ||
                style.fillStyleType == FillStyleTypeConstants.RADIAL_GRADIENT_FILL) {
                writeMatrix(output, context, style.startGradientMatrix);
                writeMatrix(output, context, style.endGradientMatrix);
                writeMorphGradient(output, context, style.gradient);
            }
            if (style.fillStyleType == FillStyleTypeConstants.FOCAL_RADIAL_GRADIENT_FILL) {
                writeMatrix(output, context, style.startGradientMatrix);
                writeMatrix(output, context, style.endGradientMatrix);
                output.writeS16(0x00);
                output.writeS16(0x00);
            }
            if (style.fillStyleType == FillStyleTypeConstants.REPEATING_BITMAP_FILL ||
                style.fillStyleType == FillStyleTypeConstants.CLIPPED_BITMAP_FILL ||
                style.fillStyleType == FillStyleTypeConstants.NON_SMOOTHED_REPEATING_BITMAP ||
                style.fillStyleType == FillStyleTypeConstants.NON_SMOOTHED_CLIPPED_BITMAP) {
                output.writeU16(style.bitmapId);
                writeMatrix(output, context, style.startBitmapMatrix);
                writeMatrix(output, context, style.endBitmapMatrix);
            }
        }
        
        public function writeMorphGradient(output:DataOutput, context:WritingContext, gradient:MorphGradient):void
        {
            output.writeU8(gradient.numGradientRecords);
            
            for each (var record:MorphGradientRecord in gradient.gradientRecords) {
                writeMorphGradientRecord(output, context, record);
            }
        }
        
        public function writeMorphGradientRecord(output:DataOutput, context:WritingContext, record:MorphGradientRecord):void
        {
            output.writeU8(record.startRatio);
            writeRGBA(output, context, record.startColor);
            output.writeU8(record.endRatio);
            writeRGBA(output, context, record.endColor);
        }
        
        public function writeMorphLineStyles(output:DataOutput, context:WritingContext, lineStyles:MorphLineStyles):void
        {
            if (lineStyles.numLineStyles >= 0xff) {
                output.writeU8(0xff);
                output.writeU16(lineStyles.numLineStyles);
            }
            else {
                output.writeU8(lineStyles.numLineStyles);
            }
            
            if (context.tagType == 1) {
                for each (var lineStyle:MorphLineStyle in lineStyles.lineStyles) {
                    writeMorphLineStyle(output, context, lineStyle);
                }
            }
            else {
                for each (var lineStyle2:MorphLineStyle2 in lineStyles.lineStyles) {
                    writeMorphLineStyle2(output, context, lineStyle2);
                }
            }
        }
        
        public function writeMorphLineStyle(output:DataOutput, context:WritingContext, style:MorphLineStyle):void
        {
            output.writeU16(style.startWidth);
            output.writeU16(style.endWidth);
            writeRGBA(output, context, style.startColor);
            writeRGBA(output, context, style.endColor);
        }
        
        public function writeMorphLineStyle2(output:DataOutput, context:WritingContext, style:MorphLineStyle2):void
        {
            output.writeU16(style.startWidth);
            output.writeU16(style.endWidth);
            
            output.resetBitCursor();
            
            output.writeUBits(2, style.startCapStyle);
            output.writeUBits(2, style.joinStyle);
            output.writeBit(style.hasFill);
            output.writeBit(style.noHorizontalScale);
            output.writeBit(style.noVerticalScale);
            output.writeBit(style.pixelHinting);
            
            output.writeUBits(5, 0x00);
            
            output.writeBit(style.noClose);
            output.writeUBits(2, style.endCapStyle);
            
            if (style.joinStyle == JoinStyleConstants.MITER_JOIN) {
                output.writeFixed8(style.miterLimitFactor);
            }
            if (!style.hasFill) {
                writeRGBA(output, context, style.startColor);
                writeRGBA(output, context, style.endColor);
            }
            if (style.hasFill) {
                writeMorphFillStyle(output, context, style.fillType);
            }
        }
        
        public function writeDefineFont(output:DataOutput, context:WritingContext, tag:DefineFont):void
        {
            if (context.version < 1) {
                return;
            }
            
            _tagData.writeU16(tag.fontId);
            
            var numGlyphs:uint = tag.numGlyphShapes;
            
            _tagData.writeU16(numGlyphs * 2);
            
            var shapeTable:Array = tag.glyphShapeTable;
            var begin:uint = _tagData.position;
            
            for (var i:uint = 0; i < numGlyphs; ++i) {
                _tagData.writeU16(0x00);
            }
            for (var j:uint = 0; j < numGlyphs; ++j) {
                var pos:uint = _tagData.position;
                _tagData.position = begin + (j * 2);
                _tagData.writeU16(pos - begin);
                _tagData.position = pos;
                
                writeShape(_tagData, context, Shape(shapeTable[j]));
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineFontInfo(output:DataOutput, context:WritingContext, tag:DefineFontInfo):void
        {
            if (context.version < 1) {
                return;
            }
            
            _tagData.writeU16(tag.fontId);
            
            writeString(_tagData, context, tag.fontName, false);
            
            _tagData.resetBitCursor();
            _tagData.writeUBits(2, 0x00);
            
            _tagData.writeBit(context.version >= 7 ? tag.isSmallText : false);
            _tagData.writeBit(tag.isShiftJIS);
            _tagData.writeBit(tag.isANSI);
            _tagData.writeBit(tag.isItalic);
            _tagData.writeBit(tag.isBold);
            _tagData.writeBit(tag.areWideCodes);
            
            if (tag.areWideCodes) {
                for each (var wideCode:uint in tag.codeTable) {
                    _tagData.writeU16(wideCode);
                }
            }
            else {
                for each (var code:uint in tag.codeTable) {
                    _tagData.writeU8(code);
                }
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineFontInfo2(output:DataOutput, context:WritingContext, tag:DefineFontInfo2):void
        {
            if (context.version < 6) {
                return;
            }
            
            _tagData.writeU16(tag.fontId);
            
            writeString(_tagData, context, tag.fontName, false);
            
            _tagData.resetBitCursor();
            _tagData.writeUBits(2, 0x00);
            
            _tagData.writeBit(context.version >= 7 ? tag.isSmallText : false);
            _tagData.writeBit(tag.isShiftJIS);
            _tagData.writeBit(tag.isANSI);
            _tagData.writeBit(tag.isItalic);
            _tagData.writeBit(tag.isBold);
            _tagData.writeBit(tag.areWideCodes);
            
            writeLanguageCode(_tagData, context, tag.languageCode);
            
            for each (var code:uint in tag.codeTable) {
                _tagData.writeU16(code);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineFont2(output:DataOutput, context:WritingContext, tag:DefineFont2):void
        {
            if (context.version < 3) {
                return;
            }
            
            _tagData.writeU16(tag.fontId);
            
            _tagData.resetBitCursor();
            
            _tagData.writeBit(tag.hasLayout);
            _tagData.writeBit(tag.isShiftJIS);
            _tagData.writeBit(context.version >= 7 ? tag.isSmallText : false);
            _tagData.writeBit(tag.isANSI);
            _tagData.writeBit(true); // wideOffsets
            _tagData.writeBit(tag.areWideCodes);
            _tagData.writeBit(tag.isItalic);
            _tagData.writeBit(tag.isBold);
            
            context.areWideCodes = tag.areWideCodes;
            
            if (context.version < 6) {
                _tagData.writeU8(0x00);
            }
            else {
                writeLanguageCode(_tagData, context, tag.languageCode);
            }
            
            writeString(_tagData, context, tag.fontName, false);
            
            var numGlyphs:uint = tag.numGlyphs;
            
            _tagData.writeU16(numGlyphs);
            
            var begin:uint = _tagData.position;
            
            for (var i:uint = 0; i < numGlyphs; ++i) {
                _tagData.writeU32(0x00);
            }
            
            _tagData.writeU32(0x00);
            
            var shapeTable:Array = tag.glyphShapeTable;
            
            for (var j:uint = 0; j < numGlyphs; ++j) {
                var pos:uint = _tagData.position;
                _tagData.position = begin + (j * 4);
                _tagData.writeU32(pos - begin);
                _tagData.position = pos;
                
                writeShape(_tagData, context, Shape(shapeTable[j]));
            }
            
            var end:uint = _tagData.position;
            
            begin += numGlyphs * 4;
            
            _tagData.position = begin;
            _tagData.writeU32(end - (begin + 4));
            _tagData.position = end;
            
            if (tag.areWideCodes) {
                for each (var wideCode:uint in tag.codeTable) {
                    _tagData.writeU16(wideCode);
                }
            }
            else {
                for each (var code:uint in tag.codeTable) {
                    _tagData.writeU8(code);
                }
            }
            
            if (tag.hasLayout) {
                _tagData.writeU16(tag.fontAscent);
                _tagData.writeU16(tag.fontDescent);
                _tagData.writeU16(tag.fontLeading);
                
                for each (var advance:int in tag.fontAdvancedTable) {
                    _tagData.writeS16(advance);
                }
                for each (var bound:Rect in tag.fontBoundsTable) {
                    writeRect(_tagData, context, bound);
                }
                
                _tagData.writeU16(tag.kerningTable.length);
                
                for each (var record:KerningRecord in tag.kerningTable) {
                    writeKerningRecord(_tagData, context, record);
                }
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineFont3(output:DataOutput, context:WritingContext, tag:DefineFont3):void
        {
            if (context.version < 8) {
                return;
            }
            
            writeDefineFont2(output, context, tag);
        }
        
        public function writeDefineFontAlignZones(output:DataOutput, context:WritingContext, tag:DefineFontAlignZones):void
        {
            if (context.version < 8) {
                return;
            }
            
            _tagData.writeU16(tag.fontId);
            
            _tagData.resetBitCursor();
            
            _tagData.writeUBits(2, tag.csmTableHint);
            
            for each (var record:ZoneRecord in tag.zoneTable) {
                writeZoneRecord(_tagData, context, record);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeZoneRecord(output:DataOutput, context:WritingContext, record:ZoneRecord):void
        {
            output.writeU8(record.numZoneData);
            
            for each (var data:ZoneData in record.zoneData) {
                writeZoneData(output, context, data);
            }
            
            output.resetBitCursor();
            
            output.writeBit(record.zoneMaskX);
            output.writeBit(record.zoneMaskY);
            
            output.writeUBits(6, 0x00);
        }
        
        public function writeZoneData(output:DataOutput, context:WritingContext, data:ZoneData):void
        {
            output.writeFloat16(data.alignmentCoordinate);
            output.writeFloat16(data.range);
        }
        
        public function writeKerningRecord(output:DataOutput, context:WritingContext, record:KerningRecord):void
        {
            if (context.areWideCodes) {
                output.writeU16(record.fontKerningCode1);
                output.writeU16(record.fontKerningCode2);
            }
            else {
                output.writeU8(record.fontKerningCode1);
                output.writeU8(record.fontKerningCode2);
            }
            
            output.writeS16(record.fontKerningAdjustment);
        }
        
        public function writeDefineFontName(output:DataOutput, context:WritingContext, tag:DefineFontName):void
        {
            if (context.version < 9) {
                return;
            }
            
            _tagData.writeU16(tag.fontId);
            writeString(_tagData, context, tag.fontName);
            writeString(_tagData, context, tag.fontCopyright);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineText(output:DataOutput, context:WritingContext, tag:DefineText):void
        {
            if (context.version < 1) {
                return;
            }
            
            if (context.tagType == 0) {
                context.tagType = 1;
            }
            
            _tagData.writeU16(tag.characterId);
            writeRect(_tagData, context, tag.textBounds);
            writeMatrix(_tagData, context, tag.textMatrix);
            
            var glyphBits:uint = 1;
            var advanceBits:uint = 1;
            
            for each (var tRecord:TextRecord in tag.textRecords) {
                for each (var entry:GlyphEntry in tRecord.glyphEntries) {
                    glyphBits = Math.max(glyphBits, BitwiseUtil.getMinBits(entry.glyphIndex));
                    advanceBits = Math.max(advanceBits, BitwiseUtil.getMinSBits(entry.glyphAdvance));
                }
            }
            
            _tagData.writeU8(glyphBits);
            _tagData.writeU8(advanceBits);
            
            context.glyphBits = glyphBits;
            context.advanceBits = advanceBits;
            
            for each (var record:TextRecord in tag.textRecords) {
                writeTextRecord(_tagData, context, record);
            }
            
            _tagData.writeU8(0x00);
            
            context.tagType = 0;
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeTextRecord(output:DataOutput, context:WritingContext, record:TextRecord):void
        {
            output.resetBitCursor();
            output.writeBit(true);
            output.writeUBits(3, 0x00);
            output.writeBit(record.hasFont);
            output.writeBit(record.hasColor);
            output.writeBit(record.hasYOffset);
            output.writeBit(record.hasXOffset);
            
            if (record.hasFont) {
                output.writeU16(record.fontId);
            }
            if (record.hasColor) {
                if (context.tagType == 2) {
                    writeRGBA(output, context, record.textColor);
                }
                else {
                    writeRGB(output, context, record.textColor);
                }
            }
            if (record.hasXOffset) {
                output.writeS16(record.xOffset);
            }
            if (record.hasYOffset) {
                output.writeS16(record.yOffset);
            }
            if (record.hasFont) {
                output.writeU16(record.textHeight);
            }
            
            output.writeU8(record.glyphEntries.length);
            
            output.resetBitCursor();
            
            for each (var entry:GlyphEntry in record.glyphEntries) {
                writeGlyphEntry(output, context, entry);
            }
        }
        
        public function writeGlyphEntry(output:DataOutput, context:WritingContext, entry:GlyphEntry):void
        {
            output.writeUBits(context.glyphBits, entry.glyphIndex);
            output.writeUBits(context.advanceBits, entry.glyphAdvance);
        }
        
        public function writeDefineText2(output:DataOutput, context:WritingContext, tag:DefineText2):void
        {
            if (context.version < 3) {
                return;
            }
            
            context.tagType = 2;
            
            writeDefineText(output, context, tag);
        }
        
        public function writeDefineEditText(output:DataOutput, context:WritingContext, tag:DefineEditText):void
        {
            if (context.version < 4) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            writeRect(_tagData, context, tag.bounds);
            
            _tagData.resetBitCursor();
            
            _tagData.writeBit(tag.hasText);
            _tagData.writeBit(tag.wordWrap);
            _tagData.writeBit(tag.multiline);
            _tagData.writeBit(tag.password);
            _tagData.writeBit(tag.readOnly);
            _tagData.writeBit(tag.hasTextColor);
            _tagData.writeBit(tag.hasMaxLength);
            _tagData.writeBit(tag.hasFont);
            _tagData.writeBit(tag.hasFontClass);
            _tagData.writeBit(tag.autoSize);
            _tagData.writeBit(tag.hasLayout);
            _tagData.writeBit(tag.noSelect);
            _tagData.writeBit(tag.border);
            _tagData.writeBit(tag.wasStatic);
            _tagData.writeBit(tag.html);
            _tagData.writeBit(tag.useOutlines);
            
            if (tag.hasFont) {
                _tagData.writeU16(tag.fontId);
            }
            if (tag.hasFontClass) {
                writeString(_tagData, context, tag.fontClass);
            }
            if (tag.hasFont) {
                _tagData.writeU16(tag.fontHeight);
            }
            if (tag.hasTextColor) {
                writeRGBA(_tagData, context, tag.textColor);
            }
            if (tag.hasMaxLength) {
                _tagData.writeU16(tag.maxLength);
            }
            if (tag.hasLayout) {
                _tagData.writeU8(tag.align);
                _tagData.writeU16(tag.leftMargin);
                _tagData.writeU16(tag.rightMargin);
                _tagData.writeU16(tag.indent);
                _tagData.writeS16(tag.leading);
            }
            writeString(_tagData, context, tag.variableName);
            if (tag.hasText) {
                writeString(_tagData, context, tag.initialText);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeCSMTextSettings(output:DataOutput, context:WritingContext, tag:CSMTextSettings):void
        {
            if (context.version < 8) {
                return;
            }
            
            _tagData.writeU16(tag.textId);
            
            _tagData.resetBitCursor();
            
            _tagData.writeUBits(2, tag.useFlashType ? 1 : 0);
            _tagData.writeUBits(3, tag.gridFit);
            
            _tagData.writeUBits(3, 0x00);
            
            _tagData.writeFloat(tag.thickness);
            _tagData.writeFloat(tag.sharpness);
            
            _tagData.writeU8(0x00);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineSound(output:DataOutput, context:WritingContext, tag:DefineSound):void
        {
            if (context.version < 1) {
                return;
            }
            
            _tagData.writeU16(tag.soundId);
            
            _tagData.resetBitCursor();
            
            _tagData.writeUBits(4, tag.soundFormat);
            _tagData.writeUBits(2, tag.soundRate);
            _tagData.writeUBits(1, tag.soundSize);
            _tagData.writeUBits(1, tag.soundType);
            _tagData.writeU32(tag.numSoundSamples);
            
            if (tag.soundData) {
                writeSoundData(_tagData, tag.soundData);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeStartSound(output:DataOutput, context:WritingContext, tag:StartSound):void
        {
            if (context.version < 1) {
                return;
            }
            
            _tagData.writeU16(tag.soundId);
            writeSoundInfo(_tagData, context, tag.soundInfo);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeStartSound2(output:DataOutput, context:WritingContext, tag:StartSound2):void
        {
            if (context.version < 9) {
                return;
            }
            
            writeString(_tagData, context, tag.soundClassName);
            writeSoundInfo(_tagData, context, tag.soundInfo);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeSoundInfo(output:DataOutput, context:WritingContext, info:SoundInfo):void
        {
            output.resetBitCursor();
            
            output.writeUBits(2, 0x00);
            
            output.writeBit(info.syncStop);
            output.writeBit(info.syncNoMultiple);
            output.writeBit(info.hasEnvelope);
            output.writeBit(info.hasLoops);
            output.writeBit(info.hasOutPoint);
            output.writeBit(info.hasInPoint);
            
            if (info.hasInPoint) {
                output.writeU32(info.inPoint);
            }
            if (info.hasOutPoint) {
                output.writeU32(info.outPoint);
            }
            if (info.hasLoops) {
                output.writeU16(info.loopCount);
            }
            if (info.hasEnvelope) {
                output.writeU8(info.numEnvelopeRecords);
                for each (var env:SoundEnvelope in info.envelopeRecords) {
                    writeSoundEnvelope(output, context, env);
                }
            }
        }
        
        public function writeSoundEnvelope(output:DataOutput, context:WritingContext, env:SoundEnvelope):void
        {
            output.writeU32(env.pos44);
            output.writeU16(env.leftLevel);
            output.writeU16(env.rightLevel);
        }
        
        public function writeSoundStreamHead(output:DataOutput, context:WritingContext, tag:SoundStreamHead):void
        {
            if (context.version < 1) {
                return;
            }
            
            _tagData.resetBitCursor();
            
            _tagData.writeUBits(4, 0x00);
            
            _tagData.writeUBits(2, tag.playbackSoundRate);
            _tagData.writeUBits(1, tag.playbackSoundSize);
            _tagData.writeUBits(1, tag.playbackSoundType);
            _tagData.writeUBits(4, tag.streamSoundCompression);
            _tagData.writeUBits(2, tag.streamSoundRate);
            _tagData.writeUBits(1, tag.streamSoundSize);
            _tagData.writeUBits(1, tag.streamSoundType);
            _tagData.writeU16(tag.numStreamSoundSamples);
            
            if (tag.streamSoundCompression == SoundFormatConstants.MP3) {
                _tagData.writeS16(tag.latencySeek);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeSoundStreamHead2(output:DataOutput, context:WritingContext, tag:SoundStreamHead2):void
        {
            if (context.version < 3) {
                return;
            }
            
            writeSoundStreamHead(output, context, tag);
        }
        
        public function writeSoundStreamBlock(output:DataOutput, context:WritingContext, tag:SoundStreamBlock):void
        {
            if (context.version < 1) {
                return;
            }
            
            if (tag.streamSoundData) {
                writeSoundData(_tagData, tag.streamSoundData, true);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        private function writeSoundData(output:DataOutput, data:SoundData, isStream:Boolean = false):void
        {
            switch (data.format) {
                case SoundFormatConstants.UNCOMPRESSED:
                case SoundFormatConstants.UNCOMPRESSED_LITTLE_ENDIAN:
                    writeSoundDataUncompressed(output, SoundDataUncompressed(data));
                    break;
                case SoundFormatConstants.ADPCM:
                    writeSoundDataADPCM(output, SoundDataADPCM(data));
                    break;
                case SoundFormatConstants.MP3:
                    if (isStream) {
                        writeSoundDataMP3Stream(output, SoundDataMP3Stream(data));
                    }
                    else {
                        writeSoundDataMP3(output, SoundDataMP3(data));
                    }
                    break;
                case SoundFormatConstants.NELLYMOSER:
                    writeSoundDataNellymoser(output, SoundDataNellymoser(data));
                    break;
            }
        }
        
        private function writeSoundDataUncompressed(output:DataOutput, data:SoundDataUncompressed):void
        {
            output.writeBytes(data.soundData);
        }
        
        private function writeSoundDataADPCM(output:DataOutput, data:SoundDataADPCM):void
        {
            output.writeBytes(data.soundData);
        }
        
        private function writeSoundDataMP3(output:DataOutput, data:SoundDataMP3):void
        {
            output.writeU16(data.seekSamples);
            output.writeBytes(data.mp3Frames);
        }
        
        private function writeSoundDataMP3Stream(output:DataOutput, data:SoundDataMP3Stream):void
        {
            output.writeU16(data.numSamples);
            writeSoundDataMP3(output, data.mp3SoundData);
        }
        
        private function writeSoundDataNellymoser(output:DataOutput, data:SoundDataNellymoser):void
        {
            output.writeBytes(data.soundData);
        }
        
        public function writeButtonRecord(output:DataOutput, context:WritingContext, record:ButtonRecord):void
        {
            output.resetBitCursor();
            
            output.writeUBits(2, 0x00);
            
            output.writeBit(context.version >= 8 ? record.hasBlendMode : false);
            output.writeBit(context.version >= 8 ? record.hasFilterList : false);
            output.writeBit(record.stateHitTest);
            output.writeBit(record.stateDown);
            output.writeBit(record.stateOver);
            output.writeBit(record.stateUp);
            
            output.writeU16(record.characterId);
            output.writeU16(record.placeDepth);
            writeMatrix(output, context, record.placeMatrix);
            
            if (context.tagType == 2) {
                writeCXFormWithAlpha(output, context, record.colorTransform);
                if (record.hasFilterList) {
                    writeFilterList(output, context, record.filterList);
                }
                if (record.hasBlendMode) {
                    output.writeU8(record.blendMode);
                }
            }
        }
        
        public function writeDefineButton(output:DataOutput, context:WritingContext, tag:DefineButton):void
        {
            if (context.version < 1) {
                return;
            }
            
            context.tagType = 1;
            
            _tagData.writeU16(tag.buttonId);
            
            for each (var record:ButtonRecord in tag.characters) {
                writeButtonRecord(_tagData, context, record);
            }
            
            _tagData.writeU8(0x00);
            
            writeActionRecords(_tagData, context, tag.actions);
            
            context.tagType = 0;
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineButton2(output:DataOutput, context:WritingContext, tag:DefineButton2):void
        {
            if (context.version < 1) {
                return;
            }
            
            context.tagType = 2;
            
            _tagData.writeU16(tag.buttonId);
            
            _tagData.resetBitCursor();
            _tagData.writeUBits(7, 0x00);
            
            _tagData.writeBit(tag.trackAsMenu);
            
            var begin:uint = _tagData.position;
            
            _tagData.writeU16(0x00);
            
            for each (var record:ButtonRecord in tag.characters) {
                writeButtonRecord(_tagData, context, record);
            }
            
            _tagData.writeU8(0x00);
            
            var end:uint = _tagData.position;
            
            for each (var action:ButtonCondAction in tag.actions) {
                _tagData.position = begin;
                _tagData.writeU16(end - (begin + 2));
                _tagData.position = end;
                
                begin = _tagData.position;
                
                _tagData.writeU16(0x00);
                _tagData.resetBitCursor();
                _tagData.writeBit(action.condIdleToOverDown);
                _tagData.writeBit(action.condOutDownToIdle);
                _tagData.writeBit(action.condOutDownToOverDown);
                _tagData.writeBit(action.condOverDownToOutDown);
                _tagData.writeBit(action.condOverDownToOverUp);
                _tagData.writeBit(action.condOverUpToOverDown);
                _tagData.writeBit(action.condOverUpToIdle);
                _tagData.writeBit(action.condIdleToOverUp);
                _tagData.writeUBits(7, context.version >= 4 ? action.condKeyPress : 0);
                _tagData.writeBit(action.condOverDownToIdle);
                writeActionRecords(_tagData, context, action.actions);
                
                end = _tagData.position;
            }
            
            context.tagType = 0;
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineButtonCxform(output:DataOutput, context:WritingContext, tag:DefineButtonCxform):void
        {
            if (context.version < 2) {
                return;
            }
            
            _tagData.writeU16(tag.buttonId);
            writeCXForm(_tagData, context, tag.buttonColorTransform);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineButtonSound(output:DataOutput, context:WritingContext, tag:DefineButtonSound):void
        {
            if (context.version < 2) {
                return;
            }
            
            _tagData.writeU16(tag.buttonId);
            _tagData.writeU16(tag.buttonSoundChar0);
            if (tag.buttonSoundChar0 != 0) {
                writeSoundInfo(_tagData, context, tag.buttonSoundInfo0);
            }
            _tagData.writeU16(tag.buttonSoundChar1);
            if (tag.buttonSoundChar1 != 0) {
                writeSoundInfo(_tagData, context, tag.buttonSoundInfo1);
            }
            _tagData.writeU16(tag.buttonSoundChar2);
            if (tag.buttonSoundChar2 != 0) {
                writeSoundInfo(_tagData, context, tag.buttonSoundInfo2);
            }
            _tagData.writeU16(tag.buttonSoundChar3);
            if (tag.buttonSoundChar3 != 0) {
                writeSoundInfo(_tagData, context, tag.buttonSoundInfo3);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineSprite(output:DataOutput, context:WritingContext, tag:DefineSprite):void
        {
            if (context.version < 3) {
                return;
            }
            
            _tagData.writeU16(tag.spriteId);
            _tagData.writeU16(tag.numFrames);
            
            var tagData:ByteArrayOutputStream =  _tagData;
            
            _tagData = new ByteArrayOutputStream(new ByteArray());
            
            var offset:uint = context.offset;
            var length:uint = context.length;
            
            context.offset = 0;
            context.length = 0;
            
            writeTags(tagData, context, tag.tags);
            writeEnd(tagData, context, new End());
            
            context.offset = offset;
            context.length = length;
            
            _tagData = tagData;
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineVideoStream(output:DataOutput, context:WritingContext, tag:DefineVideoStream):void
        {
            if (context.version < 6) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            _tagData.writeU16(tag.numFrames);
            _tagData.writeU16(tag.width);
            _tagData.writeU16(tag.height);
            
            _tagData.resetBitCursor();
            _tagData.writeUBits(4, 0x00);
            
            _tagData.writeUBits(3, tag.deblockingFlags);
            _tagData.writeBit(tag.smoothing);
            _tagData.writeU8(tag.codecId);
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeVideoFrame(output:DataOutput, context:WritingContext, tag:VideoFrame):void
        {
            if (context.version < 6) {
                return;
            }
            
            _tagData.writeU16(tag.streamId);
            _tagData.writeU16(tag.frameNumber);
            
            if (tag.videoData) {
                _tagData.writeBytes(tag.videoData);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
        
        public function writeDefineBinaryData(output:DataOutput, context:WritingContext, tag:DefineBinaryData):void
        {
            if (context.version < 9) {
                return;
            }
            
            _tagData.writeU16(tag.characterId);
            _tagData.writeU32(0x00);
            
            if (tag.data) {
                _tagData.writeBytes(tag.data);
            }
            
            endTag(output, _tagData.byteArray, tag);
        }
    }
}