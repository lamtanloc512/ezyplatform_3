/*
 * Copyright 2025 youngmonkeys.org
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

ALTER TABLE `ezy_settings`
    MODIFY COLUMN `data_type` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'STRING';

ALTER TABLE `ezy_admins`
    MODIFY COLUMN `username` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    MODIFY COLUMN `status` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'ACTIVATED';

ALTER TABLE `ezy_admin_access_tokens`
    MODIFY COLUMN `token` varchar(300) NOT NULL,
    MODIFY COLUMN `status` varchar(50) COLLATE utf8mb4_unicode_520_ci;

ALTER TABLE `ezy_admin_role_names`
    MODIFY COLUMN `name` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    MODIFY COLUMN `display_name` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL;

ALTER TABLE `ezy_medias`
    MODIFY COLUMN `upload_from` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    MODIFY COLUMN `media_type` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL;

ALTER TABLE `ezy_users`
    MODIFY COLUMN `status` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'INACTIVATED';

ALTER TABLE `ezy_user_access_tokens`
    MODIFY COLUMN `token` varchar(300) NOT NULL,
    MODIFY COLUMN `status` varchar(50) COLLATE utf8mb4_unicode_520_ci;

ALTER TABLE `ezy_user_role_names`
    MODIFY COLUMN `name` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    MODIFY COLUMN `display_name` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL;

ALTER TABLE `ezy_admin_projects`
    MODIFY COLUMN `project_name` varchar(300) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    MODIFY COLUMN `version_name` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL;

ALTER TABLE `ezy_content_templates`
    MODIFY COLUMN `status` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'DRAFT';

ALTER TABLE `ezy_data_record_counts`
    MODIFY COLUMN `query_type` varchar(50) COLLATE utf8mb4_unicode_520_ci,
    MODIFY COLUMN `parameters_type` varchar(50) COLLATE utf8mb4_unicode_520_ci;
