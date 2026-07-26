/*
 * Copyright 2025 youngmonkeys.org
 * 
 * Licensed under the ezyplatform, Version 1.0.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * https://youngmonkeys.org/licenses/ezyplatform-1.0.0.txt
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

ALTER TABLE `ezy_settings`
MODIFY COLUMN `data_type` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'STRING';

ALTER TABLE `ezy_role_features`
MODIFY COLUMN `target` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL,
MODIFY COLUMN `feature_method` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL;

ALTER TABLE `ezy_medias`
MODIFY COLUMN `upload_from` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL,
MODIFY COLUMN `media_type` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL;

ALTER TABLE `ezy_letters`
MODIFY COLUMN `content_type` varchar(50) COLLATE utf8mb4_unicode_520_ci;

ALTER TABLE `ezy_notifications`
MODIFY COLUMN `content_type` varchar(50) COLLATE utf8mb4_unicode_520_ci;

ALTER TABLE `ezy_content_templates`
MODIFY COLUMN `content_type` varchar(50) COLLATE utf8mb4_unicode_520_ci,
MODIFY COLUMN `creator_type` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'ADMIN';

ALTER TABLE `ezy_links`
MODIFY COLUMN `link_type` varchar(50) COLLATE utf8mb4_unicode_520_ci;

ALTER TABLE `ezy_admin_activity_histories`
MODIFY COLUMN `method` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL,
MODIFY COLUMN `uri_type` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL;
