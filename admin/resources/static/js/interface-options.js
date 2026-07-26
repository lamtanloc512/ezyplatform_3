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

(function ($) {
'use strict'

    function toggleDarkMode()  {
        var darkMode = localStorage.getItem('darkMode');
        if (darkMode == 'true') {
            $('body').addClass('dark-mode')
        } else {
            $('body').removeClass('dark-mode')
        }
    }

    var $sidebar = $('.control-sidebar')
    var $container = $('<div />', {
        class: 'p-3 control-sidebar-content'
    })

    $sidebar.append($container)

    $container.append(
        '<h5>' + ezyadmin.messages.interface_options + '</h5><hr class="mb-2"/>'
    )

    var darkMode = localStorage.getItem('darkMode');
    var $dark_mode_checkbox = $('<input />', {
        type: 'checkbox',
        value: 1,
        checked: $('body').hasClass('dark-mode') || darkMode == 'true',
        class: 'mr-1'
    }).on('click', function () {
        localStorage.setItem('darkMode', $(this).is(':checked'));
        toggleDarkMode();
    })
    var $dark_mode_container = $(
            '<div />',
            { class: 'mb-4' }
        )
        .append($dark_mode_checkbox)
        .append('<span>' + ezyadmin.messages.dark_mode + '</span>')
    $container.append($dark_mode_container)

    toggleDarkMode();
    var controlSidebarHiding = false;
    $(document).click(function(event) {
        var $target = $(event.target);
        if(!controlSidebarHiding
            && !$target.closest('.control-sidebar').length
            && !$target.hasClass('control-sidebar-toggle')
            && $('.control-sidebar').css("display") != 'none'
        ) {
            controlSidebarHiding = true;
            $('#control-sidebar-toggle-button').trigger('click');
        }
        controlSidebarHiding = false;
    });

})(jQuery)
