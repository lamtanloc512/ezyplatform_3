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

CREATE TABLE IF NOT EXISTS `ezy_data_record_counts` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
    `data_type` varchar(300) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    `data_name` varchar(150) COLLATE utf8mb4_unicode_520_ci,
    `record_type` varchar(150) COLLATE utf8mb4_unicode_520_ci,
    `record_count` bigint NOT NULL,
    `last_record_id` bigint unsigned NOT NULL,
    `last_counted_at` datetime NOT NULL,
    `query_string` mediumtext COLLATE utf8mb4_unicode_520_ci,
    `query_type` varchar(50) COLLATE utf8mb4_unicode_520_ci,
    `parameters` mediumtext COLLATE utf8mb4_unicode_520_ci,
    `parameters_type` varchar(50) COLLATE utf8mb4_unicode_520_ci,
    PRIMARY KEY (`id`),
    UNIQUE KEY `key_data_type` (`data_type`),
    INDEX `index_data_type_last_counted_at_id` (`data_type`, `last_counted_at`, `id`),
    INDEX `index_data_name_record_type` (`data_name`, `record_type`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
