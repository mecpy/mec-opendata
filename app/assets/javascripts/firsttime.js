// First Time Visit Processing
// copyright 10th January 2006, Stephen Chapman
// permission to use this Javascript on your web page is granted
// provided that all of the below code in this script (including this
// comment) is used without any alteration
/*function rC(nam) {var tC = document.cookie.split('; '); for (var i = tC.length - 1; i >= 0; i--) {var x = tC[i].split('='); if (nam == x[0]) return unescape(x[1]);} return '~';} function wC(nam,val) {document.cookie = nam + '=' + escape(val);} function lC(nam,pg) {var val = rC(nam); if (val.indexOf('~'+pg+'~') != -1) return false; val += pg + '~'; wC(nam,val); return true;} function firstTime(cN) {return lC('pWrD4jBo',cN);} function thisPage() {var page = location.href.substring(location.href.lastIndexOf('\/')+1); pos = page.indexOf('.');if (pos > -1) {page = page.substr(0,pos);} return page;}
 
 // example code to call it - you may modify this as required
 function start() {
 if (firstTime(thisPage())) {
 // this code only runs for first visit
 alert('welcome');
 }
 // other code to run every time once page is loaded goes here
 }
 onload = start;*/
/*!
 * jQuery Cookie Plugin v1.4.1
 * https://github.com/carhartl/jquery-cookie
 *
 * Copyright 2006, 2014 Klaus Hartl
 * Released under the MIT license
 */
(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        // CommonJS
        factory(require('jquery'));
    } else {
        // Browser globals
        factory(jQuery);
    }
}(function ($) {

    var pluses = /\+/g;

    function encode(s) {
        return config.raw ? s : encodeURIComponent(s);
    }

    function decode(s) {
        return config.raw ? s : decodeURIComponent(s);
    }

    function stringifyCookieValue(value) {
        return encode(config.json ? JSON.stringify(value) : String(value));
    }

    function parseCookieValue(s) {
        if (s.indexOf('"') === 0) {
            // This is a quoted cookie as according to RFC2068, unescape...
            s = s.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, '\\');
        }

        try {
            // Replace server-side written pluses with spaces.
            // If we can't decode the cookie, ignore it, it's unusable.
            // If we can't parse the cookie, ignore it, it's unusable.
            s = decodeURIComponent(s.replace(pluses, ' '));
            return config.json ? JSON.parse(s) : s;
        } catch (e) {
        }
    }

    function read(s, converter) {
        var value = config.raw ? s : parseCookieValue(s);
        return $.isFunction(converter) ? converter(value) : value;
    }

    var config = $.cookie = function (key, value, options) {

        // Write

        if (arguments.length > 1 && !$.isFunction(value)) {
            options = $.extend({}, config.defaults, options);

            if (typeof options.expires === 'number') {
                var days = options.expires, t = options.expires = new Date();
                t.setTime(+t + days * 864e+5);
            }

            return (document.cookie = [
                encode(key), '=', stringifyCookieValue(value),
                options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                options.path ? '; path=' + options.path : '',
                options.domain ? '; domain=' + options.domain : '',
                options.secure ? '; secure' : ''
            ].join(''));
        }

        // Read

        var result = key ? undefined : {};

        // To prevent the for loop in the first place assign an empty array
        // in case there are no cookies at all. Also prevents odd result when
        // calling $.cookie().
        var cookies = document.cookie ? document.cookie.split('; ') : [];

        for (var i = 0, l = cookies.length; i < l; i++) {
            var parts = cookies[i].split('=');
            var name = decode(parts.shift());
            var cookie = parts.join('=');

            if (key && key === name) {
                // If second argument (value) is a function it's a converter...
                result = read(cookie, value);
                break;
            }

            // Prevent storing a cookie that we couldn't decode.
            if (!key && (cookie = read(cookie)) !== undefined) {
                result[name] = cookie;
            }
        }

        return result;
    };

    config.defaults = {};

    $.removeCookie = function (key, options) {
        if ($.cookie(key) === undefined) {
            return false;
        }

        // Must not alter options, thus extending a fresh object...
        $.cookie(key, '', $.extend({}, options, {expires: -1}));
        return !$.cookie(key);
    };

}));          