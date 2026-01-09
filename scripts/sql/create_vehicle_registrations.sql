CREATE TABLE `vehicle_registrations` (
  `year` smallint unsigned DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `fuel_type` varchar(100) DEFAULT NULL,
  `registrations` bigint unsigned DEFAULT NULL,
  `record_type` varchar(19) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;