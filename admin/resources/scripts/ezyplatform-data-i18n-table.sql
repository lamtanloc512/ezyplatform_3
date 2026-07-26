/*
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

CREATE TABLE IF NOT EXISTS `ezy_data_i18n` (
    `data_type` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    `data_id` bigint unsigned NOT NULL,
    `language` varchar(64) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    `field_name` varchar(60) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    `field_value` mediumtext COLLATE utf8mb4_unicode_520_ci,
    PRIMARY KEY (`data_type`, `data_id`, `language`, `field_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
