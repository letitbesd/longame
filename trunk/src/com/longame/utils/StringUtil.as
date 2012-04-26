//
// $Id: StringUtil.as 183 2010-01-08 21:07:37Z ray $
//
// Flash Utils library - general purpose ActionScript utility code
// Copyright (C) 2007-2010 Three Rings Design, Inc., All Rights Reserved
// http://www.threerings.net/code/ooolib/
//
// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

package com.longame.utils {

import flash.geom.Point;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.describeType;

/**
 * Contains useful static function for performing operations on Strings.
 */
public class StringUtil
{
    /**
     * Get a hashCode for the specified String. null returns 0.
     * This hashes identically to Java's String.hashCode(). This behavior has been useful
     * in various situations.
     */
    public static function hashCode (str :String) :int
    {
        var code :int = 0;
        if (str != null) {
            for (var ii :int = 0; ii < str.length; ii++) {
                code = 31 * code + str.charCodeAt(ii);
            }
        }
        return code;
    }

    /**
     * Is the specified string null, empty, or does it contain only whitespace?
     */
    public static function isBlank (str :String) :Boolean
    {
        return (str == null) || (str.search("\\S") == -1);
    }

    /**
     * Return the specified String, or "" if it is null.
     */
    public static function deNull (str :String) :String
    {
        return (str == null) ? "" : str;
    }

    /**
     * Does the specified string end with the specified substring.
     */
    public static function endsWith (str :String, substr :String) :Boolean
    {
        var startDex :int = str.length - substr.length;
        return (startDex >= 0) && (str.indexOf(substr, startDex) >= 0);
    }

    /**
     * Does the specified string start with the specified substring.
     */
    public static function startsWith (str :String, substr :String) :Boolean
    {
        // just check once if it's at the beginning
        return (str.lastIndexOf(substr, 0) == 0);
    }

    /**
     * Return true iff the first character is a lower-case character.
     */
    public static function isLowerCase (str :String) :Boolean
    {
        var firstChar :String = str.charAt(0);
        return (firstChar.toUpperCase() != firstChar) &&
            (firstChar.toLowerCase() == firstChar);
    }

    /**
     * Return true iff the first character is an upper-case character.
     */
    public static function isUpperCase (str :String) :Boolean
    {
        var firstChar :String = str.charAt(0);
        return (firstChar.toUpperCase() == firstChar) &&
            (firstChar.toLowerCase() != firstChar);
    }

    /**
     * Parse an integer more anally than the built-in parseInt() function,
     * throwing an ArgumentError if there are any invalid characters.
     *
     * The built-in parseInt() will ignore trailing non-integer characters.
     *
     * @param str The string to parse.
     * @param radix The radix to use, from 2 to 16. If not specified the radix will be 10,
     *        unless the String begins with "0x" in which case it will be 16,
     *        or the String begins with "0" in which case it will be 8.
     */
    public static function parseInteger (str :String, radix :uint = 0) :int
    {
        return int(parseInt0(str, radix, true));
    }
	/**
	 * 将以‘，’分开的字符串转成Point
	 * **/
//	public static function parsePoint(attr:String):Point
//	{
//		var p:Point=new Point();
//		var attrArr:Array=attr.split(",");
//		p.x=Number(attrArr[0]);
//		if(attrArr.length>1) p.y=Number(attrArr[1]);
//		return p;
//	}	
	/**
	 * 将以‘，’分开的字符串转成string数组
	 * **/
//	public static function parseArray(attr:String):Array
//	{
//		var p:Array=[];
//		var attrArr:Array=attr.split(",");
//		for(var i:int=0;i<attrArr.length;i++){
//			p[i]=attrArr[i];
//		}
//		return p;
//	}	
	/**
	 * 将以‘，’分开的字符串转成number数组
	 * **/
//	public static function parseNumberArray(attr:String):Array
//	{
//		var p:Array=[];
//		var attrArr:Array=attr.split(",");
//		for(var i:int=0;i<attrArr.length;i++){
//			p[i]=Number(attrArr[i]);
//		}
//		return p;
//	}
	
	public static function parseStyleNumberString(s:String):Number {
		
		var num:Number;
		
		// Figure.
		var str:String = StringUtil.trim(s);
		var colorByPound:Boolean = StringUtil.startsWith(str, "#");
		var colorByZeroX:Boolean = StringUtil.startsWith(str, "0x");
		var decimal:Boolean = StringUtil.startsWith(str, ".");
		var zeroDecimal:Boolean = StringUtil.startsWith(str, "0.");
		var pxEnd:Boolean = StringUtil.endsWith(str, 'px');
		
		// Color's with the # syntax.
		if(colorByPound) num = Number('0x' + StringUtil.trimLeftCharacter(str));
		
		// Color's with the 0x syntax.
		if(colorByZeroX) num = Number(str);
		
		// If the string ends with 'px'.
		if(pxEnd) num = Number(StringUtil.remove(str, 'px'));
		
		// If it begins with a decimal or zero and then a decimal.
		if(decimal || zeroDecimal) num = Number(str);
		
		return num;
		
	}
    /**
     * Parse an integer more anally than the built-in parseInt() function,
     * throwing an ArgumentError if there are any invalid characters.
     *
     * The built-in parseInt() will ignore trailing non-integer characters.
     *
     * @param str The string to parse.
     * @param radix The radix to use, from 2 to 16. If not specified the radix will be 10,
     *        unless the String begins with "0x" in which case it will be 16,
     *        or the String begins with "0" in which case it will be 8.
     */
    public static function parseUnsignedInteger (str :String, radix :uint = 0) :uint
    {
        var result :Number = parseInt0(str, radix, false);
        if (result < 0) {
			throw new Error("parseUnsignedInteger parsed negative value");
        }
        return uint(result);
    }

    /**
     * Format the specified uint as a String color value, for example "0x000000".
     *
     * @param c the uint value to format.
     * @param prefix the prefix to place in front of it. @default "0x", other possibilities are
     * "#" or "".
     */
    public static function toColorString (c :uint, prefix :String = "0x") :String
    {
        return prefix + prepad(c.toString(16), 6, "0");
    }

    /**
     * Format the specified number, nicely, with commas.
     * TODO: format specifyer, locale handling, etc. We'll probably move this into a
     * NumberFormat-style class.
     */
    public static function formatNumber (n :Number) :String
    {
        var postfix :String = "";
        var s :String = n.toString(); // use standard to-stringing

        // move any fractional portion to the postfix
        const dex :int = s.lastIndexOf(".");
        if (dex != -1) {
            postfix = s.substring(dex);
            s = s.substring(0, dex);
        }

        // hackily add commas
        var prefixLength :int = (n < 0) ? 1 : 0;
        while (s.length - prefixLength > 3) {
            postfix = "," + s.substring(s.length - 3) + postfix;
            s = s.substring(0, s.length - 3);
        }
        return s + postfix;
    }

    /**
     * Parse a Number from a String, throwing an ArgumentError if there are any
     * invalid characters.
     *
     * 1.5, 2e-3, -Infinity, Infinity, and NaN are all valid Strings.
     *
     * @param str the String to parse.
     */
    public static function parseNumber (str :String) :Number
    {
        if (str == null) {
            throw new ArgumentError("Cannot parseNumber(null)");
        }

        // deal with a few special cases
        if (str == "Infinity") {
            return Infinity;
        } else if (str == "-Infinity") {
            return -Infinity;
        } else if (str == "NaN") {
            return NaN;
        }

        const originalString :String = str;
        str = str.replace(",", "");
        const noCommas :String = str;

        // validate all characters before the "e"
        str = validateDecimal(str, true, true);

        // validate all characters after the "e"
        if (null != str && str.charAt(0) == "e") {
            str = str.substring(1);
            validateDecimal(str, false, false);
        }

        if (null == str) {
			throw new Error("Could not convert to Number");
        }

        // let Flash do the actual conversion
        return parseFloat(noCommas);
    }


    /**
     * Append 0 or more copies of the padChar String to the input String
     * until it is at least the specified length.
     */
    public static function pad (
        str :String, length :int, padChar :String = " ") :String
    {
        while (str.length < length) {
            str += padChar;
        }
        return str;
    }

    /**
     * Prepend 0 or more copies of the padChar String to the input String
     * until it is at least the specified length.
     */
    public static function prepad (
        str :String, length :int, padChar :String = " ") :String
    {
        while (str.length < length) {
            str = padChar + str;
        }
        return str;
    }

    /**
     * Substitute "{n}" tokens for the corresponding passed-in arguments.
     */
    public static function substitute (str :String, ... args) :String
    {
        // if someone passed an array as arg 1, fix it
        args = Util.unfuckVarargs(args);
        var len :int = args.length;
        // TODO: FIXME: this might be wrong, if your {0} replacement has a {1} in it, then
        // that'll get replaced next iteration.
        for (var ii : int = 0; ii < len; ii++) {
            str = str.replace(new RegExp("\\{" + ii + "\\}", "g"), args[ii]);
        }
        return str;
    }

    /**
     * Utility function that strips whitespace from the beginning and end of a String.
     */
    public static function trim (str :String) :String
    {
        return trimEnd(trimBeginning(str));
    }

    /**
     * Utility function that strips whitespace from the beginning of a String.
     */
    public static function trimBeginning (str :String) :String
    {
        if (str == null) {
            return null;
        }

        var startIdx :int = 0;
        // this works because charAt() with an invalid index returns "", which is not whitespace
        while (isWhitespace(str.charAt(startIdx))) {
            startIdx++;
        }

        // TODO: is this optimization necessary? It's possible that str.slice() does the same
        // check and just returns 'str' if it's the full length
        return (startIdx > 0) ? str.slice(startIdx, str.length) : str;
    }

    /**
     * Utility function that strips whitespace from the end of a String.
     */
    public static function trimEnd (str :String) :String
    {
        if (str == null) {
            return null;
        }

        var endIdx :int = str.length;
        // this works because charAt() with an invalid index returns "", which is not whitespace
        while (isWhitespace(str.charAt(endIdx - 1))) {
            endIdx--;
        }

        // TODO: is this optimization necessary? It's possible that str.slice() does the same
        // check and just returns 'str' if it's the full length
        return (endIdx < str.length) ? str.slice(0, endIdx) : str;
    }
	/**
	 * Removes the first and last characters in a string.
	 * 
	 * @example
	 * <listing>
	 * import org.as3commoncode.utils.StringUtil;
	 * var str:String = StringUtil.trimCharacters('abcde');
	 * // returns "bcd".
	 * </listing>
	 * 
	 * @param string	string to modify.
	 * @return String.
	 */
	public static function trimCharacters(string:String):String
	{
		return StringUtil.trimLeftCharacter(StringUtil.trimRightCharacter(string));
	}
	
	/**
	 * Removes the first character in the string.
	 * 
	 * @example
	 * <listing>
	 * import org.as3commoncode.utils.StringUtil;
	 * var str:String = StringUtil.trimLeftCharacter('abcde');
	 * // returns "a".
	 * </listing>
	 * 
	 * @param string	string to modify.
	 * @return String.
	 */
	public static function trimLeftCharacter(string:String):String
	{
		var size:Number = string.length;
		return string.substr(1, size);
	}
	
	/**
	 * Removes the last character in the string.
	 * 
	 * @example
	 * <listing>
	 * import org.as3commoncode.utils.StringUtil;
	 * var str:String = StringUtil.trimRightCharacter('abcde');
	 * // returns "e".
	 * </listing>
	 * 
	 * @param string	string to modify.
	 * @return String.
	 */
	public static function trimRightCharacter(string:String):String
	{
		var size:Number = string.length;
		return string.substr(0, size - 1);
	}
    /**
     * @return true if the specified String is == to a single whitespace character.
     */
    public static function isWhitespace (character :String) :Boolean
    {
        switch (character) {
        case " ":
        case "\t":
        case "\r":
        case "\n":
        case "\f":
            return true;

        default:
            return false;
        }
    }

    /**
     * Nicely format the specified object into a String.
     */
    public static function toString (obj :*, refs :Dictionary = null) :String
    {
        if (obj == null) { // checks null or undefined
            return String(obj);
        }

        var isDictionary :Boolean = obj is Dictionary;
        if (obj is Array || isDictionary || Util.isPlainObject(obj)) {
            if (refs == null) {
                refs = new Dictionary();

            } else if (refs[obj] !== undefined) {
                return "[cyclic reference]";
            }
            refs[obj] = true;

            var s :String;
            if (obj is Array) {
                var arr :Array = (obj as Array);
                s = "";
                for (var ii :int = 0; ii < arr.length; ii++) {
                    if (ii > 0) {
                        s += ", ";
                    }
                    s += (ii + ": " + toString(arr[ii], refs));
                }
                return "Array(" + s + ")";

            } else {
                // TODO: maybe do this for any dynamic object? (would have to use describeType)
                s = "";
                for (var prop :String in obj) {
                    if (s.length > 0) {
                        s += ", ";
                    }
                    s += prop + "=>" + toString(obj[prop], refs);
                }
                return (isDictionary ? "Dictionary" : "Object") + "(" + s + ")";
            }

        } else if (obj is XML) {
            return (obj as XML).toXMLString();
        }

        return String(obj);
    }

    /**
     * Truncate the specified String if it is longer than maxLength.
     * The string will be truncated at a position such that it is
     * maxLength chars long after the addition of the 'append' String.
     *
     * @param append a String to add to the truncated String only after
     * truncation.
     */
    public static function truncate (s :String, maxLength :int, append :String = "") :String
    {
        if ((s == null) || (s.length <= maxLength)) {
            return s;
        } else {
            return s.substring(0, maxLength - append.length) + append;
        }
    }

    /**
     * Returns a version of the supplied string with the first letter capitalized.
     */
    public static function capitalize (s :String) :String
    {
        if (isBlank(s)) {
            return s;
        }
        return s.substr(0, 1).toUpperCase() + s.substr(1);
    }

    /**
     * Locate URLs in a string, return an array in which even elements
     * are plain text, odd elements are urls (as Strings). Any even element
     * may be an empty string.
     */
    public static function parseURLs (s :String) :Array
    {
        var array :Array = [];
        while (true) {
            var result :Object = URL_REGEXP.exec(s);
            if (result == null) {
                break;
            }

            var index :int = int(result.index);
            var url :String = String(result[0]);
            array.push(s.substring(0, index));
            s = s.substring(index + url.length);
            // clean up the url if necessary
            if (startsWith(url.toLowerCase(), "www.")) {
                url = "http://" + url;
            }
            array.push(url);
        }

        if (s != "" || array.length == 0) { // avoid putting an empty string on the end
            array.push(s);
        }
        return array;
    }

    /**
     * Turn the specified byte array, containing only ascii characters, into a String.
     */
    public static function fromBytes (bytes :ByteArray) :String
    {
        var s :String = "";
        if (bytes != null) {
            for (var ii :int = 0; ii < bytes.length; ii++) {
                s += String.fromCharCode(bytes[ii]);
            }
        }
        return s;
    }

    /**
     * Turn the specified String, containing only ascii characters, into a ByteArray.
     */
    public static function toBytes (s :String) :ByteArray
    {
        if (s == null) {
            return null;
        }
        var ba :ByteArray = new ByteArray();
//        if (true) {
            for (var ii :int = 0; ii < s.length; ii++) {
                ba[ii] = int(s.charCodeAt(ii)) & 0xFF;
            }
//        } else {
//            ba.writeUTFBytes(s);
//        }
        return ba;
    }

    /**
     * Generates a string from the supplied bytes that is the hex encoded
     * representation of those byts. Returns the empty String for a
     * <code>null</code> or empty byte array.
     */
    public static function hexlate (bytes :ByteArray) :String
    {
        var str :String = "";
        if (bytes != null) {
            for (var ii :int = 0; ii < bytes.length; ii++) {
                var b :int = bytes[ii];
                str += HEX[b >> 4] + HEX[b & 0xF];
            }
        }
        return str;
    }

    /**
     * Turn a hexlated String back into a ByteArray.
     */
    public static function unhexlate (hex :String) :ByteArray
    {
        if (hex == null || (hex.length % 2 != 0)) {
            return null;
        }

        hex = hex.toLowerCase();
        var data :ByteArray = new ByteArray();
        for (var ii :int = 0; ii < hex.length; ii += 2) {
            var value :int = HEX.indexOf(hex.charAt(ii)) << 4;
            value += HEX.indexOf(hex.charAt(ii + 1));

            // TODO: verify
            // values over 127 are wrapped around, restoring negative bytes
            data[ii / 2] = value;
        }

        return data;
    }

    /**
     * Return a hexadecimal representation of an unsigned int, potentially left-padded with
     * zeroes to arrive at of precisely the requested width, e.g.
     *       toHex(131, 4) -> "0083"
     */
    public static function toHex (n :uint, width :uint) :String
    {
        return prepad(n.toString(16), width, "0");
    }

    /**
     * Create line-by-line hexadecimal output with a counter, much like the
     * 'hexdump' Unix utility. For debugging purposes.
     */
    public static function hexdump (bytes :ByteArray) :String
    {
        var str :String = "";
        for (var lineIx :int = 0; lineIx < bytes.length; lineIx += 16) {
            str += toHex(lineIx, 4);
            for (var byteIx :int = 0; byteIx < 16 && lineIx + byteIx < bytes.length; byteIx ++) {
                var b :uint = bytes[lineIx + byteIx];
                str += " " + HEX[b >> 4] + HEX[b & 0x0f];
            }
            str += "\n";
        }
        return str;

    }

	/**
	 * Unwraps a string that contains multi-line text, usually from a XML
	 * file. Any leading and trailing spaces or tabs are removed from
	 * each line, then the lines are unwrapped (LFs and CRs are removed).
	 * Then the method adds a space to every line that doesn't end with
	 * a <br/> tag.
	 * 
	 * @param string The string to unwrap.
	 * @return The unwrapped string.
	 * @private
	 */
	public static function unwrapText(string:String):String
	{
		if (string == null) return null;
		var lines:Array = string.split("\n");
		for (var i:int = 0; i < lines.length; i++)
		{
			lines[i] = lines[i].replace(/^\s+|\s+$/g, "");
			if (!(/<br\/>$/.test(lines[i]))) lines[i] += " ";
		}
		return lines.join("");
	}
	/**
	 * parseColorValue
	 * @private
	 */
	public static function parseColorValue(string:String):uint
	{
		if (string.substr(0, 1) == "#")
		{
			string = string.substr(1, string.length - 1);
		}
		var r:uint = uint("0x" + string);
		return r;
	}	
	/**
	 * Search & replace all characters specified in the parameters.
	 * 
	 * @example
	 * <listing>
	 * import org.as3commoncode.utils.StringUtil;
	 * var str:String = StringUtil.replace('I like to say Proximity!', 'like', 'love');
	 * // returns "I love to say Proximity!".
	 * </listing>
	 *
	 * @param string	string value to search.
	 * @param search	the character to search for.
	 * @param replace	the character to replace with.
	 * @return String.
	 */
	public static function replace(string:String, search:String, replace:String):String
	{		
		return string.split(search).join(replace);
	}
	/**
	 * Replaces a part of the text between 2 positions.
	 * 
	 * @example
	 * <listing>
	 * import org.as3commoncode.utils.StringUtil;
	 * var str:String = StringUtil.replaceAt('I like grapes.', 'love ', 3, 6);
	 * // returns "I love grapes.".
	 * </listing>
	 * 
	 * @param string		current string to look at.
	 * @param value			string to replace with.
	 * @param beginIndex	beginning index.
	 * @param endIndex		ending index.
	 * @return String.
	 */
	public static function replaceAt(string:String, value:*, beginIndex:int, endIndex:int):String 
	{
		beginIndex = Math.max(beginIndex, 0);
		endIndex = Math.min(endIndex, string.length);
		var firstPart:String = string.substr(0, beginIndex);
		var secondPart:String = string.substr(endIndex, string.length);
		return (firstPart + value + secondPart);
	}
	/**
	 * Removes all instances of the remove string in the input string.
	 * 
	 * @example
	 * <listing>
	 * import org.as3commoncode.utils.StringUtil;
	 * var str:String = StringUtil.remove('I like to say Proximity!', ' Proximity');
	 * // returns "I like to say!".
	 * </listing>
	 * 
	 * @param string	string that will be checked for instances of remove string.
	 * @param remove	string that will be removed from the input string.
	 * @return String.
	 */	
	public static function remove(string:String, remove:String):String
	{
		return StringUtil.replace(string, remove, "");
	}
	/**
	 * Removes a part of the text between 2 positions.
	 * 
	 * @example
	 * <listing>
	 * import org.as3commoncode.utils.StringUtil;
	 * var str:String = StringUtil.removeAt('I like grapes.', 'love ', 7, 13);
	 * // returns "I like.".
	 * </listing>
	 * 
	 * @param string		current string to look at.
	 * @param beginIndex	beginning index.
	 * @param endIndex		ending index.
	 * @return String.
	 */
	public static function removeAt(string:String, beginIndex:int, endIndex:int):String 
	{
		return StringUtil.replaceAt(string, "", beginIndex, endIndex);
	}
	/**
	 * Add/insert a new string at a certain position in the source string.
	 * 
	 * @example
	 * <listing>
	 * import org.as3commoncode.utils.StringUtil;
	 * var str:String = StringUtil.addAt('I like grapes.', 'red ', 7);
	 * // returns "I like red grapes.".
	 * </listing>
	 * 
	 * @param string	current string to look at.
	 * @param value		string to insert.
	 * @param position	string position.
	 * @return String.
	 */
	public static function addAt(string:String, value:*, position:int):String 
	{
		if (position > string.length) position = string.length;
		var firstPart:String = string.substring(0, position);
		var secondPart:String = string.substring(position, string.length);
		return (firstPart + value + secondPart);
	}
    /**
     * Internal helper function for parseNumber.
     */
    protected static function validateDecimal (
        str :String, allowDot :Boolean, allowTrailingE :Boolean) :String
    {
        // skip the leading minus
        if (str.charAt(0) == "-") {
            str = str.substring(1);
        }

        // validate that the characters in the string are all integers,
        // with at most one '.'
        var seenDot :Boolean;
        var seenDigit :Boolean;
        while (str.length > 0) {
            var char :String = str.charAt(0);
            if (char == ".") {
                if (!allowDot || seenDot) {
                    return null;
                }
                seenDot = true;
            } else if (char == "e") {
                if (!allowTrailingE) {
                    return null;
                }
                break;
            } else if (DECIMAL.indexOf(char) >= 0) {
                seenDigit = true;
            } else {
                return null;
            }

            str = str.substring(1);
        }

        // ensure we've seen at least one digit so far
        if (!seenDigit) {
            return null;
        }

        return str;
    }

    /**
     * Internal helper function for parseInteger and parseUnsignedInteger.
     */
    protected static function parseInt0 (str :String, radix :uint, allowNegative :Boolean) :Number
    {
        if (str == null) {
            throw new ArgumentError("Cannot parseInt(null)");
        }

        var negative :Boolean = (str.charAt(0) == "-");
        if (negative) {
            str = str.substring(1);
        }

        // handle this special case immediately, to prevent confusion about
        // a leading 0 meaning "parse as octal"
        if (str == "0") {
            return 0;
        }

        if (radix == 0) {
            if (startsWith(str, "0x")) {
                str = str.substring(2);
                radix = 16;

            } else if (startsWith(str, "0")) {
                str = str.substring(1);
                radix = 8;

            } else {
                radix = 10;
            }

        } else if (radix == 16 && startsWith(str, "0x")) {
            str = str.substring(2);

        } else if (radix < 2 || radix > 16) {
			throw new Error("Radix out of range");
        }

        // now verify that str only contains valid chars for the radix
        for (var ii :int = 0; ii < str.length; ii++) {
            var dex :int = HEX.indexOf(str.charAt(ii).toLowerCase());
            if (dex == -1 || dex >= radix) {
				throw new Error("Invalid characters in String");
            }
        }

        var result :Number = parseInt(str, radix);
        if (isNaN(result)) {
            // this shouldn't happen..
			throw new Error("Could not parseInt");
        }
        if (negative) {
            result *= -1;
        }
        return result;
    }

    /** Hexidecimal digits. */
    protected static const HEX :Array = [ "0", "1", "2", "3", "4",
        "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" ];

    /** Decimal digits. */
    protected static const DECIMAL :Array = HEX.slice(0, 10);

    /** A regular expression that finds URLs. */
    protected static const URL_REGEXP :RegExp = //new RegExp("(http|https|ftp)://\\S+", "i");
        // from John Gruber: http://daringfireball.net/2009/11/liberal_regex_for_matching_urls
        new RegExp("\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^!\\\"#$%&'()*+,\\-./:;<=>?@\\[\\\\\\]\\^_`{|}~\\s]|/)))", "i");
}
}
