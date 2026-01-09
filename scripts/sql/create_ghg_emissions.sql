CREATE TABLE `ghg_emissions` (
  `year` smallint unsigned DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `economic_sector` varchar(100) DEFAULT NULL,
  `emissions_mmt_co2e` decimal(13,9) DEFAULT NULL,
  `record_type` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;