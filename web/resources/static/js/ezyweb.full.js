/*!
 * Copyright 2022 youngmonkeys.org
 * 
 * Licensed under the ezyplatform, Version 1.0.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     https://youngmonkeys.org/licenses/ezyplatform-1.0.0.txt
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

// ============== messages ==================
ezyweb.getI18nMessage = function(key, toLowerCase) {
    var answer = ezyweb.messages[key] || key;
    if (toLowerCase) {
        answer = answer.toLowerCase()
    } else {
        answer = answer.substring(0, 1).toUpperCase() + answer.substring(1);
    }
    return answer;
}

// ============== datetime ==================
ezyweb.currentTimeMillis = function() {
    return new Date().getTime();
}

ezyweb.formatTimeStamp = function(timestamp, format) {
    if (!timestamp) {
        return '';
    }
    var actualFormat = format
        || ezyweb.defaultDateTimeFormat
        || 'YYYY-MM-DD HH:mm:ss';
    return moment(timestamp).format(actualFormat);
}

ezyweb.formatTimeStampDate = function(timestamp) {
    return ezyweb.formatTimeStamp(
        parseInt(timestamp, 10),
        ezyweb.defaultDateFormat || 'YYYY-MM-DD'
    )
}

ezyweb.formatTimeStampTime = function(timestamp) {
    return ezyweb.formatTimeStamp(
        parseInt(timestamp, 10),
        ezyweb.defaultTimeFormat || 'HH:mm:ss'
    )
}

ezyweb.formatTimeStampMinute = function(timestamp) {
    return ezyweb.formatTimeStamp(
        parseInt(timestamp, 10),
        ezyweb.defaultDateMinuteFormat || 'YYYY-MM-DD HH:mm'
    )
}

ezyweb.durationToString = function(duration, separator) {
    var remain = duration;
    var years = remain / (365 * 24 * 60 * 60) | 0;
    remain = remain % (365 * 24 * 60 * 60);
    var months = remain / (30 * 24 * 60 * 60) | 0;
    remain = remain % (30 * 24 * 60 * 60);
    var days = remain / (24 * 60 * 60) | 0;
    remain = remain % (24 * 60 * 60);
    var hours = remain / (60 * 60) | 0;
    remain = remain % (60 * 60);
    var minutes = remain / 60 | 0;
    var seconds = remain % 60;

    if (years || months || days || hours || minutes) {
        if (separator && seconds < 10) {
            seconds = '0' + seconds;
        }
    }
    var answer = seconds + (separator ? '' : 's');
    if (years || months || days || hours) {
        if (separator && minutes < 10) {
            minutes = '0' + minutes;
        }
    }
    if (years || months || days || hours || minutes) {
        answer = minutes + (separator || 'm:') + answer;
    }
    if (years || months || days) {
        if (separator && hours < 10) {
            hours = '0' + hours;
        }
    }
    if (years || months || days || hours) {
        answer = hours + (separator || 'h:') + answer;
    }
    if (years || months) {
        if (separator && days < 10) {
            days = '0' + days;
        }
    }
    if (years || months || days) {
        answer = days + (separator || 'd ') + answer;
    }
    if (years) {
        if (separator && months < 10) {
            months = '0' + months;
        }
    }
    if (years || months) {
        answer = months + (separator || 'm-') + answer;
    }
    if (years) {
        answer = years + (separator || 'y-') + answer;
    }
    return answer;
}

ezyweb.durationToSimpleString = function(duration) {
    var remain = duration;
    var years = remain / (365 * 24 * 60 * 60) | 0;
    remain = remain % (365 * 24 * 60 * 60);
    var months = remain / (30 * 24 * 60 * 60) | 0;
    remain = remain % (30 * 24 * 60 * 60);
    var weeks = remain / (7 * 24 * 60 * 60) | 0;
    remain = remain % (7 * 24 * 60 * 60);
    var days = remain / (24 * 60 * 60) | 0;
    remain = remain % (24 * 60 * 60);
    var hours = remain / (60 * 60) | 0;
    remain = remain % (60 * 60);
    var minutes = remain / 60 | 0;
    var seconds = remain % 60;

    var answer = '0s';
    if (years || months || weeks || days || hours || minutes || seconds) {
        answer = seconds + 's';
    }
    if (years || months || weeks || days || hours || minutes) {
        answer = minutes + 'm' + answer;
    }
    if (years || months || weeks || days || hours) {
        answer = hours + 'h' + answer;
    }
    if (years || months || weeks || days) {
        answer = days + 'd' + answer;
    }
    if (years || months || weeks) {
        answer = weeks + 'w' + answer;
    }
    if (years || months) {
        answer = months + 'M' + answer;
    }
    if (years) {
        answer = years + 'y' + answer;
    }
    return answer;
}

ezyweb.simpleDurationStringToMillis = function(str) {
    if (!str) {
        return 0;
    }
    var answer = 0;
    var millisBySymbol = {
        'ms': 1,
        's': 1000,
        'm': 60 * 1000,
        'h': 60 * 60 * 1000,
        'd': 24 * 60 * 60 * 1000,
        'w': 7 * 24 * 60 * 60 * 1000,
        'M': 30 * 24 * 60 * 60 * 1000,
        'y': 365 * 24 * 60 * 60 * 1000
    };
    var number = '';
    var lastSymbol = null;
    for (var i = 0; i < str.length; ++i) {
        if (str[i] >= '0' && str[i] <= '9') {
            number += str[i];
            lastSymbol = null;
        } else {
            lastSymbol = str[i];
            if ((i + 1) < str.length) {
                if(str[i + 1] < '0' || str[i + 1] > '9') {
                    lastSymbol += str[i + 1];
                    ++i;
                }
            }
            var millis = millisBySymbol[lastSymbol];
            if (millis && number) {
                answer += parseInt(number, 10) * millis;
                number = '';
            } else {
                answer = -1;
                break;
            }
        }
    }
    if (!lastSymbol) {
        answer = -1;
    }
    return answer;
}

ezyweb.getTimeRangeValue = function(milestoneTime) {
    return new Date().getTime() - milestoneTime;
}

ezyweb.getTimeRangeTextValue = function(milestoneTime, includeSuffix) {
    var timeRangeValue = ezyweb.getTimeRangeValue(milestoneTime);
    var ago = timeRangeValue > 0;
    var timeRange = Math.abs(timeRangeValue) / 1000;
    var remain = timeRange;
    var years = remain / (365 * 24 * 60 * 60) | 0;
    remain = remain % (365 * 24 * 60 * 60);
    var months = remain / (30 * 24 * 60 * 60) | 0;
    remain = remain % (30 * 24 * 60 * 60);
    var days = remain / (24 * 60 * 60) | 0;
    remain = remain % (24 * 60 * 60);
    var hours = remain / (60 * 60) | 0;
    remain = remain % (60 * 60);
    var minutes = remain / 60 | 0;
    var seconds = remain % 60 | 0;

    var answer = '1 ' + ezyweb.getI18nMessage('second', true);
    if (years) {
        if (years == 1) {
            answer = years + ' ' + ezyweb.getI18nMessage('year', true);
        } else {
            answer = years + ' ' + ezyweb.getI18nMessage('years', true);
        }
    } else if (months) {
        if (months == 1) {
            answer = months + ' ' + ezyweb.getI18nMessage('month', true);
        } else {
            answer = months + ' ' + ezyweb.getI18nMessage('months', true);
        }
    } else if (days) {
        if (days == 1) {
            answer = days + ' ' + ezyweb.getI18nMessage('day', true);
        } else {
            answer = days + ' ' + ezyweb.getI18nMessage('days', true);
        }
    } else if (hours) {
        if (hours == 1) {
            answer = hours + ' ' + ezyweb.getI18nMessage('hour', true);
        } else {
            answer = hours + ' ' + ezyweb.getI18nMessage('hours', true);
        }
    } else if (minutes) {
        if (minutes == 1) {
            answer = minutes + ' ' + ezyweb.getI18nMessage('minute', true);
        } else {
            answer = minutes + ' ' + ezyweb.getI18nMessage('minutes', true);
        }
    } else if (seconds) {
        if (seconds == 1) {
            answer = seconds + ' ' + ezyweb.getI18nMessage('second', true);
        } else {
            answer = seconds + ' ' + ezyweb.getI18nMessage('seconds', true);
        }
    }
    if (includeSuffix == false) {
        return answer;
    }
    return answer + ' ' + (
        ago
        ? ezyweb.getI18nMessage('ago', true)
        : ezyweb.getI18nMessage('more', true)
    );
}

// ============== util ======================
ezyweb.formatTotalResults = function(totalResults, maxTotalResults) {
    var maxValue = maxTotalResults || ezyweb.paginationCountLimit || 1000000;
    var textAnswer = ezyweb.formatNumberWithCommas(totalResults);
    if (totalResults >= maxValue) {
        textAnswer += '+';
    }
    return textAnswer;
}

ezyweb.formatNumberWithCommas = function(input) {
    input = ('' + input).replace(/,/g, "");
    var parts = input.split(".");
    var integerPart = parts[0];
    var decimalPart = parts.length > 1 ? "." + parts[1] : "";
    integerPart = integerPart.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return integerPart + decimalPart;
}

ezyweb.listToBooleanMap = function(list) {
    var map = {};
    list.forEach(item => {
        map[item] = true;
    });
    return map;
}

ezyweb.removeItemFromList = function(list, itemToRemove) {
    var index = list.indexOf(itemToRemove);
    if (index > -1) {
        list.splice(index, 1);
    }
}

ezyweb.moduleContainerFolders = {
    'admin-plugin': 'plugins',
    'socket-plugin': 'plugins',
    'socket-app': 'apps',
    'web-plugin': 'plugins',
    'theme': 'themes',
};

ezyweb.moduleTypeShortNames = {
    'admin-plugin': 'Plugin',
    'socket-plugin': 'Plugin',
    'socket-app': 'App',
    'web-plugin': 'Plugin',
    'theme': 'Theme',
};

ezyweb.moduleTypeNames = {
    'admin-plugin': 'Admin Plugin',
    'socket-plugin': 'Socket Plugin',
    'socket-app': 'Socket Application',
    'web-plugin': 'Web Plugin',
    'theme': 'Theme',
};

ezyweb.getModuleTypeShortName = function(moduleType) {
    return ezyweb.moduleTypeShortNames[moduleType] || ezyweb.toCapitalizeString(moduleType);
}

ezyweb.getModuleTypeName = function(moduleType) {
    return ezyweb.moduleTypeNames[moduleType] || ezyweb.toCapitalizeString(moduleType);
}

ezyweb.getModuleTypeNames = function(moduleTypes) {
    var moduleTypeNames = [];
    moduleTypes.forEach(moduleType => {
        moduleTypeNames.push(ezyweb.getModuleTypeName(moduleType));
    });
    return moduleTypeNames.join(', ');
}

ezyweb.errorMessageByCode = {
    'required': ezyweb.getI18nMessage('required'),
    'invalid': ezyweb.getI18nMessage('invalid'),
    'notFound': ezyweb.getI18nMessage('not_found'),
    'tooShort': ezyweb.getI18nMessage('too_short'),
    'tooLong': ezyweb.getI18nMessage('too_long'),
    'overLength': ezyweb.getI18nMessage('over_length'),
    'duplicated': ezyweb.getI18nMessage('duplicated'),
    'incorrect': ezyweb.getI18nMessage('incorrect'),
    'mismatch': ezyweb.getI18nMessage('mismatch'),
    'tooMany': ezyweb.getI18nMessage('too_many'),
    'rejected': ezyweb.getI18nMessage('rejected')
};

ezyweb.getErrorMessageByCode = function(code) {
    var errorMessage = ezyweb.errorMessageByCode[code];
    return errorMessage || ezyweb.getI18nMessage('invalid');
}

ezyweb.textColorByStatus = {
    'ACTIVATED': 'text-success',
    'ARCHIVED': 'text-info',
    'APPROVED': 'text-success',
    'APPROVING': 'text-primary',
    'BLOCKING': 'text-primary',
    'BLOCKED': 'text-danger',
    'BURNED': 'text-secondary',
    'CLOSED': 'text-danger',
    'DELETED': 'text-danger',
    'INACTIVATED': 'text-secondary',
    'MINTED': 'text-info',
    'OPENED': 'text-success',
    'PUBLISHED': 'text-success',
    'REGISTER_OPENED': 'text-success',
    'REGISTER_CLOSED': 'text-danger',
    'REJECTED': 'text-danger',
    'REVIEWING': 'text-primary',
    'RELEASABLE': 'text-info',
    'RELEASED': 'text-success'
};

ezyweb.getTextColorByStatus = function(status) {
    var textColor = ezyweb.textColorByStatus[status];
    return textColor || '';
}

ezyweb.toDisplayString = function(str) {
    if (!str) {
        return '';
    }
    var answer = str
        .replaceAll('.', ' ')
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .replaceAll('  ', ' ');
    if (answer.length <= 1) {
        return answer;
    }
    return answer[0].toUpperCase() + answer.substring(1);
}

ezyweb.toCapitalizeString = function(str) {
    var displayString = ezyweb.toDisplayString(str);
    var arr = str.split(' ');
    for (var i = 0; i < arr.length; i++) {
        arr[i] = arr[i].charAt(0).toUpperCase() + arr[i].slice(1);
    }
    return arr.join(' ');
}

ezyweb.truncateString = function(str, maxLength, suffix) {
    if (!str) {
        return '';
    }
    if (str.length <= maxLength) {
        return str;
    }
    var answer = str.substring(0, maxLength);
    if (suffix) {
        answer += ' ' + suffix;
    }
    return answer;
}

ezyweb.escapeHtml = function(value) {
    if (!value) {
        return '';
    }
    return String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

ezyweb.removeHtmlTagAndSub = function(html, maxLength, ellipsis) {
    if (!html) {
        return '';
    }
    var answer = '';
    var endWord = false;
    var isTagContent = false;
    for (var i = 0 ; i < html.length ; ++i) {
        if (html[i] == '<') {
            isTagContent = true;
        }
        if (isTagContent) {
            if (html[i] == '>') {
                isTagContent = false;
            }
            if (answer.length > 1 && answer[answer.length - 1] != ' ') {
                answer += ' ';
            }
            continue;
        }
        if (html[i] == '\t' || html[i] == '\n' || html[i] == ' ') {
            if (answer.length > 1 && answer[answer.length - 1] != ' ') {
                answer += ' ';
            }
            endWord = true;
        } else {
            answer += html[i];
            endWord = false;
        }
        if (answer.length >= maxLength && endWord) {
            break;
        }
    }
    return answer + (ellipsis != false ? ' ...' : '');
}

ezyweb.normalCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
ezyweb.randomString = function(length) {
    var result           = '';
    var characters       = ezyweb.normalCharacters;
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

ezyweb.getCurrentUrlParameter = function(paramName) {
    return (new URL(document.location)).searchParams.get(paramName);
}

ezyweb.joinToString = function(array, separator, itemMapper) {
    var str = '';
    for (var i = 0; i < array.length; ++i) {
        str += itemMapper ? itemMapper(array[i]) : array[i];
        if (i < array.length - 1) {
            str += separator;
        }
    }
    return str;
}

ezyweb.mergeObjects = function(objects) {
    var answer = {};
    objects.forEach(obj => {
        Object.entries(obj).forEach(([key, value]) => {
            answer[key] = value;
        });
    });
    return answer;
}

ezyweb.mergeObjectsToFirst = function(objects) {
    var answer = objects[0];
    for (var i = 1 ; i < objects.length ; ++i) {
        Object.entries(objects[i]).forEach(([key, value]) => {
            answer[key] = value;
        });
    }
}

ezyweb.deepMergeObjects = function(target, ...sources) {
    if (typeof target !== 'object' || target === null) {
        return target;
    }
    var stack = [];
    for (var source of sources) {
        if (typeof source !== 'object' || source === null) {
            continue;
        }
        stack.push({ target, source });
    }
    while (stack.length) {
        var { target: currentTarget, source: currentSource } = stack.pop();
        for (const key in currentSource) {
            if (!Object.prototype.hasOwnProperty.call(currentSource, key)) {
                continue;
            }
            const srcVal = currentSource[key];
            const tgtVal = currentTarget[key];
            if (
                typeof tgtVal === 'object' &&
                typeof srcVal === 'object' &&
                tgtVal !== null &&
                srcVal !== null &&
                !Array.isArray(tgtVal) &&
                !Array.isArray(srcVal)
            ) {
                stack.push({ target: tgtVal, source: srcVal });
            } else {
                currentTarget[key] = srcVal;
            }
        }
    }
    return target;
}

ezyweb.fetchAll = function(fetchFunctions, callback) {
    var targetCountdown = 0;
    var conditionFunc = fetchFunction => {
        if (fetchFunction.condition) {
            return fetchFunction.condition();
        }
        return true;
    };
    fetchFunctions.forEach(fetchFunction => {
        if (conditionFunc(fetchFunction)) {
            ++targetCountdown;
        }
    });
    if (targetCountdown) {
        var countdown = 0;
        var finalCallback = () => {
            if ((++ countdown) == targetCountdown) {
                callback();
            }
        };
        fetchFunctions.forEach(fetchFunction => {
            if (conditionFunc(fetchFunction)) {
                fetchFunction(finalCallback);
            }
        });
    } else {
        callback();
    }
}

ezyweb.extractIframeSrcIfNeed = function(value) {
    var src = value;
    if (value.indexOf('<iframe') >= 0) {
        var regex = /src="([^"]+)"/;
        var match = value.match(regex);
        if (match && match[1]) {
            src = match[1];
        }
    }
    return src;
}

ezyweb.flattenObject = function(obj, parentKey = '', result = {}) {
    for (var key in obj) {
        if (obj.hasOwnProperty(key)) {
            var propName = parentKey ? `${parentKey}.${key}` : key;
            if (typeof obj[key] === 'object' && obj[key] !== null) {
                ezyweb.flattenObject(obj[key], propName, result);
            } else {
                result[propName] = obj[key];
            }
        }
    }
    return result;
}
// ============== component ======================
ezyweb.copyToClipboard = function(elementId, isInput, alertTextPrefix) {
    var copiedElement = $('#' + elementId);
    var text = isInput ? copiedElement.val() : copiedElement.text();
    navigator.clipboard.writeText(text.trim());
    if (shortToast) {
        shortToast(
            ezyweb.messages.clipboard,
            alertTextPrefix + ' ' + ezyweb.messages.copied.toLowerCase()
        );
    }
}

ezyweb.formViewByFormData = new WeakMap();
ezyweb.formDataToObject = function(formName) {
    var object = {};
    var formData = new FormData(document.querySelector(`#${formName}`));
    formData.forEach((value, key) => {
        if(!Reflect.has(object, key)){
            object[key] = value;
            return;
        }
        if(!Array.isArray(object[key])){
            object[key] = [object[key]];
        }
        object[key].push(value);
    });
    var formView = {};
    ezyweb.formViewByFormData.set(object, formView);
    Object.keys(object).forEach((key) => {
	    var id = $(`#${formName} [name="${key}"]`)
	        .attr('id') || key;
	    formView[id] = key;
	});
    return object;
}

ezyweb.setInputLengthText = function(inputId) {
    var inputElement = $('#' + inputId);
    var inputValue = inputElement ? inputElement.val() : '';
    inputValue = inputValue || '';
    $('#' + inputId + "Length").text(inputValue.length);
}

ezyweb.watchInputKeyDown = function(
    elementId,
    maxValueLength,
    onEnterCallback
) {
    var element = $('#' + elementId);
    element.keydown(function() {
        var keyword = $(this).val();
        if(event.key === 'Enter') {
            if (onEnterCallback) {
                onEnterCallback();
            }
        } else if (keyword.length > maxValueLength) {
            $(element).val(keyword.substring(0, keyword.length - 1));
        }
    });
    element.keyup(function() {
        $('#' + elementId + 'Length').text(
            element.val().length > maxValueLength
                ? maxValueLength
                : element.val().length
        );
    });
}

ezyweb.formatInputNumber = function (e) {
    $(e).val(ezyweb.formatNumberWithCommas($(e).val()));
}

ezyweb.extractMediaUrl = function(media) {
    return media
        ? ((media.url || '').trim() || ('/api/v1/media/' + media.name))
        : '';
}

ezyweb.scrollToElement = function(elementId, duration) {
    var actualElementId = elementId.startsWith('#')
        ? elementId
        : '#' + elementId;
    if (duration) {
        var element = $(actualElementId);
        if (element) {
            var offset = element.offset();
            if (offset) {
                $('html, body').animate({
                    scrollTop: offset.top
                }, duration);
            }
        }
    } else {
        document.querySelector(actualElementId).scrollIntoView();
    }
}
// ============== json ======================
ezyweb.syntaxHighlightJson = function(json) {
    if (typeof json != 'string') {
         json = JSON.stringify(json, undefined, 2);
    }
    json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    return json.replace(/('(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\'])*'(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
        var cls = 'number';
        if (/^'/.test(match)) {
            if (/:$/.test(match)) {
                cls = 'key';
            } else {
                cls = 'string';
            }
        } else if (/true|false/.test(match)) {
            cls = 'boolean';
        } else if (/null/.test(match)) {
            cls = 'null';
        }
        return '<span class="' + cls + '">' + match + '</span>';
    });
}

// ============== bytes ======================
var KB_SIZE = 1024;
var MB_SIZE = 1024 * KB_SIZE;
var GB_SIZE = 1024 * MB_SIZE;
var TB_SIZE = 1024 * GB_SIZE;
ezyweb.toCapacityString = function(input) {
    var tb = input / TB_SIZE | 0;
    if (tb) {
        return (input / TB_SIZE * 10 | 0) / 10 + 'TB';
    }
    var gb = input / GB_SIZE | 0;
    if (gb) {
        return (input / GB_SIZE * 10 | 0) / 10 + 'GB';
    }
    var mb = input / MB_SIZE | 0;
    if (mb) {
        return (input / MB_SIZE * 10 | 0) / 10 + 'MB';
    }
    var kb = input / KB_SIZE | 0;
    if (kb) {
        return (input / KB_SIZE * 10 | 0) / 10 + 'KB';
    }
    return input + 'B';
}

// ============== metrics ======================
var THOUSAND = 1000;
var MILLION = 1000 * THOUSAND;
var BILLION = 1000 * MILLION;
var TRILLION = 1000 * BILLION;
ezyweb.toCountString = function(input) {
    var tb = input / TRILLION | 0;
    if (tb) {
        return (input / TRILLION * 10 | 0) / 10 + 'T';
    }
    var gb = input / BILLION | 0;
    if (gb) {
        return (input / BILLION * 10 | 0) / 10 + 'B';
    }
    var mb = input / MILLION | 0;
    if (mb) {
        return (input / MILLION * 10 | 0) / 10 + 'M';
    }
    var kb = input / THOUSAND | 0;
    if (kb) {
        return (input / THOUSAND  * 10 | 0) / 10 + 'K';
    }
    return input;
}

// ==================== cookie ===========
ezyweb.setCookie = function(name, value, days) {
    var expires = "";
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + value + expires + "; path=/";
}

ezyweb.deleteCookie = function(name) {
  document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
}

ezyweb.getCookie = function(cname) {
    var cookies = document.cookie.split('; ');
    for (var i = 0 ; i < cookies.length ; ++i) {
        var equalIndex = cookies[i].indexOf('=');
        var keyValue = [
            cookies[i].substring(0, equalIndex).trim(),
            cookies[i].substring(equalIndex + 1).trim()
        ];
        if (keyValue[0] == cname && keyValue[1]) {
            return keyValue[1];
        }
    }
    return '';
}

ezyweb.getCookieAccessToken = function() {
    return ezyweb.getCookie('accessToken');
}

ezyweb.getCookieSocketAccessToken = function() {
    return ezyweb.getCookie('socketAccessToken');
}

// ================= on page ==========
ezyweb.showLoadingScreen = function(options) {
	if (ezyweb.loadingScreenShowing) {
		return;
	}
	ezyweb.loadingScreenShowing = true;
	var actualOptions = options || {};
	if (actualOptions.showPercent) {
		$('#ezyLoadingScreenPercent').text('0%').removeClass('d-none');
	} else {
		$('#ezyLoadingScreenPercent').addClass('d-none');
	}
	$('#loadingScreen').removeClass('d-none');
}

ezyweb.setLoadingScreenPercent = function(percent) {
	$('#ezyLoadingScreenPercent').text(`${percent}%`);
}

ezyweb.hideLoadingScreen = function() {
	if (ezyweb.loadingScreenShowing) {
		ezyweb.loadingScreenShowing = false;
        $('#loadingScreen').addClass('d-none');
    }
}

ezyweb.logout = function() {
	var form = document.createElement('form');
    form.method = 'POST';
    form.action = '/logout' + (ezyweb.lang ? '?lang=' + ezyweb.lang : '');
    document.body.appendChild(form);
    form.submit();
}

ezyweb.redirectToLogin = function() {
	document.cookie = 'accessToken=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
	window.location = '/login' + (ezyweb.lang ? '?lang=' + ezyweb.lang : '');
}

ezyweb.redirectToNotFound = function() {
	window.location = '/not-found' + (ezyweb.lang ? '?lang=' + ezyweb.lang : '');
}

ezyweb.redirectToServerError = function() {
	window.location = '/server-error' + (ezyweb.lang ? '?lang=' + ezyweb.lang : '');
}

ezyweb.processGetApiErrors = function(responseData, handler) {
	ezyweb.processUpdateApiErrors({}, responseData, handler);
}

ezyweb.processUpdateApiErrors = function(formData, responseData, handler) {
    if (!responseData) {
        if (shortToast) {
            shortToast(
                ezyweb.messages.warning,
                ezyweb.messages.check_your_internet_connection,
            );
        }
        return;
    }
	if (responseData.status == 401) {
		ezyweb.redirectToLogin();
    	return;
	} else if (responseData.status == 404 && (!handler || !handler[404])) {
		return;
	}  else if (responseData.status == 403 && (!handler || !handler[403])) {
        return;
    } else if (responseData.status == 500 && (!handler || !handler[500])) {
		return;
	}
	var errors = responseData.responseJSON || {};
	var formView = ezyweb.formViewByFormData.get(formData);
	if (formView) {
        Object.entries(formView).forEach(([key, value]) => {
            errors[key] = errors[value];
        });
	}
	for (var key in errors) {
        if (!errors[key]) {
            delete errors[key];
        }
    }
	Object.keys(errors).forEach((field) => {
        var error = errors[field];
        var errorText = $('#' + field + 'Error');
        if (errorText.length) {
            errorText.text(ezyweb.getErrorMessageByCode(error));
        }
        var errorLabel = $('#' + field + 'ErrorLabel');
        if (errorLabel.length) {
            errorLabel.removeClass('d-none');
        }
    });
    formView = formView || formData;
	Object.keys(formView).forEach((field) => {
		if (!errors[field]) {
			var errorLabel = $('#' + field + 'ErrorLabel');
			if (errorLabel.length) {
				errorLabel.addClass('d-none');
			}
		}
	});
	if (handler) {
		if (handler.postHandle) {
			handler.postHandle(responseData);
		} else {
			handler(responseData);
		}
	}
}

ezyweb.hideFormErrors = function(formData) {
    var formView = ezyweb.formViewByFormData.get(formData) || formData;
	Object.keys(formView).forEach((field) => {
		var errorLabel = $('#' + field + 'ErrorLabel');
		if (errorLabel.length) {
			errorLabel.addClass('d-none');
		}
	});
}

ezyweb.resetFormData = function(formData, resetAllFields) {
    var formView = ezyweb.formViewByFormData.get(formData) || formData;
	ezyweb.hideFormErrors(formView);
	Object.keys(formView).forEach((field) => {
		var dataField = $('#' + field);
		if (resetAllFields) {
            dataField.val('');
        } else {
            if (!dataField.is('select')) {
                dataField.val('');
            }
        }
	});
}

ezyweb.getUploadFileApiErrorMessage = function(responseData) {
	var message;
	var error = responseData.responseJSON || {}
    if(responseData.status == 403) {
        message = ezyweb.messages.permission_denied;
    } else if(responseData.status == 400) {
        if (error.fileType) {
			message = ezyweb.messages.invalid_file_type;
		} else if (error.uploadSize) {
			message = ezyweb.messages.file_too_big;
		} else if (error.fileName || error.fileExtension) {
			message = ezyweb.messages.invalid_upload_file;
		}
	} else {
	    message = ezyweb.messages.server_error;
	}
	return message;
}

ezyweb.processUploadFileApiErrors = function(responseData, uploadView) {
	if (responseData.status == 401) {
		ezyweb.redirectToLogin();
    	return;
	}
	var errorMessage = ezyweb.getUploadFileApiErrorMessage(responseData);
    if (errorMessage) {
	    var fileInputId = uploadView.name + 'File';
        $('#' + fileInputId).val('');
        $('#' + fileInputId + 'Label').text(uploadView.chooseFileLabelText);
        $('#' + fileInputId + 'Error').text(errorMessage);
        $('#' + fileInputId + 'ErrorLabel').removeClass('d-none');
	}
}

ezyweb.formatDateStringElements = function() {
 	$('.date-string').each((index, e) => {
        var timestamp = $(e).text();
        if (!isNaN(timestamp)) {
            $(e).text(ezyweb.formatTimeStampDate(parseInt(timestamp, 10)));
        }
    });
}

ezyweb.formatTimeStringElements = function() {
	$('.time-string').each((index, e) => {
        var timestamp = $(e).text();
        if (!isNaN(timestamp)) {
            $(e).text(ezyweb.formatTimeStampTime(parseInt(timestamp, 10)));
        }
    });
}

ezyweb.formatDateTimeStringElements = function() {
	$('.date-time-string').each((index, e) => {
        var timestamp = $(e).text();
        if (!isNaN(timestamp)) {
            $(e).text(ezyweb.formatTimeStamp(parseInt(timestamp, 10)));
        }
    });
}

ezyweb.formatDateTimeMinuteStringElements = function() {
 	$('.date-time-minute-string').each((index, e) => {
 		var timestamp = $(e).text();
 		if (!isNaN(timestamp)) {
        	$(e).text(ezyweb.formatTimeStampMinute(parseInt(timestamp, 10)));
        }
    });
}

ezyweb.formatStatusTextElements = function() {
	$('.status-text').each((index, e) => {
        $(e).addClass(ezyweb.getTextColorByStatus($(e).attr('status')));
    });
}

ezyweb.formatNumberWithCommasElements = function() {
    $('.commas-number-string').each((index, e) => {
        var number = $(e).text();
        if (number) {
            number = number.trim();
            if (!isNaN(number)) {
                $(e).text(ezyweb.formatNumberWithCommas(number));
            }
        }
    });
}

ezyweb.createDataTable = function(tableId, pageLength, searching) {
	return $('#' + tableId).DataTable({
		'paging': true,
		'lengthChange': false,
		'searching': searching != false,
		'ordering': true,
		'info': true,
		'autoWidth': false,
		'responsive': true,
		'pageLength': pageLength || 5,
		'drawCallback': function( settings ) {
			ezyweb.formatDateStringElements();
    		ezyweb.formatDateTimeStringElements();
    		ezyweb.formatStatusTextElements();
		}
	});
}

ezyweb.appendLangParameterToUrl = function(url) {
    if (ezyweb.lang) {
		return url.includes("?")
		    ? (url + '&lang=' + ezyweb.lang)
		    : (url + '?lang=' + ezyweb.lang)
    }
    return url;
}

ezyweb.appendLangParameterToFormActions = function() {
    if (ezyweb.lang) {
		$('form').each((index, e) => {
			var ezyUri = $(e).attr('action');
			if (ezyUri && ezyUri.startsWith('/')) {
				var ezyUriNew = ezyUri.includes("?")
					? (ezyUri + '&lang=' + ezyweb.lang)
					: (ezyUri + '?lang=' + ezyweb.lang)
				$(e).attr('action', ezyUriNew);
			}
		});
    }
}

ezyweb.appendLangParameterToLinks = function(language) {
    var lang = language || ezyweb.lang;
    $('a').each((index, e) => {
        var ezyUri = $(e).attr('href');
        if (ezyUri && ezyUri.startsWith('/') && ezyUri.indexOf('lang=') < 0) {
            var ezyUriNew = ezyUri.includes('?')
                ? (ezyUri + '&lang=' + lang)
                : (ezyUri + '?lang=' + lang)
            $(e).attr('href', ezyUriNew);
        }
    });
}

ezyweb.wrapTextIfNeed = function(text, tag, need) {
    return need ? '<' + tag + '>' + text + '</' + tag + '>' : text;
}

ezyweb.onLanguageSelected = function(selectedLanguage) {
	var windowLocation = window.location;
	var newQueryParams = '';
	if (windowLocation.search) {
		var queryParams = windowLocation.search
			.substring(1)
			.split('&');
		for(var i = 0; i < queryParams.length; i++) {
			var queryParam = queryParams[i].split('=');
			if (queryParam[0] != 'lang') {
				newQueryParams += (newQueryParams ? '&' : '?') + queryParams[i];
			}
		}
	}
	if (selectedLanguage != ezyweb.defaultLang) {
		newQueryParams += (newQueryParams ? '&' : '?') + 'lang=' + selectedLanguage;
	}
	ezyweb.setCookie('lang', selectedLanguage);
	window.location = windowLocation.pathname + newQueryParams;
}

// ============== csv ======================
ezyweb.onCsvFileChanged = function(input, callback, includeFirstLine) {
    var file = input.files[0];
    if (file) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var content = e.target.result;
            var rowsList = ezyweb.parseCsvContent(
                content
            );
            callback(file, rowsList);
        };
        reader.readAsText(file);
    }
}

ezyweb.parseCsvContent = function(content, includeFirstLine) {
    var lines = content.split('\n');
    var rows = [];
    if (lines.length) {
        var firstLine = lines[0];
        var commas = firstLine.indexOf(',') >= 0 ? ',' : ';';
        if (!includeFirstLine) {
            lines = lines.slice(1);
        }
        lines.forEach((line) => {
            rows.push(ezyweb.readCsvLine(line, commas));
        });
    }
    return rows;
}

ezyweb.readCsvLine = function (line, commas) {
    var cells = [];
    var cell = '';
    var inQuotes = false;
    for (var i = 0; i < line.length; ++i) {
        var ch = line[i];
        if (ch == '"') {
            inQuotes = !inQuotes;
        } else if (ch == commas && !inQuotes) {
            cells.push(cell.trim());
            cell = '';
        } else {
            cell += ch;
        }
    }
    cells.push(cell.trim());
    return cells;
};
