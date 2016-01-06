/*
* Copyright (c) 2015 LabKey Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

ALTER TABLE fcs_header_marker_pkey
DROP CONSTRAINT PRIMARY KEY (fcs_header_id);

ALTER TABLE fcs_header_marker_pkey
ADD CONSTRAINT PRIMARY KEY (fcs_header_id,parameter_number);

ALTER TABLE reagent_set_2_reagent_pkey
DROP CONSTRAINT PRIMARY KEY (reagent_set_accession);

ALTER TABLE reagent_set_2_reagent_pkey
ADD CONSTRAINT PRIMARY KEY (reagent_set_accession,reagent_accession);
