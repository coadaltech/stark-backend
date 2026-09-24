CREATE TABLE `chat_group` (
    `ChatGroupId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `ChatGroupName` varchar(50) NOT NULL,
    `IsAllow` int DEFAULT '1',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`ChatGroupId`),
    KEY `ChatGroupId` (`ChatGroupId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 6 DEFAULT CHARSET = latin1;

CREATE TABLE `chat_group_receiver` (
    `ChatGroupDetailId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `ChatGroupId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`ChatGroupDetailId`),
    KEY `ChatGroupId` (`ChatGroupId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 234 DEFAULT CHARSET = latin1;

CREATE TABLE `chat_ledger_associate` (
    `ChatledgerassociateId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `AssociateLedgerId` bigint NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`ChatledgerassociateId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = latin1;

CREATE TABLE `comman_master` (
    `CommanMasterId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `CommanMasterName` varchar(200) NOT NULL,
    `CommanMasterType` int NOT NULL,
    `LedgerId` bigint NOT NULL,
    `ParentAgentLedgerId` bigint DEFAULT '0',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`CommanMasterId`),
    KEY `CommanMasterId` (`CommanMasterId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `CommanMasterType` (`CommanMasterType`)
) ENGINE = InnoDB AUTO_INCREMENT = 709 DEFAULT CHARSET = latin1;

CREATE TABLE `declare_result` (
    `DeclareId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL,
    `DeclareDate` date NOT NULL,
    `DeclareNumber` int NOT NULL,
    `IsNeeded` enum('Yes', 'No') NOT NULL DEFAULT 'No',
    `ReDeclareNos` int DEFAULT '0',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`DeclareId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `ShiftId` (`ShiftId`),
    KEY `DeclareDate` (`DeclareDate`)
) ENGINE = InnoDB AUTO_INCREMENT = 82997 DEFAULT CHARSET = latin1;

CREATE TABLE `hissa` (
    `HissaId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `HissaLedgerId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `Hissa` float NOT NULL,
    `HissaLimit` float NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`HissaId`),
    KEY `HissaId` (`HissaId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `HissaLedgerId` (`HissaLedgerId`)
) ENGINE = InnoDB AUTO_INCREMENT = 31674 DEFAULT CHARSET = latin1;

CREATE TABLE `hp_hissa` (
    `HPHissaId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint DEFAULT NULL,
    `LedgerId` bigint DEFAULT NULL,
    `HPLedgerId` bigint DEFAULT NULL,
    `VoucherId` bigint DEFAULT NULL,
    `VoucherDate` date NOT NULL,
    `HPFromDate` date DEFAULT NULL,
    `HPToDate` date DEFAULT NULL,
    `BaseAmount` float DEFAULT NULL,
    `HPPercent` float DEFAULT NULL,
    `HPAmount` float DEFAULT NULL,
    `RecordStatus` char(1) DEFAULT NULL,
    `AddedBy` varchar(50) DEFAULT NULL,
    `AddedDate` datetime DEFAULT NULL,
    `UpdatedBy` varchar(50) DEFAULT NULL,
    `UpdatedDate` datetime DEFAULT NULL,
    PRIMARY KEY (`HPHissaId`),
    KEY `LedgerId` (`LedgerId`)
) ENGINE = InnoDB AUTO_INCREMENT = 104540 DEFAULT CHARSET = latin1;

CREATE TABLE `hp_settelment` (
    `HPSettelmentId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint DEFAULT NULL,
    `LedgerId` bigint DEFAULT NULL,
    `SettelmentLedgerId` bigint DEFAULT NULL,
    `VoucherId` bigint DEFAULT NULL,
    `VoucherDate` date NOT NULL,
    `SettelmentFromDate` date DEFAULT NULL,
    `SettelmentToDate` date DEFAULT NULL,
    `SettelmentAmount` float DEFAULT NULL,
    `RecordStatus` char(1) DEFAULT NULL,
    `AddedBy` varchar(50) DEFAULT NULL,
    `AddedDate` datetime DEFAULT NULL,
    `UpdatedBy` varchar(50) DEFAULT NULL,
    `UpdatedDate` datetime DEFAULT NULL,
    PRIMARY KEY (`HPSettelmentId`)
) ENGINE = InnoDB AUTO_INCREMENT = 399857 DEFAULT CHARSET = latin1;

CREATE TABLE `kist` (
    `KistId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `VoucherId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `KistDate` date NOT NULL,
    `Amount` float NOT NULL,
    `KistType` varchar(50) NOT NULL,
    `KistStatus` enum('UNPAID', 'PAID') DEFAULT 'UNPAID',
    `PaidVoucherId` bigint NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`KistId`),
    KEY `KistId` (`KistId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `VoucherId` (`VoucherId`),
    KEY `KistDate` (`KistDate`)
) ENGINE = InnoDB AUTO_INCREMENT = 57400 DEFAULT CHARSET = latin1;

CREATE TABLE `ledger` (
    `LedgerId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL DEFAULT '0',
    `ParentLedgerId` bigint NOT NULL DEFAULT '0',
    `LedgerName` varchar(80) NOT NULL,
    `RealName` varchar(50) NOT NULL DEFAULT '',
    `GroupId` int NOT NULL,
    `AgentLedgerId` bigint NOT NULL,
    `LimitType` enum('NO', 'YES') NOT NULL,
    `DaraRate` float DEFAULT '0',
    `DaraCommission` float DEFAULT '0',
    `AkharRate` float DEFAULT '0',
    `AkharCommission` float DEFAULT '0',
    `Vapsi` float NOT NULL,
    `TPVapsi` enum('NO', 'YES') NOT NULL,
    `TPCommission` enum('No', 'YES') NOT NULL,
    `IsHissa` enum('NO', 'YES') NOT NULL,
    `IsDibba` enum('NO', 'YES') NOT NULL,
    `DibbaAmount` float NOT NULL,
    `RefLedgerId` bigint NOT NULL DEFAULT '0',
    `HPLedgerId` bigint NOT NULL DEFAULT '0',
    `Grantor` varchar(50) NOT NULL DEFAULT '',
    `DealingType` enum(
        'DAILY',
        'MONTHLY',
        '25K',
        '50K',
        '1L',
        '2K'
    ) DEFAULT 'DAILY',
    `IsReport` enum('1', '0') NOT NULL,
    `TransactionMode` smallint NOT NULL,
    `AccountStatus` enum('1', '0') NOT NULL,
    `IsHide` enum('0', '1') NOT NULL DEFAULT '0',
    `ChatGroupId` bigint DEFAULT '0',
    `TransactionCappingAmount` float DEFAULT '0',
    `IsApplyLedgerConfigOnTransaction` int DEFAULT '0',
    `IsRisky` smallint DEFAULT '1',
    `TransactionLock` int DEFAULT '0',
    `IsTransactionAllow` smallint DEFAULT '0',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`LedgerId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `GroupId` (`GroupId`),
    KEY `ParentLedgerId` (`ParentLedgerId`),
    KEY `RecordStatus` (`RecordStatus`)
) ENGINE = InnoDB AUTO_INCREMENT = 21536 DEFAULT CHARSET = latin1;

CREATE TABLE `ledger_asign` (
    `LedgerAsignId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `AsignDate` date NOT NULL,
    `StaffLoginId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`LedgerAsignId`),
    KEY `StaffLoginId` (`StaffLoginId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `AsignDate` (`AsignDate`),
    KEY `LedgerId` (`LedgerId`)
) ENGINE = InnoDB AUTO_INCREMENT = 74 DEFAULT CHARSET = latin1;

CREATE TABLE `ledger_feedback` (
    `FeedbackId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `CommanFeedbackId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `AsignAgentLedgerId` bigint DEFAULT '0',
    `CashPickDate` date DEFAULT '0000-00-00',
    `FeedbackDate` date NOT NULL,
    `Balance` float NOT NULL DEFAULT '0',
    `Remark` text NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`FeedbackId`),
    KEY `FeedbackId` (`FeedbackId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `CommanFeedbackId` (`CommanFeedbackId`)
) ENGINE = InnoDB AUTO_INCREMENT = 80 DEFAULT CHARSET = latin1;

CREATE TABLE `ledger_group` (
    `GroupId` int NOT NULL AUTO_INCREMENT,
    `GroupName` varchar(50) NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`GroupId`),
    KEY `GroupId` (`GroupId`)
) ENGINE = InnoDB AUTO_INCREMENT = 15 DEFAULT CHARSET = latin1;

CREATE TABLE `ledger_limit` (
    `LedgerId` bigint NOT NULL,
    `LedgerBalance` float DEFAULT NULL,
    `LedgerLimit` float DEFAULT NULL,
    `TransConsum` float DEFAULT NULL,
    `TransConsumAfterDeclare` float DEFAULT '0',
    `FinalLimit` float DEFAULT NULL,
    `RecordStatus` char(1) DEFAULT NULL,
    `AddedBy` varchar(50) DEFAULT NULL,
    `AddedDate` datetime DEFAULT NULL,
    `UpdatedBy` varchar(50) DEFAULT NULL,
    `UpdatedDate` datetime DEFAULT NULL,
    PRIMARY KEY (`LedgerId`),
    KEY `ledger_limit_LedgerId` (`LedgerId`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `ledger_telegram` (
    `LedgerTelegramId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL DEFAULT '0',
    `LedgerId` bigint DEFAULT '0',
    `FirstName` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
    `Mobile` varchar(20) NOT NULL,
    `TelegramId` bigint NOT NULL DEFAULT '0',
    `AccessHash` varchar(250) DEFAULT '',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`LedgerTelegramId`),
    KEY `LedgerTelegramId` (`LedgerTelegramId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `TelegramId` (`TelegramId`),
    KEY `LedgerId` (`LedgerId`)
) ENGINE = InnoDB AUTO_INCREMENT = 124 DEFAULT CHARSET = latin1;

CREATE TABLE `login` (
    `LoginId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `LoginName` varchar(80) NOT NULL,
    `AliasName` varchar(30) DEFAULT '',
    `UserName` varchar(30) NOT NULL,
    `Password` varchar(80) NOT NULL,
    `IsPasswordChangeNeeded` int DEFAULT '0',
    `LoginType` smallint NOT NULL,
    `Mobile` varchar(20) NOT NULL,
    `Address` varchar(50) DEFAULT '',
    `StaffWorkMode` int NOT NULL DEFAULT '0',
    `AccountStatus` enum('1', '0') NOT NULL,
    `AccessToken` text,
    `AccessTokenWeb` text,
    `DeviceId` varchar(500) DEFAULT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`LoginId`),
    KEY `LoginId` (`LoginId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `LoginType` (`LoginType`)
) ENGINE = InnoDB AUTO_INCREMENT = 21142 DEFAULT CHARSET = latin1;

CREATE TABLE `mainjantrinumbers` (
    `Num` int DEFAULT NULL,
    `profit` float DEFAULT NULL,
    `Id` bigint NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`Id`)
) ENGINE = InnoDB AUTO_INCREMENT = 101 DEFAULT CHARSET = utf8mb3;

CREATE TABLE `mainjantrinumbersprofit` (
    `amount1` float DEFAULT NULL,
    `amount2` float DEFAULT NULL,
    `amount3` float DEFAULT NULL,
    `amount4` float DEFAULT NULL,
    `amount5` float DEFAULT NULL,
    `amount6` float DEFAULT NULL,
    `amount7` float DEFAULT NULL,
    `amount8` float DEFAULT NULL,
    `amount9` float DEFAULT NULL,
    `amount10` float DEFAULT NULL,
    `amount11` float DEFAULT NULL,
    `amount12` float DEFAULT NULL,
    `amount13` float DEFAULT NULL,
    `amount14` float DEFAULT NULL,
    `amount15` float DEFAULT NULL,
    `amount16` float DEFAULT NULL,
    `amount17` float DEFAULT NULL,
    `amount18` float DEFAULT NULL,
    `amount19` float DEFAULT NULL,
    `amount20` float DEFAULT NULL,
    `amount21` float DEFAULT NULL,
    `amount22` float DEFAULT NULL,
    `amount23` float DEFAULT NULL,
    `amount24` float DEFAULT NULL,
    `amount25` float DEFAULT NULL,
    `amount26` float DEFAULT NULL,
    `amount27` float DEFAULT NULL,
    `amount28` float DEFAULT NULL,
    `amount29` float DEFAULT NULL,
    `amount30` float DEFAULT NULL,
    `amount31` float DEFAULT NULL,
    `amount32` float DEFAULT NULL,
    `amount33` float DEFAULT NULL,
    `amount34` float DEFAULT NULL,
    `amount35` float DEFAULT NULL,
    `amount36` float DEFAULT NULL,
    `amount37` float DEFAULT NULL,
    `amount38` float DEFAULT NULL,
    `amount39` float DEFAULT NULL,
    `amount40` float DEFAULT NULL,
    `amount41` float DEFAULT NULL,
    `amount42` float DEFAULT NULL,
    `amount43` float DEFAULT NULL,
    `amount44` float DEFAULT NULL,
    `amount45` float DEFAULT NULL,
    `amount46` float DEFAULT NULL,
    `amount47` float DEFAULT NULL,
    `amount48` float DEFAULT NULL,
    `amount49` float DEFAULT NULL,
    `amount50` float DEFAULT NULL,
    `amount51` float DEFAULT NULL,
    `amount52` float DEFAULT NULL,
    `amount53` float DEFAULT NULL,
    `amount54` float DEFAULT NULL,
    `amount55` float DEFAULT NULL,
    `amount56` float DEFAULT NULL,
    `amount57` float DEFAULT NULL,
    `amount58` float DEFAULT NULL,
    `amount59` float DEFAULT NULL,
    `amount60` float DEFAULT NULL,
    `amount61` float DEFAULT NULL,
    `amount62` float DEFAULT NULL,
    `amount63` float DEFAULT NULL,
    `amount64` float DEFAULT NULL,
    `amount65` float DEFAULT NULL,
    `amount66` float DEFAULT NULL,
    `amount67` float DEFAULT NULL,
    `amount68` float DEFAULT NULL,
    `amount69` float DEFAULT NULL,
    `amount70` float DEFAULT NULL,
    `amount71` float DEFAULT NULL,
    `amount72` float DEFAULT NULL,
    `amount73` float DEFAULT NULL,
    `amount74` float DEFAULT NULL,
    `amount75` float DEFAULT NULL,
    `amount76` float DEFAULT NULL,
    `amount77` float DEFAULT NULL,
    `amount78` float DEFAULT NULL,
    `amount79` float DEFAULT NULL,
    `amount80` float DEFAULT NULL,
    `amount81` float DEFAULT NULL,
    `amount82` float DEFAULT NULL,
    `amount83` float DEFAULT NULL,
    `amount84` float DEFAULT NULL,
    `amount85` float DEFAULT NULL,
    `amount86` float DEFAULT NULL,
    `amount87` float DEFAULT NULL,
    `amount88` float DEFAULT NULL,
    `amount89` float DEFAULT NULL,
    `amount90` float DEFAULT NULL,
    `amount91` float DEFAULT NULL,
    `amount92` float DEFAULT NULL,
    `amount93` float DEFAULT NULL,
    `amount94` float DEFAULT NULL,
    `amount95` float DEFAULT NULL,
    `amount96` float DEFAULT NULL,
    `amount97` float DEFAULT NULL,
    `amount98` float DEFAULT NULL,
    `amount99` float DEFAULT NULL,
    `amount100` float DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

CREATE TABLE `organization` (
    `OrganizationId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationOwnerName` varchar(30) NOT NULL,
    `OrganizationName` varchar(30) NOT NULL,
    `OrganizationLogoColor` varchar(20) NOT NULL,
    `OrganizationTheme` varchar(20) NOT NULL,
    `OrganizationThemeDesign` int DEFAULT '0',
    `OrganizationAppAccess` int DEFAULT '0',
    `OrganizationMobile` varchar(10) NOT NULL,
    `OrganizationAddress` varchar(60) NOT NULL,
    `OrganizationOnDomain` int NOT NULL DEFAULT '0',
    `OrganizationDomainURL` varchar(100) NOT NULL DEFAULT '',
    `OrganizationSms` enum('1', '0') NOT NULL,
    `OrganizationSmsUrl` varchar(100) NOT NULL,
    `OrganizationSmsUsername` varchar(30) NOT NULL,
    `OrganizationSmsPassword` varchar(30) NOT NULL,
    `OrganizationSmsPort` varchar(10) NOT NULL,
    `OrganizationSmsSenderId` varchar(10) NOT NULL,
    `OrganizationSmsToken` text NOT NULL,
    `IsTransactionEnable` enum('1', '0') NOT NULL,
    `IsEnableTazzaPatti` int NOT NULL DEFAULT '0',
    `IsMainJantriRoundOf` int DEFAULT '0',
    `IsCollectionJantriRoundOf` int DEFAULT '0',
    `IsMultiplyUpMainJantri` int DEFAULT '0',
    `IsMultiplyUpCollection` int DEFAULT '0',
    `RoundOffOnMainJantri` int DEFAULT '50',
    `RoundOffOnCollection` int DEFAULT '50',
    `skey_Random_Old` int NOT NULL DEFAULT '1',
    `skey_Crossing` int NOT NULL DEFAULT '1',
    `skey_FromTo` int NOT NULL DEFAULT '1',
    `skey_Random_New` int NOT NULL DEFAULT '1',
    `skey_OddEven` int NOT NULL DEFAULT '0',
    `skey_EkdiDukdi` int NOT NULL DEFAULT '0',
    `skey_Joda` int NOT NULL DEFAULT '0',
    `skey_JodiDaane` int DEFAULT '0',
    `IsVoucherVerify` smallint DEFAULT '0',
    `IsDashboardStaffGainerLooser` smallint DEFAULT '0',
    `IsAutoSalaryCreate` smallint DEFAULT '0',
    `IsAutoSalaryPaid` smallint DEFAULT '0',
    `IsTransactionAlreadyExist` smallint DEFAULT '0',
    `HissaNotApplyMode` int DEFAULT '0',
    `VapsiWorkingDays` int DEFAULT '0',
    `IsAutoUserNameForStaff` int DEFAULT '0',
    `UnPaidKistLastDateOfProcess` date DEFAULT '1970-01-01',
    `UnPaidKistPopupForDashboard` int DEFAULT '0',
    `IsBackLimitPopup` smallint DEFAULT '0',
    `AbsentLedgerLockDays` int DEFAULT '0',
    `TelegramAllow` smallint DEFAULT '0',
    `TelegramUrl` varchar(250) DEFAULT '',
    `TelegramSession` text,
    `OrganizationStartDate` date NOT NULL,
    `OrganizationEndDate` date NOT NULL,
    `IsOrganizationAllow` enum('1', '0') NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`OrganizationId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 1016 DEFAULT CHARSET = latin1;

CREATE TABLE `payroll_attendance` (
    `AttendanceId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `AttendanceDate` date NOT NULL,
    `AttendanceMonth` int DEFAULT '0',
    `AttendanceYear` int DEFAULT '0',
    `TotalDays` int DEFAULT '0',
    `WorkingDays` int DEFAULT '0',
    `PaidLeave` int DEFAULT '0',
    `Absent` int DEFAULT '0',
    `Present` int DEFAULT '0',
    `MonthEndLeaveApplicable` int DEFAULT '0',
    `TotalEntryCount` int DEFAULT '0',
    `Remark` varchar(100) NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`AttendanceId`),
    KEY `AttendanceId` (`AttendanceId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 12240 DEFAULT CHARSET = latin1;

CREATE TABLE `payroll_comman_master` (
    `CommanMasterId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `CommanName` varchar(100) NOT NULL,
    `CommanType` int DEFAULT '0',
    `IsAllow` int DEFAULT '1',
    `CommanOrder` int DEFAULT '1',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`CommanMasterId`),
    KEY `CommanMasterId` (`CommanMasterId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 32 DEFAULT CHARSET = latin1;

CREATE TABLE `payroll_issue_return_stock` (
    `IssueReturnStockId` bigint NOT NULL AUTO_INCREMENT,
    `StaffStockId` bigint NOT NULL DEFAULT '0',
    `LedgerId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `CommanMasterId` bigint NOT NULL,
    `IssueDate` date NOT NULL,
    `Amount` float DEFAULT '0',
    `Quantity` int DEFAULT '0',
    `Brand` varchar(100) NOT NULL,
    `BillPartNo` varchar(100) NOT NULL,
    `IsReturn` int DEFAULT '0',
    `Remark` varchar(100) NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`IssueReturnStockId`),
    KEY `IssueReturnStockId` (`IssueReturnStockId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `StaffStockId` (`StaffStockId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 71 DEFAULT CHARSET = latin1;

CREATE TABLE `payroll_leave` (
    `LeaveId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `LeaveDate` date NOT NULL,
    `IsPaid` int DEFAULT '0',
    `Remark` varchar(100) NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`LeaveId`),
    KEY `LeaveId` (`LeaveId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 3171 DEFAULT CHARSET = latin1;

CREATE TABLE `payroll_salary` (
    `SalaryId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `VoucherId` bigint NOT NULL,
    `SalaryDate` date NOT NULL,
    `SalaryMonth` int DEFAULT '0',
    `SalaryYear` int DEFAULT '0',
    `TotalDays` int DEFAULT '0',
    `WorkingDays` int DEFAULT '0',
    `PaidLeave` int DEFAULT '0',
    `Absent` int DEFAULT '0',
    `Present` int DEFAULT '0',
    `TotalEntryCount` int DEFAULT '0',
    `BasicSalary` float DEFAULT '0',
    `Allowances` float DEFAULT '0',
    `Deductions` float DEFAULT '0',
    `NetSalary` float DEFAULT '0',
    `Remark` varchar(100) NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`SalaryId`),
    KEY `SalaryId` (`SalaryId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 6875 DEFAULT CHARSET = latin1;

CREATE TABLE `payroll_salary_detail` (
    `SalaryDetailId` bigint NOT NULL AUTO_INCREMENT,
    `SalaryId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `CommanMasterId` bigint NOT NULL,
    `Amount` float DEFAULT '0',
    `KistId` bigint NOT NULL,
    `DetailRemark` varchar(100) NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`SalaryDetailId`),
    KEY `SalaryDetailId` (`SalaryDetailId`),
    KEY `SalaryId` (`SalaryId`),
    KEY `KistId` (`KistId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 23887 DEFAULT CHARSET = latin1;

CREATE TABLE `payroll_staff_stock` (
    `StaffStockId` bigint NOT NULL AUTO_INCREMENT,
    `LedgerId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `CommanMasterId` bigint NOT NULL,
    `Amount` float DEFAULT '0',
    `Quantity` int DEFAULT '0',
    `Brand` varchar(100) NOT NULL,
    `BillPartNo` varchar(100) NOT NULL,
    `Remark` varchar(100) NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`StaffStockId`),
    KEY `StaffStockId` (`StaffStockId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 65 DEFAULT CHARSET = latin1;

CREATE TABLE `payroll_staff_structure` (
    `StructureId` bigint NOT NULL AUTO_INCREMENT,
    `LedgerId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `CommanMasterId` bigint NOT NULL,
    `Amount` float DEFAULT '0',
    `AmountType` float DEFAULT '0',
    `Remark` varchar(100) NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`StructureId`),
    KEY `StructureId` (`StructureId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 750 DEFAULT CHARSET = latin1;

CREATE TABLE `payroll_staff_structure_default` (
    `DefaultStructureId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `RoleId` bigint NOT NULL,
    `CommanMasterId` bigint NOT NULL,
    `Amount` float DEFAULT '0',
    `AmountType` float DEFAULT '0',
    `Remark` varchar(100) NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`DefaultStructureId`),
    KEY `DefaultStructureId` (`DefaultStructureId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `RoleId` (`RoleId`)
) ENGINE = InnoDB AUTO_INCREMENT = 32 DEFAULT CHARSET = latin1;

CREATE TABLE `role` (
    `Id` bigint NOT NULL AUTO_INCREMENT,
    `RoleId` int NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `RoleName` varchar(50) NOT NULL,
    `IsTransaction` enum('1', '0') NOT NULL,
    `IsAllow` enum('1', '0') NOT NULL,
    `Hissa` float NOT NULL DEFAULT '0',
    `DaraRate` float NOT NULL DEFAULT '0',
    `DaraCommission` float NOT NULL DEFAULT '0',
    `AkharRate` float NOT NULL DEFAULT '0',
    `AkharCommission` float NOT NULL DEFAULT '0',
    `Vapsi` float NOT NULL DEFAULT '0',
    `IsDashboardReDeclare` smallint DEFAULT '0',
    `IsWebLogin` smallint DEFAULT '0',
    `IsAppLogin` smallint DEFAULT '0',
    `IsDeclareTransactionConfig` smallint DEFAULT '0',
    `Message` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '',
    `FlashMessage` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`Id`),
    KEY `Id` (`Id`)
) ENGINE = InnoDB AUTO_INCREMENT = 256 DEFAULT CHARSET = latin1;

CREATE TABLE `role_permission` (
    `RolePermissionId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `RoleId` bigint NOT NULL,
    `MenuId` bigint NOT NULL DEFAULT '0',
    `Title` varchar(50) NOT NULL,
    `Page` varchar(50) NOT NULL,
    `IsPageAllow` enum('0', '1') NOT NULL,
    `IsOption` enum('0', '1') NOT NULL,
    `Add` enum('0', '1') NOT NULL,
    `Edit` enum('0', '1') NOT NULL,
    `Delete` enum('0', '1') NOT NULL,
    `Export` enum('0', '1') NOT NULL,
    `ViewType` enum('ALL', 'SELF') NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`RolePermissionId`),
    KEY `RolePermissionId` (`RolePermissionId`),
    KEY `RoleId` (`RoleId`)
) ENGINE = InnoDB AUTO_INCREMENT = 9100 DEFAULT CHARSET = latin1;

CREATE TABLE `role_permission_denied` (
    `RolePermissionDeniedId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `RolePermissionId` bigint NOT NULL,
    `LoginId` bigint NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`RolePermissionDeniedId`),
    KEY `RolePermissionDeniedId` (`RolePermissionDeniedId`),
    KEY `RolePermissionId` (`RolePermissionId`),
    KEY `LoginId` (`LoginId`)
) ENGINE = InnoDB AUTO_INCREMENT = 530 DEFAULT CHARSET = latin1;

CREATE TABLE `role_permission_transaction` (
    `RolePermissionTransactionId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `LoginId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL,
    `ShiftDate` date NOT NULL,
    `ExpiryDateTime` datetime NOT NULL,
    `DataViewMode` smallint NOT NULL,
    `Page` varchar(50) NOT NULL,
    `IsPageAllow` enum('0', '1') NOT NULL,
    `Add` enum('0', '1') NOT NULL,
    `Edit` enum('0', '1') NOT NULL,
    `Delete` enum('0', '1') NOT NULL,
    `Export` enum('0', '1') NOT NULL,
    `ViewType` enum('0', '1') NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`RolePermissionTransactionId`),
    KEY `RolePermissionTransactionId` (`RolePermissionTransactionId`),
    KEY `ShiftId` (`ShiftId`),
    KEY `LoginId` (`LoginId`)
) ENGINE = InnoDB AUTO_INCREMENT = 598 DEFAULT CHARSET = latin1;

CREATE TABLE `shift` (
    `ShiftId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `ShiftName` varchar(50) NOT NULL,
    `ShiftDate` date NOT NULL,
    `ShiftNextDay` enum('No', 'Yes') NOT NULL,
    `ShiftFor` enum('BOTH', 'WEB', 'APP') NOT NULL,
    `ShiftOrder` bigint NOT NULL DEFAULT '0',
    `DaraRate` float NOT NULL DEFAULT '0',
    `DaraCommission` float NOT NULL DEFAULT '0',
    `AkharRate` float NOT NULL DEFAULT '0',
    `AkharCommission` float NOT NULL DEFAULT '0',
    `Tax` float NOT NULL DEFAULT '0',
    `IsTransToCompany` int DEFAULT '0',
    `CompanyApiUrl` varchar(200) DEFAULT '',
    `CompanyUserName` varchar(200) DEFAULT '',
    `CompanyPassword` varchar(200) DEFAULT '',
    `CompanyShiftId` bigint DEFAULT '0',
    `ApiTimeRebateForTransaction` varchar(30) DEFAULT '0',
    `MainJantriTime` varchar(30) DEFAULT '0',
    `IsActive` enum('1', '0') NOT NULL,
    `IsTransactionCapping` smallint DEFAULT '0',
    `RoundOffOnCollection` smallint DEFAULT '0',
    `IsLagaiTransactionExist` smallint DEFAULT '0',
    `IsCreateVapsi` smallint DEFAULT '1',
    `IsApplyShiftConfigOnTransaction` int DEFAULT '0',
    `ResultWebShiftId` int DEFAULT '0',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`ShiftId`),
    KEY `ShiftId` (`ShiftId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 124 DEFAULT CHARSET = latin1;

CREATE TABLE `shift_company_ledger` (
    `CompanyLedgerId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL,
    `Username` varchar(50) NOT NULL,
    `Password` varchar(200) NOT NULL,
    `DaraRate` float NOT NULL,
    `DaraCommission` float NOT NULL,
    `AkharRate` float NOT NULL,
    `AkharCommission` float NOT NULL,
    `Tax` float NOT NULL,
    `Remark` varchar(200) NOT NULL,
    `IsAllow` smallint DEFAULT '0',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`CompanyLedgerId`),
    KEY `CompanyLedgerId` (`CompanyLedgerId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `ShiftId` (`ShiftId`)
) ENGINE = InnoDB AUTO_INCREMENT = 63 DEFAULT CHARSET = latin1;

CREATE TABLE `shift_timing` (
    `ShiftTimeId` bigint NOT NULL AUTO_INCREMENT,
    `ShiftId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `RoleId` bigint NOT NULL,
    `EndTime` varchar(50) NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`ShiftTimeId`),
    KEY `ShiftTimeId` (`ShiftTimeId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 1026 DEFAULT CHARSET = latin1;

CREATE TABLE `sys_access_block` (
    `AccessBlockId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `LoginId` bigint NOT NULL,
    `IP` varchar(100) NOT NULL,
    `Attempt` int NOT NULL,
    `Remark` text,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`AccessBlockId`),
    KEY `AccessBlockId` (`AccessBlockId`),
    KEY `LoginId` (`LoginId`)
) ENGINE = InnoDB AUTO_INCREMENT = 790 DEFAULT CHARSET = latin1;

CREATE TABLE `sys_flash_message_logs` (
    `LogId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `RoleId` int NOT NULL,
    `LoginId` bigint NOT NULL,
    `Logs` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '',
    `IsExpire` int NOT NULL DEFAULT '0',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`LogId`),
    KEY `LogId` (`LogId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `RoleId` (`RoleId`),
    KEY `LoginId` (`LoginId`)
) ENGINE = InnoDB AUTO_INCREMENT = 1158 DEFAULT CHARSET = latin1;

CREATE TABLE `sys_ip_logs` (
    `LogId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `LoginId` bigint NOT NULL,
    `Type` varchar(100) NOT NULL,
    `SubType` varchar(100) NOT NULL,
    `FieldName` varchar(50) NOT NULL,
    `FieldValue` bigint NOT NULL,
    `DeviceType` int NOT NULL,
    `Ip` varchar(100) NOT NULL,
    `LatLong` varchar(100) NOT NULL,
    `Location` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `Info` text,
    `Logs` text,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`LogId`),
    KEY `LogId` (`LogId`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `sys_logs` (
    `LogId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `LoginId` bigint NOT NULL,
    `Logs` text NOT NULL,
    `TableName` varchar(50) NOT NULL,
    `FieldName` varchar(50) NOT NULL,
    `FieldValue` bigint NOT NULL,
    `OldJson` text,
    `NewJson` text,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`LogId`),
    KEY `LogId` (`LogId`)
) ENGINE = InnoDB AUTO_INCREMENT = 11015018 DEFAULT CHARSET = latin1;

CREATE TABLE `sys_menu` (
    `MenuId` bigint NOT NULL AUTO_INCREMENT,
    `Menu` varchar(50) NOT NULL,
    `Order` bigint NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`MenuId`),
    KEY `MenuId` (`MenuId`)
) ENGINE = InnoDB AUTO_INCREMENT = 13 DEFAULT CHARSET = latin1;

CREATE TABLE `sys_options` (
    `OptionId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `Slug` varchar(50) NOT NULL,
    `Value` text,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`OptionId`),
    KEY `OptionId` (`OptionId`),
    KEY `OrganizationId` (`OrganizationId`)
) ENGINE = InnoDB AUTO_INCREMENT = 20 DEFAULT CHARSET = latin1;

CREATE TABLE `sys_role` (
    `RoleId` int NOT NULL AUTO_INCREMENT,
    `RoleName` varchar(50) NOT NULL,
    `IsTransaction` enum('1', '0') NOT NULL,
    `IsAllow` enum('1', '0') NOT NULL,
    `Hissa` float NOT NULL DEFAULT '0',
    `DaraRate` float NOT NULL DEFAULT '0',
    `DaraCommission` float NOT NULL DEFAULT '0',
    `AkharRate` float NOT NULL DEFAULT '0',
    `AkharCommission` float NOT NULL DEFAULT '0',
    `Vapsi` float NOT NULL DEFAULT '0',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`RoleId`),
    KEY `RoleId` (`RoleId`)
) ENGINE = InnoDB AUTO_INCREMENT = 13 DEFAULT CHARSET = latin1;

CREATE TABLE `sys_role_permission` (
    `RolePermissionId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `RoleId` bigint NOT NULL,
    `MenuId` bigint NOT NULL DEFAULT '0',
    `Title` varchar(50) NOT NULL,
    `Page` varchar(50) NOT NULL,
    `IsPageAllow` enum('0', '1') NOT NULL,
    `IsOption` enum('0', '1') NOT NULL,
    `Add` enum('0', '1') NOT NULL,
    `Edit` enum('0', '1') NOT NULL,
    `Delete` enum('0', '1') NOT NULL,
    `Export` enum('0', '1') NOT NULL,
    `ViewType` enum('ALL', 'SELF') NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(50) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(50) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`RolePermissionId`),
    KEY `RolePermissionId` (`RolePermissionId`),
    KEY `RoleId` (`RoleId`)
) ENGINE = InnoDB AUTO_INCREMENT = 1793 DEFAULT CHARSET = latin1;

CREATE TABLE `TEMP` (
    `TransactionDetailId` bigint unsigned NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `third_party_commission` (
    `CommissionId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `CommissionLedgerId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `CommissionDara` float NOT NULL,
    `CommissionAkhar` float NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`CommissionId`),
    KEY `CommissionId` (`CommissionId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `CommissionLedgerId` (`CommissionLedgerId`)
) ENGINE = InnoDB AUTO_INCREMENT = 1846 DEFAULT CHARSET = latin1;

CREATE TABLE `third_party_vapsi` (
    `VapsiId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `VapsiLedgerId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `Vapsi` float NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`VapsiId`),
    KEY `VapsiId` (`VapsiId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `VapsiLedgerId` (`VapsiLedgerId`)
) ENGINE = InnoDB AUTO_INCREMENT = 7225 DEFAULT CHARSET = latin1;

CREATE TABLE `toppers_losser` (
    `NumberCount` bigint DEFAULT NULL,
    `TotalAmount` float DEFAULT NULL,
    `AddedBy` varchar(50) DEFAULT NULL,
    `Mobile` varchar(50) DEFAULT NULL,
    `Address` varchar(200) DEFAULT NULL,
    `LoginStatus` int DEFAULT NULL,
    `LoginName` varchar(100) DEFAULT NULL,
    `LoginType` int DEFAULT NULL,
    `RoleId` int DEFAULT NULL,
    `RoleName` varchar(50) DEFAULT NULL,
    `TopFlag` int DEFAULT NULL,
    `NumberCountOrder` bigint DEFAULT NULL,
    `OrganizationId` bigint DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `transaction` (
    `TransactionId` bigint unsigned NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `TransactionDate` date NOT NULL,
    `TransactionMode` smallint NOT NULL,
    `TransactionType` enum('J', 'U') NOT NULL,
    `KFlag` enum('False', 'True') NOT NULL,
    `EntryType` enum('Main', 'Sub') NOT NULL,
    `ClientRemarks` varchar(50) NOT NULL,
    `IsHissa` enum('True', 'False') NOT NULL,
    `SelfHissa` float NOT NULL DEFAULT '0',
    `OtherHissa` float NOT NULL DEFAULT '0',
    `DaraRate` float NOT NULL,
    `DaraCommission` float NOT NULL,
    `AkharRate` float NOT NULL,
    `AkharCommission` float NOT NULL,
    `Tax` float NOT NULL DEFAULT '0',
    `TotalAmount` float NOT NULL,
    `TotalCommission` float NOT NULL,
    `TotalTax` float NOT NULL DEFAULT '0',
    `FinalAmount` float NOT NULL,
    `TransactionStartTime` datetime NOT NULL,
    `DeviceType` enum('WEB', 'APP') NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`TransactionId`),
    KEY `TransactionDate` (`TransactionDate`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `ShiftId` (`ShiftId`),
    KEY `transaction_TransactionId` (`TransactionId`),
    KEY `transaction_RecordStatus` (`RecordStatus`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `transaction_audit` (
    `TransactionAuditId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `TransactionId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL,
    `ShiftDate` date DEFAULT NULL,
    `LedgerId` bigint NOT NULL,
    `Amount` float NOT NULL,
    `AmountUpdated` float NOT NULL,
    `MistakeStatus` smallint NOT NULL,
    `ModifyStatus` smallint NOT NULL,
    `LastStatus` smallint NOT NULL,
    `Remark` text NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`TransactionAuditId`),
    KEY `TransactionId` (`TransactionId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `ShiftDate` (`ShiftDate`)
) ENGINE = InnoDB AUTO_INCREMENT = 15798840 DEFAULT CHARSET = latin1;

CREATE TABLE `transaction_declare` (
    `TransactionId` bigint unsigned NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `TransactionDate` date NOT NULL,
    `TransactionMode` smallint NOT NULL,
    `TransactionType` enum('J', 'U') NOT NULL,
    `KFlag` enum('False', 'True') NOT NULL,
    `EntryType` enum('Main', 'Sub') NOT NULL,
    `ClientRemarks` varchar(50) NOT NULL,
    `IsHissa` enum('True', 'False') NOT NULL,
    `SelfHissa` float NOT NULL DEFAULT '0',
    `OtherHissa` float NOT NULL DEFAULT '0',
    `DaraRate` float NOT NULL,
    `DaraCommission` float NOT NULL,
    `AkharRate` float NOT NULL,
    `AkharCommission` float NOT NULL,
    `Tax` float NOT NULL DEFAULT '0',
    `TotalAmount` float NOT NULL,
    `TotalCommission` float NOT NULL,
    `TotalTax` float NOT NULL DEFAULT '0',
    `FinalAmount` float NOT NULL,
    `TransactionStartTime` datetime NOT NULL,
    `DeviceType` enum('WEB', 'APP') NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`TransactionId`),
    KEY `TransactionDate` (`TransactionDate`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `ShiftId` (`ShiftId`),
    KEY `transaction_declare_TransactionId` (`TransactionId`),
    KEY `transaction_declare_RecordStatus` (`RecordStatus`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `transaction_detail` (
    `TransactionDetailId` bigint unsigned NOT NULL,
    `TransactionId` bigint unsigned NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `NumberType` int NOT NULL,
    `Number` varchar(4) NOT NULL,
    `Amount` float NOT NULL,
    `Rate` float NOT NULL,
    `Commission` float NOT NULL,
    `Tax` float NOT NULL DEFAULT '0',
    `FinalAmount` float NOT NULL,
    `OrderNumber` int NOT NULL,
    `UpdateLimitFlag` int DEFAULT '0',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`TransactionDetailId`),
    KEY `TransactionId` (`TransactionId`),
    KEY `Number` (`Number`),
    KEY `transaction_detail_RecordStatus` (`RecordStatus`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `transaction_detail_declare` (
    `TransactionDetailId` bigint unsigned NOT NULL,
    `TransactionId` bigint unsigned NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `Number` varchar(4) NOT NULL,
    `NumberType` int NOT NULL,
    `Amount` float NOT NULL,
    `Rate` float NOT NULL,
    `Commission` float NOT NULL,
    `Tax` float NOT NULL DEFAULT '0',
    `FinalAmount` float NOT NULL,
    `OrderNumber` int NOT NULL,
    `UpdateLimitFlag` int DEFAULT '0',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`TransactionDetailId`),
    KEY `TransactionId` (`TransactionId`),
    KEY `Number` (`Number`),
    KEY `transaction_detail_declare_RecordStatus` (`RecordStatus`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `transaction_narration` (
    `TransactionNarrationId` bigint unsigned NOT NULL,
    `TransactionId` bigint unsigned NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `Type` varchar(30) NOT NULL,
    `Number1` varchar(30) NOT NULL,
    `Number2` varchar(30) NOT NULL,
    `Number3` varchar(30) NOT NULL,
    `Amount` float NOT NULL,
    `Joda` enum('Yes', 'No') NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`TransactionNarrationId`),
    KEY `TransactionId` (`TransactionId`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `transaction_narration_declare` (
    `TransactionNarrationId` bigint unsigned NOT NULL,
    `TransactionId` bigint unsigned NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `Type` varchar(30) NOT NULL,
    `Number1` varchar(30) NOT NULL,
    `Number2` varchar(30) NOT NULL,
    `Number3` varchar(30) NOT NULL,
    `Amount` float NOT NULL,
    `Joda` enum('Yes', 'No') NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`TransactionNarrationId`),
    KEY `TransactionId` (`TransactionId`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `vapsi` (
    `VapsiId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint DEFAULT NULL,
    `LedgerId` bigint DEFAULT NULL,
    `ParentsLedgerId` bigint DEFAULT NULL,
    `VoucherId` bigint DEFAULT NULL,
    `VoucherDate` date NOT NULL,
    `VapsiFromDate` date DEFAULT NULL,
    `VapsiToDate` date DEFAULT NULL,
    `BaseAmount` float DEFAULT NULL,
    `VapsiPercent` float DEFAULT NULL,
    `VapsiAmount` float DEFAULT NULL,
    `VapsiOn` int DEFAULT NULL,
    `RecordStatus` char(1) DEFAULT NULL,
    `AddedBy` varchar(50) DEFAULT NULL,
    `AddedDate` datetime DEFAULT NULL,
    `UpdatedBy` varchar(50) DEFAULT NULL,
    `UpdatedDate` datetime DEFAULT NULL,
    PRIMARY KEY (`VapsiId`),
    KEY `LedgerId` (`LedgerId`)
) ENGINE = InnoDB AUTO_INCREMENT = 143484 DEFAULT CHARSET = latin1;

CREATE TABLE `voucher` (
    `VoucherId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL,
    `VoucherDate` date NOT NULL,
    `VoucherType` smallint NOT NULL,
    `Amount` float NOT NULL,
    `Remark` text NOT NULL,
    `LagaiKhai` int DEFAULT '1',
    `VoucherMode` enum('MANUAL', 'AUTO') DEFAULT 'MANUAL',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`VoucherId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `ShiftId` (`ShiftId`),
    KEY `VoucherDate` (`VoucherDate`),
    KEY `VoucherType` (`VoucherType`),
    KEY `VoucherId` (`VoucherId`),
    KEY `RecordStatus` (`RecordStatus`)
) ENGINE = InnoDB AUTO_INCREMENT = 14007668 DEFAULT CHARSET = latin1;

CREATE TABLE `voucher_audit` (
    `VoucherAuditId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `VoucherId` bigint NOT NULL,
    `LedgerId` bigint NOT NULL,
    `OppositeLedgerId` bigint NOT NULL,
    `VoucherDate` date NOT NULL,
    `VoucherType` smallint NOT NULL,
    `Amount` float NOT NULL,
    `AmountType` enum('Dr', 'Cr') NOT NULL,
    `Remark` text NOT NULL,
    `AuditType` smallint NOT NULL,
    `AuditStatus` smallint NOT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`VoucherAuditId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `VoucherId` (`VoucherId`),
    KEY `VoucherDate` (`VoucherDate`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OppositeLedgerId` (`OppositeLedgerId`)
) ENGINE = InnoDB AUTO_INCREMENT = 125200 DEFAULT CHARSET = latin1;

CREATE TABLE `voucher_detail` (
    `VoucherDetailId` bigint NOT NULL AUTO_INCREMENT,
    `OrganizationId` bigint NOT NULL,
    `VoucherId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL DEFAULT '0',
    `LedgerId` bigint NOT NULL,
    `OppositeLedgerId` bigint NOT NULL,
    `FromLedgerId` bigint DEFAULT '0',
    `VoucherType` int DEFAULT NULL,
    `VoucherDetailType` smallint NOT NULL,
    `VoucherDate` date NOT NULL,
    `Amount` float NOT NULL,
    `AmountType` enum('Dr', 'Cr') NOT NULL,
    `OpenAmount` bigint DEFAULT '0',
    `SelfHissa` float NOT NULL DEFAULT '0',
    `OtherHissa` float NOT NULL DEFAULT '0',
    `Flag1` varchar(50) NOT NULL,
    `Remark` varchar(200) NOT NULL,
    `MondayFinalFlag` enum('True', 'False') NOT NULL,
    `VoucherMode` enum('MANUAL', 'AUTO') DEFAULT 'MANUAL',
    `VerifyBy` varchar(30) DEFAULT NULL,
    `VerifyDate` datetime DEFAULT NULL,
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`VoucherDetailId`),
    KEY `VoucherId` (`VoucherId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OppositeLedgerId` (`OppositeLedgerId`),
    KEY `AmountType` (`AmountType`),
    KEY `VoucherDetailType` (`VoucherDetailType`),
    KEY `RecordStatus` (`RecordStatus`),
    KEY `ShiftId` (`ShiftId`),
    KEY `VoucherDate` (`VoucherDate`)
) ENGINE = InnoDB AUTO_INCREMENT = 918278344 DEFAULT CHARSET = latin1;

CREATE TABLE `voucher_detail_dump` (
    `VoucherDetailId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `VoucherId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL DEFAULT '0',
    `LedgerId` bigint NOT NULL,
    `OppositeLedgerId` bigint NOT NULL,
    `FromLedgerId` bigint DEFAULT '0',
    `VoucherType` int DEFAULT NULL,
    `VoucherDetailType` smallint NOT NULL,
    `VoucherDate` date NOT NULL,
    `Amount` float NOT NULL,
    `AmountType` enum('Dr', 'Cr') NOT NULL,
    `OpenAmount` bigint DEFAULT '0',
    `SelfHissa` float NOT NULL DEFAULT '0',
    `OtherHissa` float NOT NULL DEFAULT '0',
    `Flag1` varchar(50) NOT NULL,
    `Remark` varchar(200) NOT NULL,
    `MondayFinalFlag` enum('True', 'False') NOT NULL,
    `VoucherMode` enum('MANUAL', 'AUTO') DEFAULT 'MANUAL',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`VoucherDetailId`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `voucher_detail_first` (
    `VoucherDetailId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `VoucherId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL DEFAULT '0',
    `LedgerId` bigint NOT NULL,
    `OppositeLedgerId` bigint NOT NULL,
    `FromLedgerId` bigint DEFAULT '0',
    `VoucherType` int DEFAULT NULL,
    `VoucherDetailType` smallint NOT NULL,
    `VoucherDate` date NOT NULL,
    `Amount` float NOT NULL,
    `AmountType` enum('Dr', 'Cr') NOT NULL,
    `OpenAmount` bigint DEFAULT '0',
    `SelfHissa` float NOT NULL DEFAULT '0',
    `OtherHissa` float NOT NULL DEFAULT '0',
    `Flag1` varchar(50) NOT NULL,
    `Remark` varchar(200) NOT NULL,
    `MondayFinalFlag` enum('True', 'False') NOT NULL,
    `VoucherMode` enum('MANUAL', 'AUTO') DEFAULT 'MANUAL',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`VoucherDetailId`),
    KEY `VoucherId` (`VoucherId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `VoucherDetailType` (`VoucherDetailType`),
    KEY `RecordStatus` (`RecordStatus`),
    KEY `ShiftId` (`ShiftId`),
    KEY `VoucherDate` (`VoucherDate`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `voucher_detail_tmp` (
    `VoucherDetailId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `VoucherId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL DEFAULT '0',
    `LedgerId` bigint NOT NULL,
    `OppositeLedgerId` bigint NOT NULL,
    `FromLedgerId` bigint DEFAULT '0',
    `VoucherType` int DEFAULT NULL,
    `VoucherDetailType` smallint NOT NULL,
    `VoucherDate` date NOT NULL,
    `Amount` float NOT NULL,
    `AmountType` enum('Dr', 'Cr') NOT NULL,
    `OpenAmount` bigint DEFAULT '0',
    `SelfHissa` float NOT NULL DEFAULT '0',
    `OtherHissa` float NOT NULL DEFAULT '0',
    `Flag1` varchar(50) NOT NULL,
    `Remark` varchar(200) NOT NULL,
    `MondayFinalFlag` enum('True', 'False') NOT NULL,
    `VoucherMode` enum('MANUAL', 'AUTO') DEFAULT 'MANUAL',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`VoucherDetailId`),
    KEY `VoucherId` (`VoucherId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `LedgerId` (`LedgerId`),
    KEY `OppositeLedgerId` (`OppositeLedgerId`),
    KEY `AmountType` (`AmountType`),
    KEY `VoucherDetailType` (`VoucherDetailType`),
    KEY `RecordStatus` (`RecordStatus`),
    KEY `ShiftId` (`ShiftId`),
    KEY `VoucherDate` (`VoucherDate`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `voucher_dump` (
    `VoucherId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL,
    `VoucherDate` date NOT NULL,
    `VoucherType` smallint NOT NULL,
    `Amount` float NOT NULL,
    `Remark` text NOT NULL,
    `LagaiKhai` int DEFAULT '1',
    `VoucherMode` enum('MANUAL', 'AUTO') DEFAULT 'MANUAL',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`VoucherId`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `voucher_first` (
    `VoucherId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL,
    `VoucherDate` date NOT NULL,
    `VoucherType` smallint NOT NULL,
    `Amount` float NOT NULL,
    `Remark` text NOT NULL,
    `LagaiKhai` int DEFAULT '1',
    `VoucherMode` enum('MANUAL', 'AUTO') DEFAULT 'MANUAL',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`VoucherId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `ShiftId` (`ShiftId`),
    KEY `VoucherDate` (`VoucherDate`),
    KEY `VoucherType` (`VoucherType`),
    KEY `VoucherId` (`VoucherId`),
    KEY `RecordStatus` (`RecordStatus`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

CREATE TABLE `voucher_tmp` (
    `VoucherId` bigint NOT NULL,
    `OrganizationId` bigint NOT NULL,
    `ShiftId` bigint NOT NULL,
    `VoucherDate` date NOT NULL,
    `VoucherType` smallint NOT NULL,
    `Amount` float NOT NULL,
    `Remark` text NOT NULL,
    `LagaiKhai` int DEFAULT '1',
    `VoucherMode` enum('MANUAL', 'AUTO') DEFAULT 'MANUAL',
    `RecordStatus` char(1) NOT NULL,
    `AddedBy` varchar(30) NOT NULL,
    `AddedDate` datetime NOT NULL,
    `UpdatedBy` varchar(30) NOT NULL,
    `UpdatedDate` datetime NOT NULL,
    PRIMARY KEY (`VoucherId`),
    KEY `OrganizationId` (`OrganizationId`),
    KEY `ShiftId` (`ShiftId`),
    KEY `VoucherDate` (`VoucherDate`),
    KEY `VoucherType` (`VoucherType`),
    KEY `VoucherId` (`VoucherId`),
    KEY `RecordStatus` (`RecordStatus`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `auto_hp_create`(
	IN varOrganizationId bigint,
	IN varFromDate DATE,
	IN varToDate DATE,
	IN varTransactionDate DATE,
	IN varToLedgerIds bigint,
	IN varLoginUserName varchar(50)      
)
begin
/*
other variables 
in varOrganizationId bigint(21)
,in varLedgerId bigint
,in varHPLedgerId bigint
,in varTransactionDate DATE
,in varFromDate DATE
,in varToDate DATE
,in varHPBaseAmount float 
,in varAmount float
,in varHPPercent float
,in varLoginUserName varchar(50)      
*/

declare varHPFromDate date;
declare varHPBaseAmount float;
declare varAmount float;
declare varHPPercent float;
declare varHPLedgerId bigint ;

declare VoucherId BIGINT default 0;

declare varVoucherType smallint default 5;
declare varOppositLedgerId smallint default 11;
declare varShiftId smallint default 0;

declare varLedgerId int default 0;

DECLARE finished INTEGER DEFAULT 0;
DEClARE curLedger 
		CURSOR FOR 

	SELECT DISTINCT l.LedgerId
	,ifnull(vd.FromDate,ifnull(vd.FromDate,FromDate)) as FromDate
	,hissa.Hissa
	,ifnull(l.HPLedgerId,0) as HPLedgerId 
	,ifnull(sum(ProfitAndLoss),0) ProfitAndLoss
	,(ifnull(sum(ProfitAndLoss) ,0) * ifnull(hissa.Hissa,0) )/100 as HPAmount 
	/*
	,ifnull((vdWorking.WorkingDays),0) WorkingDays
	*/
	from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.HPLedgerId,ledger.AgentLedgerId
		from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
		and (varToLedgerIds = 0 or ifnull(ledger.HPLedgerId,0) = varToLedgerIds)
		and ledger.OrganizationId = varOrganizationId
		) as l 
	join hissa on hissa.LedgerId = l.LedgerId and hissa.HissaLedgerId = 11	and hissa.RecordStatus != 'D' and ifnull(hissa.Hissa,0) != 0
	left join ledger as hpHissaTo on hpHissaTo.ledgerId = l.HPLedgerId
	left JOIN (select
		vd.LedgerId,varFromDate FromDate,
		sum(IF(vd.ShiftId != 0,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) ProfitAndLoss
		from voucher_detail as vd
/*		left join (select hp_hissa.LedgerId,max(DATE_ADD(hp_hissa.HPToDate, INTERVAL 1 DAY)) as FromDate from hp_hissa where hp_hissa.RecordStatus != 'D'
		group by LedgerId) as hp_hissa on hp_hissa.LedgerId = vd.LedgerId 
*/
		where vd.VoucherDate between varFromDate and varToDate
		#and varFromDate not in (select HPFromDate from hp_hissa where hp_hissa.RecordStatus != 'D' and hp_hissa.LedgerId = vd.LedgerId)
		and vd.LedgerId not in (select hp_hissa.LedgerId from hp_hissa where hp_hissa.RecordStatus != 'D' and hp_hissa.HPFromDate = varFromDate)

		and (vd.RecordStatus!='D') 
		group by vd.LedgerId 
		) as vd on vd.LedgerId = l.LedgerId   
	/*
	left join (
		select LedgerId,count(WorkingDays) as WorkingDays
			from
			(
			select		
			vd.LedgerId,count(1) WorkingDays
			from voucher_detail as vd
			left join (select hp_hissa.LedgerId,max(DATE_ADD(hp_hissa.HPToDate, INTERVAL 1 DAY)) as FromDate from hp_hissa where hp_hissa.RecordStatus != 'D'
				group by LedgerId) as hp_hissa on hp_hissa.LedgerId = vd.LedgerId
			where vd.VoucherDate between ifnull(hp_hissa.FromDate,varFromDate) and varToDate
			and (vd.RecordStatus!='D') 
			and vd.VoucherType in (22,23,24)
			group by vd.LedgerId,vd.VoucherDate
			) as vd 
			group by LedgerId
		) as vdWorking on vdWorking.LedgerId = l.LedgerId   
    */
	GROUP BY l.LedgerId,l.LedgerName,hissa.Hissa
	,vd.FromDate,l.AddedDate
	,ifnull(l.HPLedgerId,0)  
	,ifnull(hpHissaTo.LedgerName,'') 
	having ifnull(sum(ProfitAndLoss),0) != 0
    Order By l.LedgerName;


DECLARE CONTINUE HANDLER 
FOR NOT FOUND SET finished = 1;
			
	set varVoucherType = 5;
	set varOppositLedgerId = 11;
	set varShiftId = 0;

OPEN curLedger;
		
getLedger: LOOP
		FETCH curLedger INTO varLedgerId,varHPFromDate,varHPPercent,varHPLedgerId,varHPBaseAmount,varAmount;
		IF finished = 1 THEN 
			LEAVE getLedger;
		END IF;
		

		/*      Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_HP',0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
		;
			
  
		set VoucherId = LAST_INSERT_ID();

		/* HP to party */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varHPLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,(case when varAmount > 0 then varAmount else -varAmount end)
		,(case when varAmount > 0 then 'Cr' else 'Dr' end)
		,varOppositLedgerId
		,varLedgerId,(select max(LedgerName) from ledger where LedgerId = varLedgerId),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
		;
		

		/* HP from HP Account */
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varOppositLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,(case when varAmount > 0 then varAmount else -varAmount end)
		,(case when varAmount > 0 then 'Dr' else 'Cr' end)
		,varHPLedgerId
		,varLedgerId,(select max(LedgerName) from ledger where LedgerId = varLedgerId),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
		)
        ;

		/*      HP Table Entry */

		INSERT INTO hp_hissa
		(
		OrganizationId,
		LedgerId,
		HPLedgerId,
		VoucherId,
		VoucherDate,
		HPFromDate,
		HPToDate,
		BaseAmount,
		HPPercent,
		HPAmount,
		RecordStatus,
		AddedBy,
		AddedDate,
		UpdatedBy,
		UpdatedDate)
		VALUES
		(
		varOrganizationId,
		varLedgerId,
		varHPLedgerId,
		VoucherId,
		varTransactionDate,
		varFromDate,
		varToDate,
		varHPBaseAmount,
		varHPPercent,
		varAmount,
		'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP());


	END LOOP getLedger;
	CLOSE curLedger;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `auto_hp_vapsi_settelment_create`(
	IN varOrganizationId bigint,
	IN varFromDate DATE,
	IN varToDate DATE,
	IN varTransactionDate DATE,
	IN varToLedgerIds bigint,
	IN varLoginUserName varchar(50)      
)
begin
call auto_vapsi_create(varOrganizationId,varFromDate,varToDate,varTransactionDate,varToLedgerIds,varLoginUserName);
call auto_hp_create(varOrganizationId,varFromDate,varToDate,varTransactionDate,varToLedgerIds,varLoginUserName);
call auto_settelment_create(varOrganizationId,varFromDate,varToDate,varTransactionDate,varToLedgerIds,varLoginUserName);
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `auto_limit_add`(
in varOrganizationId bigint(21)
,in varTransactionDate DATE
,in varAmount float
)
begin

declare VoucherId BIGINT default 0;

declare varLimitType smallint default 2;
declare varLimitId smallint default 6;
declare varShiftId smallint default 0;

declare varLedgerId int default 0;

DECLARE finished INTEGER DEFAULT 0;
DEClARE curLedger 
		CURSOR FOR 
			SELECT LedgerId FROM ledger where GroupId = 5
			and OrganizationId = varOrganizationId
			and AccountStatus = 1
			and IsHide = '0'
			and RecordStatus = 'A';

DECLARE CONTINUE HANDLER 
FOR NOT FOUND SET finished = 1;
			
	set varLimitType = 2;
	set varLimitId = 6;
	set varShiftId = 0;

OPEN curLedger;
		
getLedger: LOOP
		FETCH curLedger INTO varLedgerId;
		IF finished = 1 THEN 
			LEAVE getLedger;
		END IF;
		
		/*     Sale Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varLimitType,'AUTO',varAmount,'FIRST_LIMIT',0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
  
		set VoucherId = LAST_INSERT_ID();


		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varLedgerId
		,0,varShiftId
		,varTransactionDate
		,varLimitType
		,varAmount
		,'Dr'
		,varLimitId
		,'','FIRST_LIMIT',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varLimitId
		,0,varShiftId
		,varTransactionDate
		,varLimitType
		,varAmount
		,'Cr'
		,varLedgerId
		,'','FIRST_LIMIT',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;


	END LOOP getLedger;
	CLOSE curLedger;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `auto_limit_close`(
	IN varOrganizationId bigint,
	IN varTransactionDate DATE,
	IN varLoginUserName varchar(50)
)
begin

declare varAmount float;

declare VoucherId BIGINT default 0;

declare varVoucherType smallint default 2;
declare varOppositLedgerId smallint default 6;
declare varShiftId smallint default 0;

declare varLedgerId int default 0;

DECLARE finished INTEGER DEFAULT 0;
DEClARE curLedger 
		CURSOR FOR 

	select l.LedgerId ,OPBal.opening
	from (select ledger.LedgerId,ledger.LedgerName
	from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
	and ifnull(ledger.ParentLedgerId,0) = 0
	and ledger.OrganizationId = 1001) as l
	left join (
				select t.LedgerId
					from (select t.LedgerId FROM transaction_declare t 
						where t.TransactionDate between DATE_ADD(varTransactionDate,INTERVAL -7 DAY) and varTransactionDate
                        and t.RecordStatus != 'D' 
					union all
					select t.LedgerId FROM transaction t 
						where t.TransactionDate between DATE_ADD(varTransactionDate,INTERVAL -7 DAY) and varTransactionDate
                        and t.RecordStatus != 'D'
					) as t	
				group by t.LedgerId
				) as t on t.LedgerId = l.LedgerId
	inner JOIN (Select LedgerId
				,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
				from voucher_detail aa
						Where aa.VoucherType = 2
						and aa.RecordStatus != 'D' 
						and aa.OrganizationId = varOrganizationId
						group by aa.LedgerId 
			) as OPBal on OPBal.LedgerId = l.LedgerId 
	where t.LedgerId is null
	and OPBal.opening > 0 						
	order by l.LedgerName
	;


DECLARE CONTINUE HANDLER 
FOR NOT FOUND SET finished = 1;
			
	set varVoucherType = 2;
	set varOppositLedgerId = 6;
	set varShiftId = 0;

OPEN curLedger;
getLedger: LOOP
		FETCH curLedger INTO varLedgerId,varAmount;
		IF finished = 1 THEN 
			LEAVE getLedger;
		END IF;
		
		
		/*      Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_LIMIT_REV',0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
		;
			
  
		set VoucherId = LAST_INSERT_ID();

		/* Limit to party */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,varAmount 
		,'Cr'
		,varOppositLedgerId
		,0,'AUTO_LIMIT_REV',0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
		;
		

		/* party to HP  */
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varOppositLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,varAmount
		,'Dr'
		,varLedgerId
		,0,'AUTO_LIMIT_REV',0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
		)
        ;
		update ledger set IsRisky = 1 where LedgerId  = varLedgerId
        ;
	END LOOP getLedger;
	CLOSE curLedger;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `auto_set_limit_by_transaction`(
	IN varOrganizationId bigint,
	IN varTransactionDate DATE,
	IN varLimitMultipule int,
	IN varForDayas int
)
begin
	
	declare varLoginUserName varchar(50);
	DECLARE finishedorganization INTEGER DEFAULT 0;
	DEClARE curorganization 
		CURSOR FOR 
		select OrganizationId,AbsentLedgerLockDays from organization 
		where (ifnull(OrganizationId,0) = varOrganizationId or ifnull(varOrganizationId,0) = 0 ) 
		and AbsentLedgerLockDays > 0
		and RecordStatus != 'D'
	;
	
	DECLARE CONTINUE HANDLER 
	FOR NOT FOUND SET finishedorganization = 1;

	OPEN curorganization;
			
	getOrganization: LOOP

		FETCH curorganization INTO varOrganizationId,varForDayas;
		IF finishedorganization = 1 THEN 
			LEAVE getOrganization;
		END IF;
		if varLimitMultipule < 1 then
			set varLimitMultipule = 1;
		end if;

		
		begin
		
			declare varAmount float;

			declare VoucherId BIGINT default 0;

			declare varVoucherType smallint default 2;
			declare varOppositLedgerId smallint default 6;
			declare varShiftId smallint default 0;

			declare varLedgerId int default 0;

			DECLARE finished INTEGER DEFAULT 0;
			DEClARE curLedger 
					CURSOR FOR 

				select transaction_declare.LedgerId
					,(ifnull(opening,0) - ifnull(TotalAmount,0) * varLimitMultipule ) as  opening
				from
				(
					select LedgerId
						,(round(avg(TotalAmount),-2))TotalAmount
					from (
						select LedgerId,TransactionDate,sum((TotalAmount)) as TotalAmount
						from  transaction_declare
						where OrganizationId = varOrganizationId
						and  RecordStatus <> 'D'
						and TransactionDate > '2024/11/30'
						group by LedgerId,TransactionDate
					) as transaction_declare
					group by LedgerId
				)as transaction_declare  
				inner JOIN (Select LedgerId
							,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
							from voucher_detail aa
									Where aa.VoucherType = 2
									and aa.RecordStatus != 'D' 
									and aa.OrganizationId = varOrganizationId
									group by aa.LedgerId 
						) as OPBal on OPBal.LedgerId = transaction_declare.LedgerId 
				left join  ledger on ledger.LedgerId=transaction_declare.LedgerId                        
				where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
					and ifnull(ledger.ParentLedgerId,0) = 0
					and (ifnull(opening,0) - ifnull(TotalAmount,0) * varLimitMultipule) > 0
				;


			DECLARE CONTINUE HANDLER 
			FOR NOT FOUND SET finished = 1;
						
			set varVoucherType = 2;
			set varOppositLedgerId = 6;
			set varShiftId = 0;
			set varLoginUserName = 'SYSTEM';
			
			OPEN curLedger;
			getLedger: LOOP
					FETCH curLedger INTO varLedgerId,varAmount;
					IF finished = 1 THEN 
						LEAVE getLedger;
					END IF;
					
					if varAmount > 0 then
						/*      Voucher */
						
						insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
						,Amount,Remark,LagaiKhai
						,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
						values(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_SET_REMOVE_LIMIT',0
						,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
						;
							
				  
						set VoucherId = LAST_INSERT_ID();

						/* Limit to party */
						insert into voucher_detail(OrganizationId,
						VoucherId
						,LedgerId
						,VoucherDetailType,ShiftId
						,VoucherDate
						,VoucherType
						,Amount
						,AmountType
						,OppositeLedgerId
						,Flag1
						,Remark,SelfHissa,OtherHissa
						,MondayFinalFlag,VoucherMode,FromLedgerId
						,OpenAmount
						,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
						)
						values(varOrganizationId,VoucherId
						,varLedgerId
						,0,varShiftId
						,varTransactionDate
						,varVoucherType
						,varAmount 
						,'Cr'
						,varOppositLedgerId
						,0,'AUTO_SET_REMOVE_LIMIT',0,0
						,'False','AUTO',0
						,0
						,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
						;
						
						/* party to Limit  */

						
						insert into voucher_detail(OrganizationId,
						VoucherId
						,LedgerId
						,VoucherDetailType,ShiftId
						,VoucherDate
						,VoucherType
						,Amount
						,AmountType
						,OppositeLedgerId
						,Flag1
						,Remark,SelfHissa,OtherHissa
						,MondayFinalFlag,VoucherMode,FromLedgerId
						,OpenAmount
						,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
						)
						values(varOrganizationId,VoucherId
						,varOppositLedgerId
						,0,varShiftId
						,varTransactionDate
						,varVoucherType
						,varAmount
						,'Dr'
						,varLedgerId
						,0,'AUTO_SET_REMOVE_LIMIT',0,0
						,'False','AUTO',0
						,0
						,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
						)
						;
					end if;
/*
					update ledger set TransactionLock = 1 where LedgerId  = varLedgerId
					;
*/					
				END LOOP getLedger;
				CLOSE curLedger;
		
		end;


	END LOOP getorganization;
	CLOSE curorganization;
	

	select 1 Flag;

	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `auto_settelment_create`(
	IN varOrganizationId bigint,
	IN varFromDate DATE,
	IN varToDate DATE,
	IN varTransactionDate DATE,
	IN varToLedgerIds bigint,
	IN varLoginUserName varchar(50)      
)
begin

declare varAmount float;

declare VoucherId BIGINT default 0;

declare varVoucherType smallint default 1;
declare varOppositLedgerId smallint default 0;
declare varShiftId smallint default 0;

declare varLedgerId int default 0;

DECLARE finished INTEGER DEFAULT 0;
DEClARE curLedger 
		CURSOR FOR 

	SELECT DISTINCT l.LedgerId
	,(OPBal.opening) as opening,l.HPLedgerId 

	from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.HPLedgerId,ledger.AgentLedgerId
		from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
		and (varToLedgerIds = 0 or ifnull(ledger.HPLedgerId,0) = varToLedgerIds)
		and ledger.OrganizationId = varOrganizationId
		and ledger.LedgerId not in (select hp_settelment.LedgerId from hp_settelment where hp_settelment.SettelmentToDate >= varToDate and hp_settelment.RecordStatus != 'D')
		) as l 
	left JOIN (Select LedgerId
			,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
			from voucher_detail aa
					Where 
					aa.VoucherDate <= varToDate
					and aa.VoucherType != 2
					and aa.RecordStatus != 'D' 
					and aa.OrganizationId = varOrganizationId
					group by aa.LedgerId 
		) as OPBal on OPBal.LedgerId = l.LedgerId
	where ifnull(opening,0) != 0
    Order By l.LedgerId;


DECLARE CONTINUE HANDLER 
FOR NOT FOUND SET finished = 1;
			
	set varVoucherType = 1;
	set varOppositLedgerId = 0;
	set varShiftId = 0;

OPEN curLedger;
		
getLedger: LOOP
		FETCH curLedger INTO varLedgerId,varAmount,varOppositLedgerId;
		IF finished = 1 THEN 
			LEAVE getLedger;
		END IF;
		
		/*      Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_SETT',0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
		;
			
  
		set VoucherId = LAST_INSERT_ID();

		/* HP to party */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,(case when varAmount > 0 then varAmount else -varAmount end)
		,(case when varAmount > 0 then 'Cr' else 'Dr' end)
		,varOppositLedgerId
		,0,(select max(LedgerName) from ledger where LedgerId = varOppositLedgerId),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
		;
		

		/* party to HP  */
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varOppositLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,(case when varAmount > 0 then varAmount else -varAmount end)
		,(case when varAmount > 0 then 'Dr' else 'Cr' end)
		,varLedgerId
		,0,(select max(LedgerName) from ledger where LedgerId = varLedgerId),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
		)
        ;

		/*      Setttelment Table Entry */

		INSERT INTO hp_settelment
		(
		OrganizationId,
		LedgerId,
		SettelmentLedgerId,
		VoucherId,
		VoucherDate,
		SettelmentFromDate,
		SettelmentToDate,
		SettelmentAmount,
		RecordStatus,
		AddedBy,
		AddedDate,
		UpdatedBy,
		UpdatedDate)
		VALUES
		(
		varOrganizationId,
		varLedgerId,
		varToLedgerIds,
		VoucherId,
		varTransactionDate,
		varFromDate,
		varToDate,
		varAmount,
		'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP());

	END LOOP getLedger;
	CLOSE curLedger;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `auto_status_close_for_inactive`(
	IN varOrganizationId bigint,
	IN varTransactionDate DATE,
	IN varForDayas int
)
begin

	update ledger set AccountStatus = 0 
	where LedgerId in (
	select l.LedgerId 
	from (select ledger.LedgerId,ledger.LedgerName
	from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
	and ifnull(ledger.ParentLedgerId,0) = 0
	and ledger.OrganizationId = varOrganizationId) as l
	left join (
				select t.LedgerId
					from (select t.LedgerId FROM transaction_declare t 
						where t.TransactionDate between DATE_ADD(varTransactionDate,INTERVAL -varForDayas DAY) and varTransactionDate
                        and t.RecordStatus != 'D' 
					union all
					select t.LedgerId FROM transaction t 
						where t.TransactionDate between DATE_ADD(varTransactionDate,INTERVAL -varForDayas DAY) and varTransactionDate
                        and t.RecordStatus != 'D'
					) as t	
				group by t.LedgerId
				) as t on t.LedgerId = l.LedgerId
/*	inner JOIN (Select LedgerId
				,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
				from voucher_detail aa
						Where aa.VoucherType = 2
						and aa.RecordStatus != 'D' 
						and aa.OrganizationId = varOrganizationId
						group by aa.LedgerId 
			) as OPBal on OPBal.LedgerId = l.LedgerId 
*/			
	where t.LedgerId is null
	)
	and ledger.OrganizationId = varOrganizationId
	and AccountStatus = 1
	;

	update login set AccountStatus = 0 
	where LedgerId in (
	select l.LedgerId 
	from (select ledger.LedgerId,ledger.LedgerName
	from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
	and ifnull(ledger.ParentLedgerId,0) = 0
	and ledger.OrganizationId = varOrganizationId) as l
	left join (
				select t.LedgerId
					from (select t.LedgerId FROM transaction_declare t 
						where t.TransactionDate between DATE_ADD(varTransactionDate,INTERVAL -varForDayas DAY) and varTransactionDate
                        and t.RecordStatus != 'D' 
					union all
					select t.LedgerId FROM transaction t 
						where t.TransactionDate between DATE_ADD(varTransactionDate,INTERVAL -varForDayas DAY) and varTransactionDate
                        and t.RecordStatus != 'D'
					) as t	
				group by t.LedgerId
				) as t on t.LedgerId = l.LedgerId
/*	inner JOIN (Select LedgerId
				,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
				from voucher_detail aa
						Where aa.VoucherType = 2
						and aa.RecordStatus != 'D' 
						and aa.OrganizationId = varOrganizationId
						group by aa.LedgerId 
			) as OPBal on OPBal.LedgerId = l.LedgerId 
*/			
	where t.LedgerId is null
	)
	and login.OrganizationId = varOrganizationId
	and AccountStatus = 1
	;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `auto_transaction_lock_for_inactive`(
	IN varOrganizationId bigint,
	IN varTransactionDate DATE,
	IN varForDayas int
)
begin
	
	declare varLoginUserName varchar(50);
	DECLARE finishedorganization INTEGER DEFAULT 0;
	DEClARE curorganization 
		CURSOR FOR 
		select OrganizationId,AbsentLedgerLockDays from organization 
		where (ifnull(OrganizationId,0) = varOrganizationId or ifnull(varOrganizationId,0) = 0 ) 
		and AbsentLedgerLockDays > 0
		and RecordStatus != 'D'
	;
	
	DECLARE CONTINUE HANDLER 
	FOR NOT FOUND SET finishedorganization = 1;

	OPEN curorganization;
			
	getOrganization: LOOP

		FETCH curorganization INTO varOrganizationId,varForDayas;
		IF finishedorganization = 1 THEN 
			LEAVE getOrganization;
		END IF;

		
		begin
		
			declare varAmount float;

			declare VoucherId BIGINT default 0;

			declare varVoucherType smallint default 2;
			declare varOppositLedgerId smallint default 6;
			declare varShiftId smallint default 0;

			declare varLedgerId int default 0;

			DECLARE finished INTEGER DEFAULT 0;
			DEClARE curLedger 
					CURSOR FOR 

				select l.LedgerId ,ifnull(OPBal.opening,0)opening
				from (select ledger.LedgerId,ledger.LedgerName
				from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
				and ifnull(ledger.ParentLedgerId,0) = 0
				and ledger.OrganizationId = varOrganizationId) as l
				left join (
							select t.LedgerId
								from (select t.LedgerId FROM transaction_declare t 
									where t.TransactionDate between DATE_ADD(varTransactionDate,INTERVAL -varForDayas DAY) and varTransactionDate
									and t.RecordStatus != 'D' 
								union all
								select t.LedgerId FROM transaction t 
									where t.TransactionDate between DATE_ADD(varTransactionDate,INTERVAL -varForDayas DAY) and varTransactionDate
									and t.RecordStatus != 'D'
								) as t	
							group by t.LedgerId
							) as t on t.LedgerId = l.LedgerId
				inner JOIN (Select LedgerId
							,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
							from voucher_detail aa
									Where aa.VoucherType = 2
									and aa.RecordStatus != 'D' 
									and aa.OrganizationId = varOrganizationId
									group by aa.LedgerId 
						) as OPBal on OPBal.LedgerId = l.LedgerId 
				where t.LedgerId is null
				and OPBal.opening > 0 						
				order by l.LedgerName
				;


			DECLARE CONTINUE HANDLER 
			FOR NOT FOUND SET finished = 1;
						
			set varVoucherType = 2;
			set varOppositLedgerId = 6;
			set varShiftId = 0;
			set varLoginUserName = 'SYSTEM';
			OPEN curLedger;
			getLedger: LOOP
					FETCH curLedger INTO varLedgerId,varAmount;
					IF finished = 1 THEN 
						LEAVE getLedger;
					END IF;
					
					if varAmount > 0 then
						/*      Voucher */
						
						insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
						,Amount,Remark,LagaiKhai
						,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
						values(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_LIMIT_REV_LOCK',0
						,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
						;
							
				  
						set VoucherId = LAST_INSERT_ID();

						/* Limit to party */
						insert into voucher_detail(OrganizationId,
						VoucherId
						,LedgerId
						,VoucherDetailType,ShiftId
						,VoucherDate
						,VoucherType
						,Amount
						,AmountType
						,OppositeLedgerId
						,Flag1
						,Remark,SelfHissa,OtherHissa
						,MondayFinalFlag,VoucherMode,FromLedgerId
						,OpenAmount
						,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
						)
						values(varOrganizationId,VoucherId
						,varLedgerId
						,0,varShiftId
						,varTransactionDate
						,varVoucherType
						,varAmount 
						,'Cr'
						,varOppositLedgerId
						,0,'AUTO_LIMIT_REV_LOCK',0,0
						,'False','AUTO',0
						,0
						,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
						;
						
						/* party to Limit  */

						
						insert into voucher_detail(OrganizationId,
						VoucherId
						,LedgerId
						,VoucherDetailType,ShiftId
						,VoucherDate
						,VoucherType
						,Amount
						,AmountType
						,OppositeLedgerId
						,Flag1
						,Remark,SelfHissa,OtherHissa
						,MondayFinalFlag,VoucherMode,FromLedgerId
						,OpenAmount
						,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
						)
						values(varOrganizationId,VoucherId
						,varOppositLedgerId
						,0,varShiftId
						,varTransactionDate
						,varVoucherType
						,varAmount
						,'Dr'
						,varLedgerId
						,0,'AUTO_LIMIT_REV_LOCK',0,0
						,'False','AUTO',0
						,0
						,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
						)
						;
					end if;
/*
					update ledger set TransactionLock = 1 where LedgerId  = varLedgerId
					;
*/					
				END LOOP getLedger;
				CLOSE curLedger;
		
		end;

		update ledger set TransactionLock = 1 
		where LedgerId in (
		select l.LedgerId 
		from (select ledger.LedgerId,ledger.LedgerName
		from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
		and ifnull(ledger.ParentLedgerId,0) = 0
		and ledger.OrganizationId = varOrganizationId) as l
		left join (
					select t.LedgerId
						from (select t.LedgerId FROM transaction_declare t 
							where t.TransactionDate between DATE_ADD(varTransactionDate,INTERVAL -varForDayas DAY) and varTransactionDate
							and t.RecordStatus != 'D' 
						union all
						select t.LedgerId FROM transaction t 
							where t.TransactionDate between DATE_ADD(varTransactionDate,INTERVAL -varForDayas DAY) and varTransactionDate
							and t.RecordStatus != 'D'
						) as t	
					group by t.LedgerId
					) as t on t.LedgerId = l.LedgerId
		where t.LedgerId is null
		)
		and ledger.OrganizationId = varOrganizationId
		and TransactionLock = 0
		;

	END LOOP getorganization;
	CLOSE curorganization;
	

	select 1 Flag;

	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `auto_vapsi_create`(
	IN varOrganizationId bigint,
	IN varFromDate DATE,
	IN varToDate DATE,
	IN varTransactionDate DATE,
	IN varToLedgerIds bigint,
	IN varLoginUserName varchar(50)      
)
begin
/*
other variables 
,in varLedgerId bigint
,in varTransactionDate DATE
,in varFromDate DATE
,in varToDate DATE
,in varVapsiBaseAmount float 
,in varAmount float
,in varVapsiPercent float
,in varVapsiAmountOn int    #1 for P&L 2 for Payment
,in varLoginUserName varchar(50)      
*/

declare varVapsiFromDate date;
declare varVapsiBaseAmount float;
declare varAmount float;
declare varVapsiPercent float;
declare varVapsiAmountOn int default 1; #1 for P&L 2 for Payment

declare VoucherId BIGINT default 0;
declare varVapsiWorkingDays INT default 0;

declare varVoucherType smallint default 4;
declare varOppositLedgerId smallint default 5;
declare varShiftId smallint default 0;

declare varLedgerId int default 0;

DECLARE finished INTEGER DEFAULT 0;

SELECT VapsiWorkingDays into varVapsiWorkingDays FROM organization
			where organization.OrganizationId = varOrganizationId
			;

	begin
		DEClARE curLedger 
			CURSOR FOR 
			
		SELECT DISTINCT l.LedgerId
		,varFromDate as FromDate
		,l.vapsi
		,(ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) * (100 - ifnull(Hissa,0))) /100  as VapsiBaseAmount 
		,(((ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) * (100 - ifnull(Hissa,0))) /100)  
			* ifnull(l.vapsi,0) )/100 as vapsiAmount 
	/*	,ifnull((vdWorking.WorkingDays),0) WorkingDays
		,(case when ifnull((select sum(Vapsi) from third_party_vapsi where third_party_vapsi.LedgerId = l.LedgerId and RecordStatus != 'D'),0) > 0 then 'Yes' else 'No' end) as IsTPV
	*/	
		from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.vapsi,ledger.AgentLedgerId 
			from ledger 
			where ledger.GroupId in (3,4,5)
			and ifnull(ledger.Vapsi,0) != 0 and ledger.RecordStatus!='D' 
			and ifnull(ledger.ParentLedgerId,0) = 0 
			and ledger.OrganizationId = varOrganizationId
			and (varToLedgerIds = 0 or ifnull(ledger.HPLedgerId,0) = varToLedgerIds)
			and (ifnull(varVapsiWorkingDays,0) = 0 
					or ledger.LedgerId in (
						(select vd.LedgerId
							from (
								select		
								vd.LedgerId,vd.VoucherDate
								from voucher_detail as vd
								where vd.VoucherDate between varFromDate and varToDate
								and (vd.RecordStatus!='D') 
								and vd.VoucherType in (22,23,24)
								group by vd.LedgerId,vd.VoucherDate
							) as vd
						group by vd.LedgerId
						having count(1) >= varVapsiWorkingDays
						)
					)
				) 
			) as l  
		left JOIN (select
			(case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
																else ledgerBaap.ParentLedgerId end) LedgerId,varFromDate as FromDate,
			sum(IF(vd.ShiftId != 0,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) ProfitAndLoss
			from voucher_detail as vd
			inner join shift on vd.ShiftId = shift.ShiftId and ifnull(shift.IsCreateVapsi,1) = 1
			left join (select ledger.LedgerId,ledger.ParentLedgerId from ledger 
			WHERE (ledger.RecordStatus!='D') 
			and ledger.OrganizationId = varOrganizationId
			and ledger.GroupId in (3,4,5)
			)as ledger on vd.LedgerId = ledger.LedgerId
			left join (select ledger.LedgerId,ledger.ParentLedgerId from ledger 
			WHERE (ledger.RecordStatus!='D') 
			and ledger.OrganizationId = varOrganizationId
			and ledger.GroupId in (3,4,5)
			)as ledgerBaap on ledger.ParentLedgerId = ledgerBaap.LedgerId
	/*
			left join (select vapsi.LedgerId,max(DATE_ADD(vapsi.vapsiToDate, INTERVAL 1 DAY)) as FromDate from vapsi where vapsi.RecordStatus != 'D'
			group by LedgerId) as vapsi on vapsi.LedgerId = (case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 then ledger.ParentLedgerId
																else ledgerBaap.ParentLedgerId end)
	*/
			where vd.VoucherDate between varFromDate and varToDate
/*
			and varFromDate not in (select vapsi.VapsiFromDate from vapsi where vapsi.RecordStatus != 'D' and vapsi.LedgerId = (case when ledger.ParentLedgerId = 0 then vd.LedgerId 
																WHEN ledgerBaap.ParentLedgerId = 0 then ledger.ParentLedgerId
																else ledgerBaap.ParentLedgerId end))
*/
			and (case when ledger.ParentLedgerId = 0 then vd.LedgerId 
				WHEN ledgerBaap.ParentLedgerId = 0 then ledger.ParentLedgerId
				else ledgerBaap.ParentLedgerId end) not in (select vapsi.LedgerId from vapsi where vapsi.RecordStatus != 'D' and vapsi.VapsiFromDate = varFromDate)
			
			and (vd.RecordStatus!='D') 
			group by (case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
																else ledgerBaap.ParentLedgerId end)
			) as vd on vd.LedgerId = l.LedgerId   
		left join (select sum(Hissa) Hissa,LedgerId from hissa where LedgerId != HissaLedgerId and hissa.RecordStatus != 'D' group by LedgerId ) 
				as hissa  on hissa.LedgerId = l.LedgerId 
	/*
		left join (select vapsi.LedgerId,max(DATE_ADD(vapsi.vapsiToDate, INTERVAL 1 DAY)) as FromDate from vapsi where vapsi.RecordStatus != 'D'
				group by LedgerId) as vapsiDate on vapsiDate.LedgerId = l.LedgerId
	*/
		/*
	left join (
			select LedgerId,count(WorkingDays) as WorkingDays
				from
				(
				select		
				vd.LedgerId,count(1) WorkingDays
				from voucher_detail as vd
				left join (select vapsi.LedgerId,max(DATE_ADD(vapsi.vapsiToDate, INTERVAL 1 DAY)) as FromDate from vapsi where vapsi.RecordStatus != 'D'
					group by LedgerId) as vapsi on vapsi.LedgerId = vd.LedgerId
				where vd.VoucherDate between ifnull(vapsi.FromDate,varFromDate) and varToDate
				and (vd.RecordStatus!='D') 
				and vd.VoucherType in (22,23,24)
				group by vd.LedgerId,vd.VoucherDate
				) as vd 
				group by LedgerId
			) as vdWorking on vdWorking.LedgerId = l.LedgerId   
		*/	
		GROUP BY l.LedgerId,l.Vapsi
		,vd.FromDate,l.AddedDate,ifnull(Hissa,0)
		having (ifnull(sum(ProfitAndLoss),0) > 0 )
		Order By l.LedgerId
		;


	DECLARE CONTINUE HANDLER 
	FOR NOT FOUND SET finished = 1;
				
		set varVoucherType = 4;
		set varOppositLedgerId = 5;
		set varShiftId = 0;

	OPEN curLedger;
			
	getLedger: LOOP
			FETCH curLedger INTO varLedgerId,varVapsiFromDate,varVapsiPercent,varVapsiBaseAmount,varAmount;
			IF finished = 1 THEN 
				LEAVE getLedger;
			END IF;
			

			/*      Voucher */
			
			insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
			,Amount,Remark,LagaiKhai
			,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
			values(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_VAPSI',0
			,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
			;
				
	  
			set VoucherId = LAST_INSERT_ID();

			/* Vapsi to party */
			
			if varVapsiPercent - ifnull((select sum(Vapsi)
							from third_party_vapsi 
							where LedgerId = varLedgerId
							and RecordStatus != 'D'
						),0) <> 0 then 
			
				insert into voucher_detail(OrganizationId,
				VoucherId
				,LedgerId
				,VoucherDetailType,ShiftId
				,VoucherDate
				,VoucherType
				,Amount
				,AmountType
				,OppositeLedgerId
				,Flag1
				,Remark,SelfHissa,OtherHissa
				,MondayFinalFlag,VoucherMode,FromLedgerId
				,OpenAmount
				,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
				)
				values(varOrganizationId,VoucherId
				,varLedgerId
				,0,varShiftId
				,varTransactionDate
				,varVoucherType
				,(varAmount * (varVapsiPercent - ifnull((select sum(Vapsi)
								from third_party_vapsi 
								where LedgerId = varLedgerId
								and RecordStatus != 'D'
							),0))/varVapsiPercent) 
				,'Cr'
				,varOppositLedgerId
				,'','SELF',0,0
				,'False','AUTO',0
				,0
				,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
				;
			end if;
			
			/* Vapsi to TPV */
			insert into voucher_detail(OrganizationId,
			VoucherId
			,LedgerId
			,VoucherDetailType,ShiftId
			,VoucherDate
			,VoucherType
			,Amount
			,AmountType
			,OppositeLedgerId
			,Flag1
			,Remark,SelfHissa,OtherHissa
			,MondayFinalFlag,VoucherMode,FromLedgerId
			,OpenAmount
			,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
			)
			select varOrganizationId,VoucherId
			,(case when third_party_vapsi.VapsiLedgerId = 11 then (case when ledger.HPLedgerId = 0 then ledger.LedgerId else ledger.HPLedgerId end) 
						else third_party_vapsi.VapsiLedgerId end)
			,0,varShiftId
			,varTransactionDate
			,varVoucherType
			,varAmount * (ifnull(third_party_vapsi.Vapsi,0))/varVapsiPercent
			,'Cr'
			,varOppositLedgerId
			,'',ifnull((select max(LedgerName) from ledger where LedgerId = varLedgerId),''),0,0
			,'False','AUTO',0
			,0
			,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
			from third_party_vapsi 
			join ledger on ledger.LedgerId = third_party_vapsi.LedgerId and ledger.RecordStatus != 'D'
			where third_party_vapsi.LedgerId = varLedgerId
			and third_party_vapsi.RecordStatus != 'D'		
			;
			
			/* Vapsi from Hissa */
	/*
			insert into voucher_detail(OrganizationId,
			VoucherId
			,LedgerId
			,VoucherDetailType,ShiftId
			,VoucherDate
			,VoucherType
			,Amount
			,AmountType
			,OppositeLedgerId
			,Flag1
			,Remark,SelfHissa,OtherHissa
			,MondayFinalFlag,VoucherMode,FromLedgerId
			,OpenAmount
			,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
			)
			select varOrganizationId,VoucherId
			,HissaLedgerId
			,0,varShiftId
			,varTransactionDate
			,varVoucherType
			,varAmount * (ifnull(Hissa,0))/100
			,'Dr'
			,varOppositLedgerId
			,'','AUTO_VAPSI',0,0
			,'False','AUTO',0
			,0
			,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
			from hissa 
			where LedgerId = varLedgerId
			and RecordStatus != 'D'		
			;
	*/
			/* Vapsi from Vapsi Account */
			insert into voucher_detail(OrganizationId,
			VoucherId
			,LedgerId
			,VoucherDetailType,ShiftId
			,VoucherDate
			,VoucherType
			,Amount
			,AmountType
			,OppositeLedgerId
			,Flag1
			,Remark,SelfHissa,OtherHissa
			,MondayFinalFlag,VoucherMode,FromLedgerId
			,OpenAmount
			,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
			)
			values(varOrganizationId,VoucherId
			,varOppositLedgerId
			,0,varShiftId
			,varTransactionDate
			,varVoucherType
			,varAmount
	/*	
		,(varAmount * (100 - ifnull((select sum(Hissa)
							from hissa 
							where LedgerId = varLedgerId
							and RecordStatus != 'D'
						),0))/100) 
	*/
			,'Dr'
			,varLedgerId
			,'','AUTO_VAPSI',0,0
			,'False','AUTO',0
			,0
			,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
			)
			;

			/*      Vapsi Table Entry */

			INSERT INTO vapsi
			(
			OrganizationId,
			LedgerId,
			ParentsLedgerId,
			VoucherId,
			VoucherDate,
			VapsiFromDate,
			VapsiToDate,
			BaseAmount,
			VapsiPercent,
			VapsiAmount,
			VapsiOn,
			RecordStatus,
			AddedBy,
			AddedDate,
			UpdatedBy,
			UpdatedDate)
			select
			varOrganizationId,
			varLedgerId,
			VapsiLedgerId,
			VoucherId,
			varTransactionDate,
			varVapsiFromDate,
			varToDate,
			varVapsiBaseAmount,
			ifnull(third_party_vapsi.Vapsi,0),
			varAmount * (ifnull(third_party_vapsi.Vapsi,0))/varVapsiPercent,
			varVapsiAmountOn,
			'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
			from 
			(
			select varLedgerId as VapsiLedgerId, (varVapsiPercent - ifnull((select sum(Vapsi)
								from third_party_vapsi 
								where LedgerId = varLedgerId
								and RecordStatus != 'D'
							),0)) as Vapsi
			union all
			select (case when third_party_vapsi.VapsiLedgerId = 11 then ledger.HPLedgerId else third_party_vapsi.VapsiLedgerId end) as VapsiLedgerId,third_party_vapsi.Vapsi
			from third_party_vapsi 
			join ledger on ledger.LedgerId = third_party_vapsi.LedgerId and ledger.RecordStatus != 'D'
			where third_party_vapsi.LedgerId = varLedgerId
			and third_party_vapsi.RecordStatus != 'D'
			) as third_party_vapsi where Vapsi != 0
			;


		END LOOP getLedger;
		CLOSE curLedger;
	end	;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `chat_group_assign_ledgers`(
in varOrganizationId bigint(21)
,in varLedgerId bigint(21)
,in varChatGroupId bigint(21)
)
begin

	select ledger.LedgerId as LedgerId,ledger.LedgerName as LedgerName
		,ledger.ChatGroupId
		,chat_group.ChatGroupName 
		,chat_group.IsAllow
		,ledger.RecordStatus
    from ledger 
	left join chat_group on ledger.ChatGroupId = chat_group.ChatGroupId 
	where ledger.OrganizationId = varOrganizationId
    and (ledger.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0)
	and ifnull(ledger.ChatGroupId,0) != 0  
	and (ledger.ChatGroupId = varChatGroupId or ifnull(varChatGroupId,0) = 0)
	and ledger.RecordStatus != 'D'
    order by ledger.LedgerName 
	;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `chat_group_receiver_yesno_report`(
	in varOrganizationId bigint(21)
	,IN varChatGroupId bigint
)
begin

		select ledger.LedgerId,ledger.LedgerName,login.UserName 
		,(case when ifnull(chat_group_receiver.LedgerId,0) = 0 then 0 else 1 end) IsReceiver
		from ledger
		left join chat_group_receiver on chat_group_receiver.LedgerId = ledger.LedgerId
		and ifnull(chat_group_receiver.ChatGroupId,0) = varChatGroupId
		and chat_group_receiver.RecordStatus != 'D'
		left join login on login.LedgerId = ledger.LedgerId
		where ledger.GroupId in (7,6,1)
		and ledger.OrganizationId = varOrganizationId
		and ledger.RecordStatus != 'D'
		order by ledger.LedgerName
;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `chat_rpt_associate_ledgers`(
in varOrganizationId bigint(21)
,in varLedgerId bigint(21)
,in varAssocateLedgerId bigint(21)
)
begin

	select FromAssociate.LedgerId as LedgerId,FromAssociate.LedgerName as LedgerName
		,ToAssociate.LedgerId as AssociateLedgerId,ToAssociate.LedgerName as AssociateLedgerName
		,chat_ledger_associate.UpdatedBy ,chat_ledger_associate.UpdatedDate , chat_ledger_associate.ChatledgerassociateId
		
    from chat_ledger_associate 
    left join ledger as FromAssociate on FromAssociate.LedgerId = chat_ledger_associate.LedgerId
	left join ledger as ToAssociate on ToAssociate.LedgerId = chat_ledger_associate.AssociateLedgerId
	where chat_ledger_associate.OrganizationId = varOrganizationId
    and (chat_ledger_associate.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0)
    and (chat_ledger_associate.AssociateLedgerId = varAssocateLedgerId or ifnull(varAssocateLedgerId,0) = 0)
	and chat_ledger_associate.RecordStatus != 'D'
	;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `chat_rpt_group_list`(
in varOrganizationId bigint(21)
,in varLedgerId bigint(21)
)
begin

	select ledger.LedgerId as ChatGroupId,ledger.LedgerName as ChatGroupName,'0' as ChatType,ledger.ChatGroupId as OrgChatGroupId 
        ,0 UnReadMessage,ledger.LedgerId as OperatorId,ledger.LedgerName as OperatorName

    from ledger 
	where ifnull(ledger.ChatGroupId,0) != 0  
	and ledger.ChatGroupId in (select chat_group.ChatGroupId from chat_group where ifnull(IsAllow,1) = 1)
	and (ledger.LedgerId = varLedgerId
	or ledger.LedgerId in (select AssociateLedgerId from chat_ledger_associate where LedgerId = varLedgerId)
	)
	and ledger.RecordStatus != 'D'
	union all 
	select ledger.LedgerId as ChatGroupId,ledger.LedgerName as ChatGroupName,'0' as ChatType,ledger.ChatGroupId as OrgChatGroupId 
        ,0 UnReadMessage,varLedgerId as OperatorId
        ,(select ledger.LedgerName from ledger where ledger.LedgerId = varLedgerId) as OperatorName

    from ledger 
	where ledger.ChatGroupId in (select chat_group_receiver.ChatGroupId from chat_group_receiver where chat_group_receiver.LedgerId = varLedgerId)
	and ledger.ChatGroupId in (select chat_group.ChatGroupId from chat_group where ifnull(IsAllow,1) = 1)
	and ledger.RecordStatus != 'D'
	and (case when (select GroupId from ledger l where l.LedgerId = varLedgerId and GroupId = 6) then ledger.AgentLedgerId in (select CommanMasterId from comman_master where LedgerId = varLedgerId) else True end)
	;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `chat_rpt_window_ledgers`(
in varOrganizationId bigint(21)
,in varLedgerId bigint(21)
,in varChatGroupId bigint(21)
)
begin
	select l.LedgerId
	,(case when l.GroupId = 7 then login.UserName else l.LedgerName end) as LedgerName
	,l.ChatGroupId,login.DeviceId,login.LoginType as RoleId,login.UserName  
	from
	(
		select ledger.LedgerId as LedgerId,ledger.LedgerName as LedgerName,ifnull(ledger.ChatGroupId,0) as ChatGroupId,ledger.GroupId  from ledger 
		where (ledger.LedgerId in (select chat_group_receiver.LedgerId from chat_group_receiver 
									where chat_group_receiver.RecordStatus != 'D' 
									and (chat_group_receiver.ChatGroupId in 
									(select led.ChatGroupId from ledger as led where led.OrganizationId = varOrganizationId and led.LedgerId = varLedgerId and led.RecordStatus != 'D')
									or chat_group_receiver.ChatGroupId = ifnull(varChatGroupId,0) or (ifnull(varChatGroupId,0) = 0 or ifnull(varLedgerId,0) = 0) 
									and chat_group_receiver.OrganizationId = varOrganizationId
									)
									and chat_group_receiver.ChatGroupId in (select chat_group.ChatGroupId from chat_group where ifnull(IsAllow,1) = 1)								
									)
				or ledger.LedgerId = varLedgerId
				) 
			and (case when ifnull((select lGroup.GroupId from ledger as lGroup where lGroup.LedgerId = varLedgerId),0) = 5 then 
							ledger.GroupId != 6 or ledger.LedgerId = ifnull((select comman_master.LedgerId 
													from ledger as lAgent 
													left join comman_master on comman_master.CommanMasterId = lAgent.AgentLedgerId 
													where lAgent.LedgerId = varLedgerId),0)
						else true end)
			and ledger.RecordStatus != 'D'
			and ledger.OrganizationId = varOrganizationId
	) as l
	left join login on login.LedgerId = l.LedgerId and login.RecordStatus != 'D'
	where ifnull(login.AccountStatus,0) !=0  
	;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `chat_update_deviceid`(
in  varLoginId bigint(21)
,in varDeviceId varchar(500)
)
begin
	update login set DeviceId = varDeviceId
	where LoginId = varLoginId
	;
	select 1 as InsertId;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `check_comman_master_before_delete`(IN `varLedgerIds` INT, IN `varCommanMasterType` INT)
    NO SQL
begin
	declare returnValue int;
	set returnValue = 0;

	if exists (select * from comman_master
	where comman_master.LedgerId = varLedgerIds 
    and comman_master.CommanMasterType = varCommanMasterType) then
	set returnValue = 1;
	end if;
    
	select returnValue;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `check_ledger_before_delete`(IN `LedgerIds` INT)
    NO SQL
begin
	declare returnValue int;
	set returnValue = 0;

	if exists (select * from transaction
	where transaction.LedgerId = LedgerIds) then
	set returnValue = 1;
	end if;

	if exists (select LedgerId from voucher_detail
	where voucher_detail.LedgerId = LedgerIds) then
	set returnValue = 1;
	end if;

	select returnValue;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `config_menu_role_permission_of_organization`(IN varOrganizationId int(20)
, IN varRoleId int(20)
, IN varMenuId int(20)
, IN varLoginId int(20)
, IN varIsCheckRolePermissionDenied int
)
BEGIN
	SELECT rp.RolePermissionId,
    rp.OrganizationId,
    rp.RoleId,
    rp.MenuId,
    rp.Title,
    rp.Page,
    (case when ifnull(role_permission_denied.RolePermissionId,0) = 0 or ifnull(varIsCheckRolePermissionDenied,0) = 0 then rp.`IsPageAllow` else 0 end) as IsPageAllow,
    (case when ifnull(role_permission_denied.RolePermissionId,0) = 0 or ifnull(varIsCheckRolePermissionDenied,0) = 0 then rp.`IsOption` else 0 end) as IsOption,
    (case when ifnull(role_permission_denied.RolePermissionId,0) = 0 or ifnull(varIsCheckRolePermissionDenied,0) = 0 then rp.`Add` else 0 end) as `Add`,
    (case when ifnull(role_permission_denied.RolePermissionId,0) = 0 or ifnull(varIsCheckRolePermissionDenied,0) = 0 then rp.`Edit` else 0 end) as Edit,
    (case when ifnull(role_permission_denied.RolePermissionId,0) = 0 or ifnull(varIsCheckRolePermissionDenied,0) = 0 then rp.`Delete` else 0 end) as `Delete` ,
    (case when ifnull(role_permission_denied.RolePermissionId,0) = 0 or ifnull(varIsCheckRolePermissionDenied,0) = 0 then rp.`Export` else 0 end) as Export,
    rp.ViewType,
    rp.RecordStatus,
    rp.AddedBy,
    rp.AddedDate,
    rp.UpdatedBy,
    rp.UpdatedDate
	FROM role_permission rp
	left join role_permission_denied on role_permission_denied.RolePermissionId = rp.RolePermissionId and role_permission_denied.RecordStatus != 'D'
				and role_permission_denied.LoginId = varLoginId
	left join (select count(1) as ShiftCount,max(role_permission_transaction.ExpiryDateTime) ExpiryDateTime,role_permission_transaction.Page  
				from role_permission_transaction 
				where role_permission_transaction.RecordStatus != 'D' and ifnull(role_permission_transaction.IsPageAllow,0) = 1
				and role_permission_transaction.LoginId  = varLoginId
				group by role_permission_transaction.Page
				) as role_permission_transaction on rp.Page = role_permission_transaction.Page  
				
	where rp.OrganizationId = varOrganizationId
	and rp.RoleId = varRoleId
	and rp.MenuId = varMenuId
	and rp.RecordStatus != 'D'
	and 
		(case when ifnull(varIsCheckRolePermissionDenied,0) = 1 and (select ifnull(IsDeclareTransactionConfig,0) from role where role.OrganizationId = varOrganizationId and role.RoleId = varRoleId) = 1 then
		if(ifnull(role_permission_transaction.ExpiryDateTime,CURRENT_TIMESTAMP()) >= CURRENT_TIMESTAMP()
				, true 
				, false )
	else
		true
	end 
	)
	order by rp.RolePermissionId ASC;
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `config_page_permission_user_disable`(IN varOrganizationId int(20)
 , IN varRoleId int(20)
 , In varRolePermissionId int
 )
begin
	select login.LoginId,UserName,LoginName
	,(case when ifnull(role_permission_denied.LoginId,0) = 0 then 0 else 1 end) IsDisable  
	from login
	left join role_permission_denied on role_permission_denied.LoginId = login.LoginId and role_permission_denied.RecordStatus != 'D'  and role_permission_denied.RolePermissionId = varRolePermissionId
	where login.OrganizationId = varOrganizationId
    and LoginType = varRoleId
    and login.RecordStatus != 'D';
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `config_role_permission_of_organization`(IN varOrganizationId int(20), IN varRoleId int(20))
BEGIN
	SELECT *
	FROM role_permission rp
	where rp.OrganizationId = varOrganizationId
	and rp.RoleId = varRoleId
	and rp.RecordStatus != 'D'
    order by rp.RolePermissionId ASC;
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `config_transaction_permission_of_organization`(IN varOrganizationId int(20)
, IN varLoginId int(20)
, IN varShiftId int(20)
, IN varShiftDate DATE
)
begin
		SELECT role_permission_transaction.RolePermissionTransactionId,
			role_permission_transaction.OrganizationId,
			role_permission_transaction.LoginId,
			role_permission_transaction.ShiftId,
			role_permission_transaction.ShiftDate,
			role_permission_transaction.ExpiryDateTime,
			/*Y-m-d\TH:i:s*/
			date_format(role_permission_transaction.ExpiryDateTime,'%Y-%m-%d\T%H:%i:%s') ExpiryDateTimeNew,
			role_permission_transaction.DataViewMode,
			role_permission_transaction.Page,
			role_permission_transaction.IsPageAllow,
			role_permission_transaction.Add,
			role_permission_transaction.Edit,
			role_permission_transaction.Delete,
			role_permission_transaction.Export,
			role_permission_transaction.ViewType,
			role_permission_transaction.RecordStatus,
			role_permission_transaction.AddedBy,
			role_permission_transaction.AddedDate,
			role_permission_transaction.UpdatedBy,
			role_permission_transaction.UpdatedDate,
			(case when CURRENT_TIMESTAMP() >= ifnull(role_permission_transaction.ExpiryDateTime,CURRENT_TIMESTAMP()) then 1 else 0 end) as IsExpiry
		FROM role_permission_transaction
	
		where role_permission_transaction.OrganizationId = varOrganizationId
		and role_permission_transaction.RecordStatus != 'D'
		and (role_permission_transaction.LoginId = varLoginId or ifnull(varLoginId,0) = 0 )
		and (role_permission_transaction.ShiftId = varShiftId or ifnull(varShiftId,0) = 0 )
		and (role_permission_transaction.ShiftDate = varShiftDate or varShiftDate is null )
		
		order by role_permission_transaction.AddedDate desc;


END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `CreateIndex`(
    given_table    VARCHAR(64),
    given_index    VARCHAR(64),
    given_columns  VARCHAR(64)
)
BEGIN

    DECLARE IndexIsThere INTEGER;

    SELECT COUNT(1) INTO IndexIsThere
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE table_name   = given_table
    AND   index_name   = given_index;

    IF IndexIsThere = 0 THEN
        SET @sqlstmt = CONCAT('CREATE INDEX ',given_index,' ON ',
        given_table,' (',given_columns,')');
        PREPARE st FROM @sqlstmt;
        EXECUTE st;
        DEALLOCATE PREPARE st;
    ELSE
        SELECT CONCAT('Index ',given_index,' already exists on Table ',
        given_table) CreateindexErrorMessage;   
    END IF;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `dashbaord_jantri_collection_of_organization`(
IN `varOrganizationId` bigint(21)
, IN `varLedgerId` bigint(21)
, IN `varAgentId` bigint(8)
)
SELECT DISTINCT 
	SUM(IF(t.EntryType = 'Main', td.Amount, 0)) AS CollectionAmount, 
    round(SUM(if(t.EntryType = 'Main', if (t.TransactionMode = 1,
    
				td.FinalAmount
				-
				(	
					(td.FinalAmount)
					- (td.FinalAmount
					*(ifnull((
							t.SelfHissa
					/100),0))
					)
				)*(ifnull((
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = t.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				/100),0))

				- (td.FinalAmount
				*(ifnull((
						t.SelfHissa
				/100),0))
				)
    
	,0),0))) as JantriAmount,
	s.ShiftDate,s.ShiftId,s.ShiftName,s.ShiftFor
    ,declare_result.DeclareDate
    ,(select d.DeclareNumber from declare_result as d where d.RecordStatus != 'D' and d.OrganizationId = varOrganizationId and d.ShiftId = s.ShiftId and d.DeclareDate = declare_result.DeclareDate) as DeclareNumber
    
	
    FROM transaction t 
	inner join ledger l on t.LedgerId = l.LedgerId
	inner JOIN transaction_detail td ON td.TransactionId = t.TransactionId AND td.RecordStatus != 'D' 
		and t.OrganizationId = varOrganizationId AND t.RecordStatus != 'D'
		and (ifnull(varLedgerId,0) = 0 or t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId)
			or (select UserName from ledger
					inner join login on login.LedgerId = ledger.LedgerId
					where login.LoginType in (11,12) and ledger.LedgerId = ifnull(varLedgerId,0)) = t.AddedBy 
			)
			and ifnull((select ledger.GroupId from ledger where ledger.LedgerId = varLedgerId ),0) <> 6
			
	right JOIN shift s ON s.ShiftId = t.ShiftId
    left join (select max(DeclareDate)DeclareDate,ShiftId from declare_result where declare_result.RecordStatus != 'D' and declare_result.OrganizationId = varOrganizationId group by ShiftId) as declare_result 
				on declare_result.ShiftId = s.ShiftId
	WHERE 1=1
	and s.IsActive = 1
    and s.OrganizationId = varOrganizationId
	and s.RecordStatus != 'D'
	GROUP BY s.ShiftId,s.ShiftOrder,s.ShiftName
    order by s.ShiftOrder,s.ShiftName$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `declare_process`(
in varOrganizationId bigint(21)
,in varShiftId bigint(21)
,in varDeclareNumber smallint(6)
,in varTransactionDate DATE
)
begin

declare VoucherId BIGINT default 0;
declare varNumberType smallint default 0;

declare varSaleType smallint default 0;
declare varSaleId smallint default 0;
declare varProfitType smallint default 0;
declare varProfitId smallint default 0;
declare varCommitionType smallint default 0;
declare varCommitionId smallint default 0;
declare varHissaType smallint default 0;
declare varHissaId smallint default 0;
declare varHissaProfitType smallint default 0;
declare varHissaProfitId smallint default 0;
declare varTPCType smallint default 0;
declare varTPCId smallint default 0;
declare varNumberTypeWords varchar(200);

declare varTaxId smallint default 12;
declare varTaxType smallint default 35;

	update sys_options set Value = 1
	where Slug = 'DeclareInQuee' ;

	set varTaxType = 35;
	set varTaxId = 12;
	set varNumberType = 1 ;

	SELECT LedgerId into varTaxId FROM ledger
	where ledger.LedgerName = 'MANDI TAX A/C' ;

	
	while varNumberType <= 3 Do

		IF varNumberType = 1 THEN 
			set varNumberTypeWords = 'Dada';
			set varSaleType = 22;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 26;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 29;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 29;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		ELSEIF varNumberType = 2 THEN 
			set varNumberTypeWords = 'Bahar Ka Akhar';
			set varSaleType = 23;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 27;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 30;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 30;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		ELSEIF varNumberType = 3 THEN 
			set varNumberTypeWords = 'Andar Ka Akhar';
			set varSaleType = 24;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 28;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 31;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 31;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		end if;

		/*     Sale Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varSaleType,1,0,concat(varNumberTypeWords,' Sale'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
  
		set VoucherId = LAST_INSERT_ID();


		
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varSaleId
		,0,varShiftId
		,varTransactionDate
		,varSaleType
		,ifnull((
			select ifnull(sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount ,0 )),0)
						),0)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varSaleType
		,ifnull((
			sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount ,0 )),0)
						)
		),0)
		,'Dr'
		,varSaleId		
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		;

	

	
		/* Profit Voucher */

		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varProfitType,1,0,concat(varNumberTypeWords,' Profit'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varProfitId
		,0,varShiftId
		,varTransactionDate
		,varProfitType
		,ifnull((
			select sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount * Rate ,0 )),0)
						)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,ifnull((
			select sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount ,0 )),0)
						)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		),0)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		
		;


		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varProfitType
		,ifnull((
			sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount * Rate ,0 )),0)
						)
		),0)
		,'Cr'
		,varProfitId
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,ifnull((
			sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount ,0 )),0)
						)
		),0)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
		
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		;
	

	
		/*Commission Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varCommitionType,1,0,concat(varNumberTypeWords,' Comm.'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varCommitionId
		,0,varShiftId
		,varTransactionDate
		,varCommitionType
		,ifnull((
			select sum(ifnull((transaction_detail.Amount * (transaction_detail.Commission - 
			(case when TPCommission = 'No' then 0 else ifnull((SELECT sum(case when varNumberType = 1 then CommissionDara else CommissionAkhar end) FROM third_party_commission where third_party_commission.LedgerId = transaction.LedgerId and third_party_commission.RecordStatus != 'D'),0) end)
			) )/100,0)
						)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varCommitionType
		,ifnull((
			sum(ifnull((transaction_detail.Amount * (transaction_detail.Commission - 
			(case when TPCommission = 'No' then 0 else ifnull((SELECT sum((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)) FROM third_party_commission where third_party_commission.LedgerId = transaction.LedgerId and third_party_commission.RecordStatus != 'D'),0) end)
			) )/100,0)
						)
		),0)
		,'Cr'
		,varCommitionId
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
		
		from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and transaction_detail.Commission > 0
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		;
	

	

		/* TPC Return */

		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varTPCType,1,0,concat(varNumberTypeWords,' TPC'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			

		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varTPCId
		,0,varShiftId
		,varTransactionDate
		,varTPCType
		,ifnull((
			select ifnull((
			sum(ifnull((transaction_detail.Amount * ((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)
			) )/100,0)
						)
			),0)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			inner join third_party_commission on third_party_commission.LedgerId = transaction.LedgerId  and third_party_commission.RecordStatus != 'D'
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and ledger.TPCommission = 'YES'
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,third_party_commission.CommissionLedgerId
		,0,varShiftId
		,varTransactionDate
		,varTPCType
		,ifnull((
			sum(ifnull((transaction_detail.Amount * ((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)
			) )/100,0)
						)
		),0)
		,'Cr'
		,varTPCId
		
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction.LedgerId
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			inner join third_party_commission on third_party_commission.LedgerId = transaction.LedgerId  and third_party_commission.RecordStatus != 'D'
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and ledger.TPCommission = 'YES'
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		group by third_party_commission.CommissionLedgerId,transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission 
		having ifnull((
			sum(ifnull((transaction_detail.Amount * (Commission
			) )/100,0)
						)
		),0) != 0
		;

		/* Hissa Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varHissaType,1,0,concat(varNumberTypeWords,' Sale Hissa'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varHissaId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,ifnull((
			select 
				sum((	
					(transaction_detail.FinalAmount)
					- (transaction_detail.FinalAmount
					*(ifnull((
							transaction.SelfHissa
					/100),0))
					)
				)*(ifnull((
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = transaction.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				/100),0)))

				+ sum(transaction_detail.FinalAmount
				*(ifnull((
						transaction.SelfHissa
				/100),0))
				)
				
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		/* Self Hissa */	
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,sum((transaction_detail.FinalAmount *
		ifnull((transaction.SelfHissa),0))/100)
		,'Cr'
		,varHissaId
		
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction.LedgerId
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			#inner join hissa on hissa.RecordStatus!='D' and  hissa.LedgerId = transaction.LedgerId and hissa.LedgerId = hissa.HissaLedgerId 
			left join ledger on ledger.LedgerId = transaction.LedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		#group by hissa.HissaLedgerId,transaction.LedgerId
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		having sum(transaction_detail.FinalAmount *
		ifnull((transaction.SelfHissa),0))!=0
		;

		/* Other Hissa */ 
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,HissaLedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,sum((
		
		(
		(transaction_detail.FinalAmount)
			- (transaction_detail.FinalAmount
			*(ifnull((
					transaction.SelfHissa
			/100),0))
			)		
		)
		
		*
		ifnull((hissa.Hissa),0))/100)
		,'Cr'
		,varHissaId
		
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction.LedgerId
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			inner join hissa on hissa.RecordStatus!='D' and  hissa.LedgerId = transaction.LedgerId and hissa.LedgerId != hissa.HissaLedgerId 
			left join ledger on ledger.LedgerId = transaction.LedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		group by hissa.HissaLedgerId,transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		having sum(transaction_detail.FinalAmount *
		ifnull((hissa.Hissa),0))!=0
		;


		/* Profit Hissa */
	
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varHissaProfitType,1,0,concat(varNumberTypeWords,' Profit Hissa'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varHissaProfitId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,ifnull((
			select 
				sum((	
					(transaction_detail.Rate * transaction_detail.Amount)
					- (transaction_detail.Rate * transaction_detail.Amount
					*(ifnull((
							transaction.SelfHissa
					/100),0))
					)
				)*(ifnull((
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = transaction.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				/100),0)))

				+ sum(transaction_detail.Rate * transaction_detail.Amount
				*(ifnull((
						transaction.SelfHissa
				/100),0))
				)
			
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		/* self hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,sum(((transaction_detail.Rate * transaction_detail.Amount) *
		ifnull((transaction.SelfHissa),0))/100)
		,'Dr'
		,varHissaProfitId
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction.LedgerId
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			#inner join hissa on hissa.RecordStatus!='D' and  hissa.LedgerId = transaction.LedgerId  and hissa.LedgerId = hissa.HissaLedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId 
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType 
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		having sum((transaction_detail.Rate * transaction_detail.Amount) *
		ifnull((transaction.SelfHissa),0)) != 0
		;
		

		/* other hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,hissa.HissaLedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,sum(((
		
			(transaction_detail.Rate * transaction_detail.Amount)
			- (transaction_detail.Rate * transaction_detail.Amount
			*(ifnull((
					transaction.SelfHissa
			/100),0))
			)		
		
		) *
		ifnull((hissa.Hissa),0))/100)
		,'Dr'
		,varHissaProfitId
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction.LedgerId
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			inner join hissa on hissa.RecordStatus!='D' and  hissa.LedgerId = transaction.LedgerId  and hissa.LedgerId != hissa.HissaLedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 1 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId 
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType 
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		group by hissa.HissaLedgerId,transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		having sum((transaction_detail.Rate * transaction_detail.Amount) *
		ifnull((hissa.Hissa),0)) != 0
		;

		set varNumberType = varNumberType + 1;
	end while;

	set varNumberType = 1;
	#and transaction.TransactionMode = 1 Khai = 1 Lagai = 0 not using yet 
	#From here downwords is Lagai process
	
	while varNumberType <= 3 Do

		IF varNumberType = 1 THEN 
			set varNumberTypeWords = 'Dada';
			set varSaleType = 22;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 26;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 29;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 29;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		ELSEIF varNumberType = 2 THEN 
			set varNumberTypeWords = 'Bahar Ka Akhar';
			set varSaleType = 23;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 27;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 30;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 30;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		ELSEIF varNumberType = 3 THEN 
			set varNumberTypeWords = 'Andar Ka Akhar';
			set varSaleType = 24;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 28;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 31;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 31;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		end if;

		/*     Sale Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varSaleType,1,0,concat(varNumberTypeWords,' Sale'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
  
		set VoucherId = LAST_INSERT_ID();


		
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varSaleId
		,0,varShiftId
		,varTransactionDate
		,varSaleType
		,ifnull((
			select ifnull(sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount ,0 )),0)
						),0)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0 
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varSaleType
		,ifnull((
			sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount ,0 )),0)
						)
		),0)
		,'Cr'
		,varSaleId		
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		;

	

	
		/* Profit Voucher */

		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varProfitType,1,0,concat(varNumberTypeWords,' Profit'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varProfitId
		,0,varShiftId
		,varTransactionDate
		,varProfitType
		,ifnull((
			select sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount * Rate ,0 )),0)
						)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,ifnull((
			select sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount ,0 )),0)
						)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		),0)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		
		;


		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varProfitType
		,ifnull((
			sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount * Rate ,0 )),0)
						)
		),0)
		,'Dr'
		,varProfitId
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,ifnull((
			sum(ifnull((if( transaction.RecordStatus != 'D'  and  transaction_detail.RecordStatus != 'D' ,Amount ,0 )),0)
						)
		),0)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
		
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		;
	

	
		/*Commission Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varCommitionType,1,0,concat(varNumberTypeWords,' Comm.'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varCommitionId
		,0,varShiftId
		,varTransactionDate
		,varCommitionType
		,ifnull((
			select sum(ifnull((transaction_detail.Amount * (transaction_detail.Commission - 
			(case when TPCommission = 'No' then 0 else ifnull((SELECT sum(case when varNumberType = 1 then CommissionDara else CommissionAkhar end) FROM third_party_commission where third_party_commission.LedgerId = transaction.LedgerId  and third_party_commission.RecordStatus != 'D'),0) end)
			) )/100,0)
						)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varCommitionType
		,ifnull((
			sum(ifnull((transaction_detail.Amount * (transaction_detail.Commission - 
			(case when TPCommission = 'No' then 0 else ifnull((SELECT sum((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)) FROM third_party_commission where third_party_commission.LedgerId = transaction.LedgerId  and third_party_commission.RecordStatus != 'D'),0) end)
			) )/100,0)
						)
		),0)
		,'Dr'
		,varCommitionId
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
		
		from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and transaction_detail.Commission > 0
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		;
	

		/*Tax Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varTaxType,1,0,concat(varNumberTypeWords,' Tax'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varTaxId
		,0,varShiftId
		,varTransactionDate
		,varTaxType
		,ifnull((
			select sum(ifnull((transaction_detail.Amount * (transaction_detail.Tax 
			) )/100,0)
						)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varTaxType
		,ifnull((
			sum(ifnull((transaction_detail.Amount * (transaction_detail.Tax
			) )/100,0)
						)
		),0)
		,'Cr'
		,varTaxId
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
		
		from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		;
	

	

		/* TPC Return */

		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varTPCType,1,0,concat(varNumberTypeWords,' TPC'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			

		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varTPCId
		,0,varShiftId
		,varTransactionDate
		,varTPCType
		,ifnull((
			select ifnull((
			sum(ifnull((transaction_detail.Amount * ((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)
			) )/100,0)
						)
			),0)
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			inner join third_party_commission on third_party_commission.LedgerId = transaction.LedgerId  and third_party_commission.RecordStatus != 'D'
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and ledger.TPCommission = 'YES'
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,third_party_commission.CommissionLedgerId
		,0,varShiftId
		,varTransactionDate
		,varTPCType
		,ifnull((
			sum(ifnull((transaction_detail.Amount * ((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)
			) )/100,0)
						)
		),0)
		,'Dr'
		,varTPCId
		
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction.LedgerId
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			inner join third_party_commission on third_party_commission.LedgerId = transaction.LedgerId  and third_party_commission.RecordStatus != 'D'
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and ledger.TPCommission = 'YES'
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		group by third_party_commission.CommissionLedgerId,transaction.LedgerId ,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		having ifnull((
			sum(ifnull((transaction_detail.Amount * (Commission
			) )/100,0)
						)
		),0) != 0
		;

		/* Hissa Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varHissaType,1,0,concat(varNumberTypeWords,' Sale Hissa'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varHissaId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,ifnull((
			select 
				sum((	
					(transaction_detail.FinalAmount)
					- (transaction_detail.FinalAmount
					*(ifnull((
							transaction.SelfHissa
					/100),0))
					)
				)*(ifnull((
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = transaction.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				/100),0)))

				+ sum(transaction_detail.FinalAmount
				*(ifnull((
						transaction.SelfHissa
				/100),0))
				)

			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		/* self hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,sum((transaction_detail.FinalAmount *
		ifnull((transaction.SelfHissa),0))/100)
		,'Dr'
		,varHissaId
		
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction.LedgerId
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			#inner join hissa on hissa.RecordStatus!='D' and  hissa.LedgerId = transaction.LedgerId  and hissa.LedgerId = hissa.HissaLedgerId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		having sum(transaction_detail.FinalAmount *
		ifnull((transaction.SelfHissa),0))!=0
		;
		/* other hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,HissaLedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,sum((
		
		(
		(transaction_detail.FinalAmount)
			- (transaction_detail.FinalAmount
			*(ifnull((
					transaction.SelfHissa
			/100),0))
			)		
		)
		
		*
		ifnull((hissa.Hissa),0))/100)
		,'Dr'
		,varHissaId
		
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction.LedgerId
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			inner join hissa on hissa.RecordStatus!='D' and  hissa.LedgerId = transaction.LedgerId  and hissa.LedgerId != hissa.HissaLedgerId
			left join ledger on ledger.LedgerId = transaction.LedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
		group by hissa.HissaLedgerId,transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		having sum(transaction_detail.FinalAmount *
		ifnull((hissa.Hissa),0))!=0
		;
		
		

		/* Profit Hissa */
	
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varHissaProfitType,1,0,concat(varNumberTypeWords,' Profit Hissa'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varHissaProfitId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,ifnull((
			select 
				sum((	
					(transaction_detail.Rate * transaction_detail.Amount)
					- (transaction_detail.Rate * transaction_detail.Amount
					*(ifnull((
							transaction.SelfHissa
					/100),0))
					)
				)*(ifnull((
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = transaction.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				/100),0)))

				+ sum(transaction_detail.Rate * transaction_detail.Amount
				*(ifnull((
						transaction.SelfHissa
				/100),0))
				)

			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		/* self hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,sum(((transaction_detail.Rate * transaction_detail.Amount) *
		ifnull((transaction.SelfHissa),0))/100)
		,'Cr'
		,varHissaProfitId
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction.LedgerId
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			#inner join hissa on hissa.RecordStatus!='D' and hissa.LedgerId = transaction.LedgerId  and hissa.LedgerId = hissa.HissaLedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId 
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		group by transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		having sum((transaction_detail.Rate * transaction_detail.Amount) *
		ifnull((transaction.SelfHissa),0)) != 0
		;
		
		/* other hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,hissa.HissaLedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,sum(((
		
		
		(transaction_detail.Rate * transaction_detail.Amount)
			- (transaction_detail.Rate * transaction_detail.Amount
			*(ifnull((
					transaction.SelfHissa
			/100),0))
			)		
		
		
		) *
		ifnull((hissa.Hissa),0))/100)
		,'Cr'
		,varHissaProfitId
		,'',CONCAT(convert(transaction.DaraRate,char),'/',convert(transaction.DaraCommission,char),'-',convert(transaction.AkharRate,char),'/',convert(transaction.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction.LedgerId
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction 
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			inner join hissa on hissa.RecordStatus!='D' and hissa.LedgerId = transaction.LedgerId  and hissa.LedgerId != hissa.HissaLedgerId
			where transaction.TransactionDate = varTransactionDate
			and transaction.TransactionMode = 0
			and transaction.ShiftId = varShiftId 
			and transaction.OrganizationId = varOrganizationId 
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			and transaction_detail.NumberType = varNumberType
			and ((transaction_detail.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		group by hissa.HissaLedgerId,transaction.LedgerId,transaction.DaraRate,transaction.DaraCommission,transaction.AkharRate,transaction.AkharCommission
		having sum((transaction_detail.Rate * transaction_detail.Amount) *
		ifnull((hissa.Hissa),0)) != 0
		;

		set varNumberType = varNumberType + 1;
	end while;
	
	INSERT INTO transaction_declare
	(TransactionId,
	OrganizationId,
	ShiftId,
	LedgerId,
	TransactionDate,
	TransactionMode,
	TransactionType,
	KFlag,
	EntryType,
	ClientRemarks,
	IsHissa,
	SelfHissa,
	OtherHissa,
	DaraRate,
	DaraCommission,
	AkharRate,
	AkharCommission,
	Tax,
	TotalAmount,
	TotalCommission,
	TotalTax,
	FinalAmount,
	TransactionStartTime,
	DeviceType,
	RecordStatus,
	AddedBy,
	AddedDate,
	UpdatedBy,
	UpdatedDate)

	SELECT TransactionId,
		OrganizationId,
		ShiftId,
		LedgerId,
		TransactionDate,
		TransactionMode,
		TransactionType,
		KFlag,
		EntryType,
		ClientRemarks,
		IsHissa,
		SelfHissa,
		OtherHissa,
		DaraRate,
		DaraCommission,
		AkharRate,
		AkharCommission,
		Tax,
		TotalAmount,
		TotalCommission,
		TotalTax,
		FinalAmount,
		TransactionStartTime,
		DeviceType,
		RecordStatus,
		AddedBy,
		AddedDate,
		UpdatedBy,
		UpdatedDate
	FROM transaction
	where ShiftId = varShiftId
	and transaction.TransactionDate = varTransactionDate
	and transaction.OrganizationId = varOrganizationId
	;
	
	INSERT INTO transaction_detail_declare
	(TransactionDetailId,
	TransactionId,
	OrganizationId,
	Number,
	NumberType,
	Amount,
	Rate,
	Commission,
	Tax,
	FinalAmount,
	OrderNumber,
	RecordStatus,
	AddedBy,
	AddedDate,
	UpdatedBy,
	UpdatedDate)

	SELECT TransactionDetailId,
		TransactionId,
		OrganizationId,
		Number,
		NumberType,
		Amount,
		Rate,
		Commission,
		Tax,
		FinalAmount,
		OrderNumber,
		RecordStatus,
		AddedBy,
		AddedDate,
		UpdatedBy,
		UpdatedDate
	FROM transaction_detail
	where TransactionId in (select transaction.TransactionId from 
		transaction 
		where ShiftId = varShiftId
		and transaction.TransactionDate = varTransactionDate
		and transaction.OrganizationId = varOrganizationId)
	;
	
	delete from transaction_detail 
	where TransactionId in (select transaction.TransactionId from 
		transaction 
		where ShiftId = varShiftId
		and transaction.TransactionDate = varTransactionDate
		and transaction.OrganizationId = varOrganizationId)
	;

	delete from transaction 
	where ShiftId = varShiftId
	and transaction.TransactionDate = varTransactionDate
	and transaction.OrganizationId = varOrganizationId
	;
	
	update shift set 
	ShiftDate = '1970-01-01' 
	where ShiftId = varShiftId
	and OrganizationId = varOrganizationId
	;
	
	Insert into declare_result(DeclareDate,ShiftId,OrganizationId,DeclareNumber,IsNeeded
	,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
	Values(varTransactionDate, varShiftId,varOrganizationId, varDeclareNumber,  'No'
	,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
	;

	insert into voucher_first(
		VoucherId 
		,OrganizationId 
		,ShiftId 
		,VoucherDate 
		,VoucherType 
		,Amount 
		,Remark 
		,LagaiKhai 
		,VoucherMode 
		,RecordStatus 
		,AddedBy 
		,AddedDate 
		,UpdatedBy 
		,UpdatedDate 
	)
	SELECT 
		voucher.VoucherId 
		,voucher.OrganizationId 
		,voucher.ShiftId 
		,voucher.VoucherDate 
		,voucher.VoucherType 
		,voucher.Amount 
		,voucher.Remark 
		,voucher.LagaiKhai 
		,voucher.VoucherMode 
		,voucher.RecordStatus 
		,voucher.AddedBy 
		,voucher.AddedDate 
		,voucher.UpdatedBy 
		,voucher.UpdatedDate 
	from voucher
	where voucher.OrganizationId = varOrganizationId and voucher.ShiftId = varShiftId and voucher.VoucherDate = varTransactionDate
	;
	
	insert into voucher_detail_first(
		VoucherDetailId 
		,OrganizationId 
		,VoucherId 
		,ShiftId 
		,LedgerId 
		,OppositeLedgerId 
		,FromLedgerId 
		,VoucherType 
		,VoucherDetailType 
		,VoucherDate 
		,Amount 
		,AmountType 
		,OpenAmount 
		,SelfHissa 
		,OtherHissa 
		,Flag1 
		,Remark 
		,MondayFinalFlag 
		,VoucherMode 
		,RecordStatus 
		,AddedBy 
		,AddedDate 
		,UpdatedBy 
		,UpdatedDate 
	)
	SELECT
		voucher_detail.VoucherDetailId 
		,voucher_detail.OrganizationId 
		,voucher_detail.VoucherId 
		,voucher_detail.ShiftId 
		,voucher_detail.LedgerId 
		,voucher_detail.OppositeLedgerId 
		,voucher_detail.FromLedgerId 
		,voucher_detail.VoucherType 
		,voucher_detail.VoucherDetailType 
		,voucher_detail.VoucherDate 
		,voucher_detail.Amount 
		,voucher_detail.AmountType 
		,voucher_detail.OpenAmount 
		,voucher_detail.SelfHissa 
		,voucher_detail.OtherHissa 
		,voucher_detail.Flag1 
		,voucher_detail.Remark 
		,voucher_detail.MondayFinalFlag 
		,voucher_detail.VoucherMode 
		,voucher_detail.RecordStatus 
		,voucher_detail.AddedBy 
		,voucher_detail.AddedDate 
		,voucher_detail.UpdatedBy 
		,voucher_detail.UpdatedDate 

	from voucher_detail
	where voucher_detail.OrganizationId = varOrganizationId 
    and voucher_detail.ShiftId = varShiftId 
    and voucher_detail.VoucherDate = varTransactionDate
	;
	
	update sys_options set Value = 0
	where Slug = 'DeclareInQuee' ;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `declare_process_before_lagai_check_transaction`(
IN varOrganizationId int(20)
, IN varShiftId int(20)
, IN varTransactionDate DATE
)
begin
		select (case ifnull(sum(TransactionCount),0) when 0 then 0 else 1 end) as TransactionCount 
		from 
		(
			select  
				(case ifnull(sum(1),0) when 0 then 0 else 1 end) as TransactionCount 
			from transaction_declare 
			where transaction_declare.TransactionDate = varTransactionDate 
			and  (transaction_declare.ShiftId = varShiftId )
			and  transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.RecordStatus!='D'
			union all
			select  
				(case ifnull(sum(1),0) when 0 then 0 else 1 end) as TransactionCount 
			from transaction 
			where transaction.TransactionDate = varTransactionDate 
			and  (transaction.ShiftId = varShiftId )
			and  transaction.OrganizationId = varOrganizationId
			and transaction.TransactionMode = 0 
			and transaction.RecordStatus!='D'
		) as t
		;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `declare_process_Re`(
in varOrganizationId bigint
,in varShiftId bigint
,in varDeclareNumber smallint
,in varTransactionDate DATE
)
begin

declare VoucherId BIGINT default 0;
declare varNumberType smallint default 0;

declare varSaleType smallint default 0;
declare varSaleId smallint default 0;
declare varProfitType smallint default 0;
declare varProfitId smallint default 0;
declare varCommitionType smallint default 0;
declare varCommitionId smallint default 0;
declare varHissaType smallint default 0;
declare varHissaId smallint default 0;
declare varHissaProfitType smallint default 0;
declare varHissaProfitId smallint default 0;
declare varTPCType smallint default 0;
declare varTPCId smallint default 0;
declare varNumberTypeWords varchar(200);

declare varTaxId smallint default 12;
declare varTaxType smallint default 35;
declare varAddedDate datetime ;

	select AddedDate into varAddedDate  
	from declare_result
	where DeclareDate = varTransactionDate 
	and ShiftId = varShiftId
	and OrganizationId = varOrganizationId
	and RecordStatus <> 'D'
	;

	SELECT LedgerId into varTaxId FROM ledger
	where ledger.LedgerName = 'MANDI TAX A/C' ;

	/*
	delete from voucher_detail where VoucherId in (select voucher.VoucherId from voucher 
		where voucher.OrganizationId = varOrganizationId and voucher.ShiftId = varShiftId and voucher.VoucherDate = varTransactionDate);
	*/
	delete from voucher_detail where OrganizationId = varOrganizationId and ShiftId = varShiftId and VoucherDate = varTransactionDate;
	
	delete from voucher 
		where OrganizationId = varOrganizationId and ShiftId = varShiftId and VoucherDate = varTransactionDate;

	set varNumberType = 1 ;

	while varNumberType <= 3 Do

		IF varNumberType = 1 THEN 
			set varNumberTypeWords = 'Dada';
			set varSaleType = 22;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 26;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 29;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 29;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		ELSEIF varNumberType = 2 THEN 
			set varNumberTypeWords = 'Bahar Ka Akhar';
			set varSaleType = 23;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 27;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 30;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 30;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		ELSEIF varNumberType = 3 THEN 
			set varNumberTypeWords = 'Andar Ka Akhar';
			set varSaleType = 24;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 28;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 31;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 31;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		end if;

		/*     Sale Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varSaleType,1,0,concat(varNumberTypeWords,' Sale'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
  
		set VoucherId = LAST_INSERT_ID();


		
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varSaleId
		,0,varShiftId
		,varTransactionDate
		,varSaleType
		,ifnull((
			select ifnull(sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount ,0 )),0)
						),0)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varSaleType
		,ifnull((
			sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount ,0 )),0)
						)
		),0)
		,'Dr'
		,varSaleId		
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		;

	

	
		/* Profit Voucher */

		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varProfitType,1,0,concat(varNumberTypeWords,' Profit'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varProfitId
		,0,varShiftId
		,varTransactionDate
		,varProfitType
		,ifnull((
			select sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount * Rate ,0 )),0)
						)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		),0)
		,'Dr'
		,ifnull((
			select sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount ,0 )),0)
						)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		),0)
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		
		;


		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varProfitType
		,ifnull((
			sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount * Rate ,0 )),0)
						)
		),0)
		,'Cr'
		,varProfitId
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,ifnull((
			sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount ,0 )),0)
						)
		),0)
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
		
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		;
	

	
		/*Commission Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varCommitionType,1,0,concat(varNumberTypeWords,' Comm.'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varCommitionId
		,0,varShiftId
		,varTransactionDate
		,varCommitionType
		,ifnull((
			select sum(ifnull((transaction_detail_declare.Amount * (transaction_detail_declare.Commission - 
			(case when TPCommission = 'No' then 0 else ifnull((SELECT sum(case when varNumberType = 1 then CommissionDara else CommissionAkhar end) FROM third_party_commission where third_party_commission.LedgerId = transaction_declare.LedgerId and third_party_commission.RecordStatus != 'D'),0) end)
			) )/100,0)
						)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varCommitionType
		,ifnull((
			sum(ifnull((transaction_detail_declare.Amount * (transaction_detail_declare.Commission - 
			(case when TPCommission = 'No' then 0 else ifnull((SELECT sum((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)) FROM third_party_commission where third_party_commission.LedgerId = transaction_declare.LedgerId and third_party_commission.RecordStatus != 'D'),0) end)
			) )/100,0)
						)
		),0)
		,'Cr'
		,varCommitionId
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
		
		from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and transaction_detail_declare.Commission > 0
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		;
	

	

		/* TPC Return */

		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varTPCType,1,0,concat(varNumberTypeWords,' TPC'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			

		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varTPCId
		,0,varShiftId
		,varTransactionDate
		,varTPCType
		,ifnull((
			select ifnull((
			sum(ifnull((transaction_detail_declare.Amount * ((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)
			) )/100,0)
						)
			),0)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			inner join third_party_commission on third_party_commission.LedgerId = transaction_declare.LedgerId  and third_party_commission.RecordStatus != 'D'
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and ledger.TPCommission = 'YES'
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,third_party_commission.CommissionLedgerId
		,0,varShiftId
		,varTransactionDate
		,varTPCType
		,ifnull((
			sum(ifnull((transaction_detail_declare.Amount * ((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)
			) )/100,0)
						)
		),0)
		,'Cr'
		,varTPCId
		
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction_declare.LedgerId
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			inner join third_party_commission on third_party_commission.LedgerId = transaction_declare.LedgerId  and third_party_commission.RecordStatus != 'D'
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and ledger.TPCommission = 'YES'
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		group by third_party_commission.CommissionLedgerId,transaction_declare.LedgerId ,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		having ifnull((
			sum(ifnull((transaction_detail_declare.Amount * (Commission
			) )/100,0)
						)
		),0) != 0
		;

		/* Hissa Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varHissaType,1,0,concat(varNumberTypeWords,' Sale Hissa'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varHissaId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,ifnull((
			select 
				sum((	
					(transaction_detail_declare.FinalAmount)
					- (transaction_detail_declare.FinalAmount
					*((ifnull(
							transaction_declare.SelfHissa
					,0)/100))
					)
				)*((ifnull(
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = transaction_declare.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				,0)/100)))

				+ sum(transaction_detail_declare.FinalAmount
				*((ifnull(
						transaction_declare.SelfHissa
				,0)/100))
				)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		/* self Hissa*/
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,sum((transaction_detail_declare.FinalAmount *
		ifnull((transaction_declare.SelfHissa),0))/100)
		,'Cr'
		,varHissaId
		
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction_declare.LedgerId
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			#inner join hissa on  hissa.RecordStatus!='D' and hissa.LedgerId = transaction_declare.LedgerId  and hissa.LedgerId = hissa.HissaLedgerId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		having sum(transaction_detail_declare.FinalAmount *
		ifnull((transaction_declare.SelfHissa),0))!=0
		;
		/* Other Hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,HissaLedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,sum((
		
		( 
		(transaction_detail_declare.FinalAmount)
			- (transaction_detail_declare.FinalAmount
			*((ifnull(
					transaction_declare.SelfHissa
			,0)/100))
			)		
		)
		
		*
		ifnull((hissa.Hissa),0))/100)
		,'Cr'
		,varHissaId
		
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction_declare.LedgerId
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			inner join hissa on  hissa.RecordStatus!='D' and hissa.LedgerId = transaction_declare.LedgerId  and hissa.LedgerId != hissa.HissaLedgerId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		group by hissa.HissaLedgerId,transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		having sum(transaction_detail_declare.FinalAmount *
		ifnull((hissa.Hissa),0))!=0
		;
		
		

		/* Profit Hissa */
	
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varHissaProfitType,1,0,concat(varNumberTypeWords,' Profit Hissa'),1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varHissaProfitId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,ifnull((
			select 
				sum((	
					(transaction_detail_declare.Rate * transaction_detail_declare.Amount)
					- (transaction_detail_declare.Rate * transaction_detail_declare.Amount
					*(ifnull((
							transaction_declare.SelfHissa
					/100),0))
					)
				)*(ifnull((
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = transaction_declare.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				/100),0)))

				+ sum(transaction_detail_declare.Rate * transaction_detail_declare.Amount
				*(ifnull((
						transaction_declare.SelfHissa
				/100),0))
				)

			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		/*  Self Hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,sum(((transaction_detail_declare.Rate * transaction_detail_declare.Amount) *
		ifnull((transaction_declare.SelfHissa),0))/100)
		,'Dr'
		,varHissaProfitId
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction_declare.LedgerId
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			#inner join hissa on hissa.RecordStatus!='D' and  hissa.LedgerId = transaction_declare.LedgerId  and hissa.LedgerId = hissa.HissaLedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId 
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		having sum((transaction_detail_declare.Rate * transaction_detail_declare.Amount) *
		ifnull((transaction_declare.SelfHissa),0)) != 0
		;
		/*  Other Hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,hissa.HissaLedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,sum(((
		
		
		(transaction_detail_declare.Rate * transaction_detail_declare.Amount)
			- (transaction_detail_declare.Rate * transaction_detail_declare.Amount
			*(ifnull((
					transaction_declare.SelfHissa
			/100),0))
			)		
		
		
		) *
		ifnull((hissa.Hissa),0))/100)
		,'Dr'
		,varHissaProfitId
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction_declare.LedgerId
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			inner join hissa on hissa.RecordStatus!='D' and  hissa.LedgerId = transaction_declare.LedgerId  and hissa.LedgerId != hissa.HissaLedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId 
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		group by hissa.HissaLedgerId,transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		having sum((transaction_detail_declare.Rate * transaction_detail_declare.Amount) *
		ifnull((hissa.Hissa),0)) != 0
		;
		
		set varNumberType = varNumberType + 1;
	end while;
	
	set varNumberType = 1;
	#and transaction.TransactionMode = 1 Khai = 1 Lagai = 0 not using yet 
	#From here downwords is Lagai process

	while varNumberType <= 3 Do

		IF varNumberType = 1 THEN 
			set varNumberTypeWords = 'Dada';
			set varSaleType = 22;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 26;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 29;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 29;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		ELSEIF varNumberType = 2 THEN 
			set varNumberTypeWords = 'Bahar Ka Akhar';
			set varSaleType = 23;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 27;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 30;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 30;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		ELSEIF varNumberType = 3 THEN 
			set varNumberTypeWords = 'Andar Ka Akhar';
			set varSaleType = 24;
			set varSaleId = 1002;

			SELECT LedgerId into varSaleId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varProfitType = 28;
			set varProfitId = 1001;

			SELECT LedgerId into varProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varCommitionType = 25;
			set varCommitionId = 1006;
			
			SELECT LedgerId into varCommitionId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			
			set varHissaType = 31;
			set varHissaId = 1002;
			
			SELECT LedgerId into varHissaId FROM ledger
			where ledger.LedgerName = 'MANDI SALE A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;

			set varHissaProfitType = 31;
			set varHissaProfitId = 1001;

			SELECT LedgerId into varHissaProfitId FROM ledger
			where ledger.LedgerName = 'MANDI P&L A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
			set varTPCType = 32;
			set varTPCId = 1006;

			SELECT LedgerId into varTPCId FROM ledger
			where ledger.LedgerName = 'MANDI COMMISSION A/C' 
			#and ledger.OrganizationId = varOrganizationId
			;
		end if;

		/*     Sale Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varSaleType,1,0,concat(varNumberTypeWords,' Sale'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
  
		set VoucherId = LAST_INSERT_ID();


		
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varSaleId
		,0,varShiftId
		,varTransactionDate
		,varSaleType
		,ifnull((
			select ifnull(sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount ,0 )),0)
						),0)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varSaleType
		,ifnull((
			sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount ,0 )),0)
						)
		),0)
		,'Cr'
		,varSaleId		
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		;

	

	
		/* Profit Voucher */

		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varProfitType,1,0,concat(varNumberTypeWords,' Profit'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varProfitId
		,0,varShiftId
		,varTransactionDate
		,varProfitType
		,ifnull((
			select sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount * Rate ,0 )),0)
						)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		),0)
		,'Cr'
		,ifnull((
			select sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount ,0 )),0)
						)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		),0)
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		
		;


		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varProfitType
		,ifnull((
			sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount * Rate ,0 )),0)
						)
		),0)
		,'Dr'
		,varProfitId
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,ifnull((
			sum(ifnull((if( transaction_declare.RecordStatus != 'D'  and  transaction_detail_declare.RecordStatus != 'D' ,Amount ,0 )),0)
						)
		),0)
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
		
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
			
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		;
	

	
		/*Commission Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varCommitionType,1,0,concat(varNumberTypeWords,' Comm.'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varCommitionId
		,0,varShiftId
		,varTransactionDate
		,varCommitionType
		,ifnull((
			select sum(ifnull((transaction_detail_declare.Amount * (transaction_detail_declare.Commission - 
			(case when TPCommission = 'No' then 0 else ifnull((SELECT sum(case when varNumberType = 1 then CommissionDara else CommissionAkhar end) FROM third_party_commission where third_party_commission.LedgerId = transaction_declare.LedgerId and third_party_commission.RecordStatus != 'D'),0) end)
			) )/100,0)
						)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varCommitionType
		,ifnull((
			sum(ifnull((transaction_detail_declare.Amount * (transaction_detail_declare.Commission - 
			(case when TPCommission = 'No' then 0 else ifnull((SELECT sum((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)) FROM third_party_commission where third_party_commission.LedgerId = transaction_declare.LedgerId and third_party_commission.RecordStatus != 'D'),0) end)
			) )/100,0)
						)
		),0)
		,'Dr'
		,varCommitionId
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
		
		from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and transaction_detail_declare.Commission > 0
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		;
	

		/*Tax Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varTaxType,1,0,concat(varNumberTypeWords,' Tax'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varTaxId
		,0,varShiftId
		,varTransactionDate
		,varTaxType
		,ifnull((
			select sum(ifnull((transaction_detail_declare.Amount * (transaction_detail_declare.Tax 
			) )/100,0)
						)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varTaxType
		,ifnull((
			sum(ifnull((transaction_detail_declare.Amount * (transaction_detail_declare.Tax 
			) )/100,0)
						)
		),0)
		,'Cr'
		,varTaxId
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',0
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
		
		from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		;
	

	
	

		/* TPC Return */

		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varTPCType,1,0,concat(varNumberTypeWords,' TPC'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			

		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varTPCId
		,0,varShiftId
		,varTransactionDate
		,varTPCType
		,ifnull((
			select ifnull((
			sum(ifnull((transaction_detail_declare.Amount * ((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)
			) )/100,0)
						)
			),0)
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			inner join third_party_commission on third_party_commission.LedgerId = transaction_declare.LedgerId  and third_party_commission.RecordStatus != 'D'
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and ledger.TPCommission = 'YES'
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,third_party_commission.CommissionLedgerId
		,0,varShiftId
		,varTransactionDate
		,varTPCType
		,ifnull((
			sum(ifnull((transaction_detail_declare.Amount * ((case when varNumberType = 1 then CommissionDara else CommissionAkhar end)
			) )/100,0)
						)
		),0)
		,'Dr'
		,varTPCId
		
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction_declare.LedgerId
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			inner join third_party_commission on third_party_commission.LedgerId = transaction_declare.LedgerId  and third_party_commission.RecordStatus != 'D'
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and ledger.TPCommission = 'YES'
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		group by third_party_commission.CommissionLedgerId,transaction_declare.LedgerId ,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		having ifnull((
			sum(ifnull((transaction_detail_declare.Amount * (Commission
			) )/100,0)
						)
		),0) != 0
		;

		/* Hissa Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varHissaType,1,0,concat(varNumberTypeWords,' Sale Hissa'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varHissaId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,ifnull((
			select 
				sum((	
					(transaction_detail_declare.FinalAmount)
					- (transaction_detail_declare.FinalAmount
					*(ifnull((
							transaction_declare.SelfHissa
					/100),0))
					)
				)*(ifnull((
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = transaction_declare.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				/100),0)))

				+ sum(transaction_detail_declare.FinalAmount
				*(ifnull((
						transaction_declare.SelfHissa
				/100),0))
				)

			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		),0)
		,'Cr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
		/*    Self Hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,sum((transaction_detail_declare.FinalAmount *
		ifnull((transaction_declare.SelfHissa),0))/100)
		,'Dr'
		,varHissaId
		
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction_declare.LedgerId
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			#inner join hissa on hissa.RecordStatus!='D' and  hissa.LedgerId = transaction_declare.LedgerId  and hissa.LedgerId = hissa.HissaLedgerId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		having sum(transaction_detail_declare.FinalAmount *
		ifnull((transaction_declare.SelfHissa),0))!=0
		;
		/*    Other Hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,HissaLedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaType
		,sum(((
		
		
		 
		(transaction_detail_declare.FinalAmount)
			- (transaction_detail_declare.FinalAmount
			*(ifnull((
					transaction_declare.SelfHissa
			/100),0))
			)		
		
		)
		*
		ifnull((hissa.Hissa),0))/100)
		,'Dr'
		,varHissaId
		
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction_declare.LedgerId
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			inner join hissa on hissa.RecordStatus!='D' and  hissa.LedgerId = transaction_declare.LedgerId  and hissa.LedgerId != hissa.HissaLedgerId
			left join ledger on ledger.LedgerId = transaction_declare.LedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
		group by hissa.HissaLedgerId,transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		having sum(transaction_detail_declare.FinalAmount *
		ifnull((hissa.Hissa),0))!=0
		;
		
		

		/* Profit Hissa */
	
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varHissaProfitType,1,0,concat(varNumberTypeWords,' Profit Hissa'),0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		set VoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varHissaProfitId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,ifnull((
			select 
				sum((	
					(transaction_detail_declare.Rate * transaction_detail_declare.Amount)
					- (transaction_detail_declare.Rate * transaction_detail_declare.Amount
					*(ifnull((
							transaction_declare.SelfHissa
					/100),0))
					)
				)*(ifnull((
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = transaction_declare.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				/100),0)))

				+ sum((transaction_detail_declare.Rate * transaction_detail_declare.Amount)
				*(ifnull((
						transaction_declare.SelfHissa
				/100),0))
				)

			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		),0)
		,'Dr'
		,0
		,'','',0,0
		,'False','AUTO',0
		,0
		,'SERVER',CURRENT_TIMESTAMP()
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		/* Self Hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,transaction_declare.LedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,sum(((transaction_detail_declare.Rate * transaction_detail_declare.Amount) *
		ifnull((transaction_declare.SelfHissa),0))/100)
		,'Cr'
		,varHissaProfitId
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction_declare.LedgerId
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			#inner join hissa on hissa.RecordStatus!='D' and hissa.LedgerId = transaction_declare.LedgerId  and hissa.LedgerId = hissa.HissaLedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId 
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		group by transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		having sum((transaction_detail_declare.Rate * transaction_detail_declare.Amount) *
		ifnull((transaction_declare.SelfHissa),0)) != 0
		;
		/* Other Hissa */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,VerifyBy,VerifyDate
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,hissa.HissaLedgerId
		,0,varShiftId
		,varTransactionDate
		,varHissaProfitType
		,sum(((
		
		
		
		(transaction_detail_declare.Rate * transaction_detail_declare.Amount)
			- (transaction_detail_declare.Rate * transaction_detail_declare.Amount
			*(ifnull((
					transaction_declare.SelfHissa
			/100),0))
			)		
		
		
		) 
		*
		ifnull((hissa.Hissa),0))/100)
		,'Cr'
		,varHissaProfitId
		,'',CONCAT(convert(transaction_declare.DaraRate,char),'/',convert(transaction_declare.DaraCommission,char),'-',convert(transaction_declare.AkharRate,char),'/',convert(transaction_declare.AkharCommission,char)),SelfHissa,OtherHissa
		,'False','AUTO',transaction_declare.LedgerId
		,0
		,(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then 'SERVER' else null end),(case when varAddedDate > max(transaction_detail_declare.UpdatedDate) then CURRENT_TIMESTAMP() else null end)
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			inner join hissa on hissa.RecordStatus!='D' and hissa.LedgerId = transaction_declare.LedgerId  and hissa.LedgerId != hissa.HissaLedgerId
			where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.TransactionMode = 0 
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId 
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			and transaction_detail_declare.NumberType = varNumberType
			and ((transaction_detail_declare.Number = varDeclareNumber and varNumberType = 1 )
				or (transaction_detail_declare.Number = right(lpad ((varDeclareNumber mod 10) * 111 ,3,"0"),3) and varNumberType = 2 )
				or (transaction_detail_declare.Number = right(lpad ((floor((varDeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) and varNumberType = 3 )
				)
		group by hissa.HissaLedgerId,transaction_declare.LedgerId,transaction_declare.DaraRate,transaction_declare.DaraCommission,transaction_declare.AkharRate,transaction_declare.AkharCommission
		having sum((transaction_detail_declare.Rate * transaction_detail_declare.Amount) *
		ifnull((hissa.Hissa),0)) != 0
		;
		
		set varNumberType = varNumberType + 1;
	end while;
	
/*
	update shift set 
	ShiftDate = '1970-01-01' 
	where ShiftId = varShiftId
	and OrganizationId = varOrganizationId
	;
	
	Insert into declare_result(DeclareDate,ShiftId,OrganizationId,DeclareNumber,IsNeeded
	,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
	Values(varTransactionDate, varShiftId,varOrganizationId, varDeclareNumber,  'No'
	,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
	;

	update transaction_detail_declare set UpdateLimitFlag = 0 
	where TransactionId in (select transaction_declare.TransactionId 
			from transaction_declare where transaction_declare.TransactionDate = varTransactionDate
			and transaction_declare.ShiftId = varShiftId 
			and transaction_declare.OrganizationId = varOrganizationId 
			and transaction_declare.RecordStatus!='D')
	;
*/

	update declare_result set IsNeeded = 'No'
	,ReDeclareNos = ReDeclareNos + 1
	where DeclareDate = varTransactionDate 
	and ShiftId = varShiftId
	and OrganizationId = varOrganizationId
	and RecordStatus <> 'D'
	;
	


end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `declare_process_Undeclare`(
in varOrganizationId bigint(21)
,in varShiftId bigint(21)
,in varDeclareNumber smallint(6)
,in varTransactionDate DATE
)
begin

	/*
	delete from voucher_detail where VoucherId in (select voucher.VoucherId from voucher 
		where voucher.OrganizationId = varOrganizationId and voucher.ShiftId = varShiftId and voucher.VoucherDate = varTransactionDate);
	*/
	delete from voucher_detail where OrganizationId = varOrganizationId and ShiftId = varShiftId and VoucherDate = varTransactionDate;

	delete from voucher 
		where OrganizationId = varOrganizationId and ShiftId = varShiftId and VoucherDate = varTransactionDate;

	
	INSERT INTO transaction
	(TransactionId,
	OrganizationId,
	ShiftId,
	LedgerId,
	TransactionDate,
	TransactionMode,
	TransactionType,
	KFlag,
	EntryType,
	ClientRemarks,
	IsHissa,
	SelfHissa,
	OtherHissa,
	DaraRate,
	DaraCommission,
	AkharRate,
	AkharCommission,
	Tax,
	TotalAmount,
	TotalCommission,
	TotalTax,
	FinalAmount,
	TransactionStartTime,
	DeviceType,
	RecordStatus,
	AddedBy,
	AddedDate,
	UpdatedBy,
	UpdatedDate)

	SELECT TransactionId,
		OrganizationId,
		ShiftId,
		LedgerId,
		TransactionDate,
		TransactionMode,
		TransactionType,
		KFlag,
		EntryType,
		ClientRemarks,
		IsHissa,
		SelfHissa,
		OtherHissa,
		DaraRate,
		DaraCommission,
		AkharRate,
		AkharCommission,
		Tax,
		TotalAmount,
		TotalCommission,
		TotalTax,
		FinalAmount,
		TransactionStartTime,
		DeviceType,
		RecordStatus,
		AddedBy,
		AddedDate,
		UpdatedBy,
		UpdatedDate
	FROM transaction_declare
	where ShiftId = varShiftId
	and transaction_declare.TransactionDate = varTransactionDate
	and transaction_declare.OrganizationId = varOrganizationId
	;
	
	INSERT INTO transaction_detail
	(TransactionDetailId,
	TransactionId,
	OrganizationId,
	Number,
	NumberType,
	Amount,
	Rate,
	Commission,
	Tax,
	FinalAmount,
	OrderNumber,
	RecordStatus,
	AddedBy,
	AddedDate,
	UpdatedBy,
	UpdatedDate)

	SELECT TransactionDetailId,
		TransactionId,
		OrganizationId,
		Number,
		NumberType,
		Amount,
		Rate,
		Commission,
		Tax,
		FinalAmount,
		OrderNumber,
		RecordStatus,
		AddedBy,
		AddedDate,
		UpdatedBy,
		UpdatedDate
	FROM transaction_detail_declare
	where TransactionId in (select transaction_declare.TransactionId from 
		transaction_declare 
		where ShiftId = varShiftId
		and transaction_declare.TransactionDate = varTransactionDate
		and transaction_declare.OrganizationId = varOrganizationId)
	;
	
	delete from transaction_detail_declare 
	where TransactionId in (select transaction_declare.TransactionId from 
		transaction_declare 
		where ShiftId = varShiftId
		and transaction_declare.TransactionDate = varTransactionDate
		and transaction_declare.OrganizationId = varOrganizationId)
	;

	delete from transaction_declare 
	where ShiftId = varShiftId
	and transaction_declare.TransactionDate = varTransactionDate
	and transaction_declare.OrganizationId = varOrganizationId
	;
	
	update shift set 
	ShiftDate = varTransactionDate 
	where ShiftId = varShiftId
	and OrganizationId = varOrganizationId
	;
	
	delete from declare_result where DeclareDate = varTransactionDate and ShiftId = varShiftId and OrganizationId = varOrganizationId 
	;



end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `declare_transaction_all_of_organization`(
IN varOrganizationId int(20)
, IN varShiftId int(20)
, IN varShiftDate DATE
, IN varLedgerId int(20)
, IN varUserName varchar(100)
, IN varRoleId int(20)
, IN varRoleType varchar(20)
, IN varLedgerName varchar(50)
, IN varIsDeleted int(20)
)
begin
# RoleId = 2 super admin, 3 distributer,4 ressaler ,5 panter
case varRoleId 
	when 3 then
		
		select t.* ,
		ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
		ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
		ifnull(transaction_audit.LastStatus,0) LastStatus,
		ifnull(transaction_audit.Remark,'') Remark
		from
			(
			select convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
			, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa
			, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				t.TransactionDate , 
				t.AddedDate, 
				t.UpdatedDate
			,t.AddedBy
			,IsUpdated
			,DeclareNumber
			,UpdateDiff
			,max(IsDada) as IsDada
			,max(IsBAkar) as IsBAkar
			,max(IsAAkar) as IsAAkar
			,t.AddedDayTime
			,t.UpdatedDayTime
			,t.RecordStatus as RecordStatus
			,t.OrderAddeddate
			,t.ClientRemarks
			
			from (
				SELECT t.TransactionId, t.OrganizationId, t.LedgerId, l.LedgerName, t.ShiftId, t.TotalAmount
				, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa
				, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
					date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
					date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
					date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
				,t.AddedBy
				,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
				,DeclareNumber
				,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
				,(case when td.Number = d.DeclareNumber then 1 else 0 end ) as IsDada
				,(case when td.Number = right(lpad ((d.DeclareNumber mod 10) * 111 ,3,"0"),3) then 1 else 0 end ) as IsBAkar
				,(case when td.Number = right(lpad ((floor((d.DeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) then 1 else 0 end ) as IsAAkar
				,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
				,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
				,t.RecordStatus as RecordStatus
				,t.AddedDate as OrderAddeddate
				,t.ClientRemarks
				
				FROM transaction_declare t
					inner join transaction_detail_declare td on td.TransactionId = t.TransactionId
					inner join ledger l on t.LedgerId = l.LedgerId
					inner join `declare_result` as d on d.RecordStatus != 'D' and d.DeclareDate = t.TransactionDate and d.ShiftId = t.ShiftId and d.OrganizationId = varOrganizationId
					where t.OrganizationId = varOrganizationId
					and t.ShiftId = varShiftId
					and t.TransactionDate = varShiftDate
					and (case when varIsDeleted = 1 then t.RecordStatus = 'D' else t.RecordStatus != 'D' end)
					and (t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
					and (varRoleType = 'ALL' 
						or t.UpdatedBy  = varUserName
						)
					and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
				) as t
			group by t.TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
			, t.UpdatedBy, t.TransactionDate , t.TransactionType, t.KFlag, t.IsHissa
			, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				t.TransactionDate, 
				t.AddedDate, 
				t.UpdatedDate
			,t.AddedBy
			,DeclareNumber
			,IsUpdated
			,UpdateDiff
			,t.RecordStatus 
			,t.OrderAddeddate
			,t.ClientRemarks
		) as t
		left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
		order by t.OrderAddeddate desc;
			
	when 4 then
		
		select t.* ,
		ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
		ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
		ifnull(transaction_audit.LastStatus,0) LastStatus,
		ifnull(transaction_audit.Remark,'') Remark
		from
			(
			select convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
			, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa
			, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				t.TransactionDate , 
				t.AddedDate, 
				t.UpdatedDate
			,t.AddedBy
			,IsUpdated
			,DeclareNumber
			,UpdateDiff
			,max(IsDada) as IsDada
			,max(IsBAkar) as IsBAkar
			,max(IsAAkar) as IsAAkar
			,t.AddedDayTime
			,t.UpdatedDayTime
			,t.RecordStatus as RecordStatus
			,t.OrderAddeddate
			,t.ClientRemarks
			
			from (
			
				SELECT t.TransactionId, t.OrganizationId, t.LedgerId, l.LedgerName, t.ShiftId, t.TotalAmount, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
					date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
					date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
					date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
					,t.AddedBy
					,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
					,DeclareNumber
					,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
					,(case when td.Number = d.DeclareNumber then 1 else 0 end ) as IsDada
					,(case when td.Number = right(lpad ((d.DeclareNumber mod 10) * 111 ,3,"0"),3) then 1 else 0 end ) as IsBAkar
					,(case when td.Number = right(lpad ((floor((d.DeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) then 1 else 0 end ) as IsAAkar
					,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
					,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
					,t.RecordStatus as RecordStatus
					,t.AddedDate as OrderAddeddate
					,t.ClientRemarks
					
					FROM transaction_declare t
					inner join transaction_detail_declare td on td.TransactionId = t.TransactionId
					join ledger l on t.LedgerId = l.LedgerId
					inner join `declare_result` as d on d.DeclareDate = t.TransactionDate and d.ShiftId = t.ShiftId and d.OrganizationId = varOrganizationId
					where t.OrganizationId = varOrganizationId
					and t.ShiftId = varShiftId
					and t.TransactionDate = varShiftDate
					and (case when varIsDeleted = 1 then t.RecordStatus = 'D' else t.RecordStatus != 'D' end)
					and (t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId)
					and (varRoleType = 'ALL' 
						or t.UpdatedBy  = varUserName
						)
					and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
				) as t
			group by t.TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
			, t.UpdatedBy, t.TransactionDate , t.TransactionType, t.KFlag, t.IsHissa
			, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				t.TransactionDate, 
				t.AddedDate, 
				t.UpdatedDate
			,t.AddedBy
			,DeclareNumber
			,IsUpdated
			,UpdateDiff
			,t.RecordStatus
			,t.OrderAddeddate
			,t.ClientRemarks
		) as t
		left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
		order by t.OrderAddeddate desc;
			

	when 5 then
		select t.* ,
		ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
		ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
		ifnull(transaction_audit.LastStatus,0) LastStatus,
		ifnull(transaction_audit.Remark,'') Remark
		from
			(
			select convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
			, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa
			, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				t.TransactionDate , 
				t.AddedDate, 
				t.UpdatedDate
			,t.AddedBy
			,IsUpdated
			,DeclareNumber
			,UpdateDiff
			,max(IsDada) as IsDada
			,max(IsBAkar) as IsBAkar
			,max(IsAAkar) as IsAAkar
			,t.AddedDayTime
			,t.UpdatedDayTime
			,t.RecordStatus as RecordStatus
			,t.OrderAddeddate
			,t.ClientRemarks
			
			from (
			

				SELECT t.TransactionId, t.OrganizationId, t.LedgerId, l.LedgerName, t.ShiftId, t.TotalAmount, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
					date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
					date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
					date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
					,t.AddedBy
					,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
					,DeclareNumber
					,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
					,(case when td.Number = d.DeclareNumber then 1 else 0 end ) as IsDada
					,(case when td.Number = right(lpad ((d.DeclareNumber mod 10) * 111 ,3,"0"),3) then 1 else 0 end ) as IsBAkar
					,(case when td.Number = right(lpad ((floor((d.DeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) then 1 else 0 end ) as IsAAkar
					,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
					,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
					,t.RecordStatus as RecordStatus
					,t.AddedDate as OrderAddeddate
					,t.ClientRemarks
					
					FROM transaction_declare t
					inner join transaction_detail_declare td on td.TransactionId = t.TransactionId
					join ledger l on t.LedgerId = l.LedgerId
					inner join `declare_result` as d on d.DeclareDate = t.TransactionDate and d.ShiftId = t.ShiftId and d.OrganizationId = varOrganizationId
					where t.OrganizationId = varOrganizationId
					and t.ShiftId = varShiftId
					and t.TransactionDate = varShiftDate
					and (case when varIsDeleted = 1 then t.RecordStatus = 'D' else t.RecordStatus != 'D' end)
					and t.LedgerId = varLedgerId
					and (varRoleType = 'ALL' 
						or t.UpdatedBy  = varUserName
						)
					and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
				) as t
			group by t.TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
			, t.UpdatedBy, t.TransactionDate , t.TransactionType, t.KFlag, t.IsHissa
			, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				t.TransactionDate, 
				t.AddedDate, 
				t.UpdatedDate
			,t.AddedBy
			,DeclareNumber
			,IsUpdated
			,UpdateDiff
			,t.RecordStatus 
			,t.OrderAddeddate
			,t.ClientRemarks
			
		) as t
		left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
		order by t.OrderAddeddate desc;
	else
		
		case when (select ifnull(IsDeclareTransactionConfig,0) from role where role.OrganizationId = varOrganizationId and role.RoleId = varRoleId) = 1 then
			select t.* ,
			ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
			ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
			ifnull(transaction_audit.LastStatus,0) LastStatus,
			ifnull(transaction_audit.Remark,'') Remark
			from
				(
				select convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
				, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa
				, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
					t.TransactionDate , 
					t.AddedDate, 
					t.UpdatedDate
				,t.AddedBy
				,IsUpdated
				,DeclareNumber
				,UpdateDiff
				,max(IsDada) as IsDada
				,max(IsBAkar) as IsBAkar
				,max(IsAAkar) as IsAAkar
				,t.AddedDayTime
				,t.UpdatedDayTime
				,t.RecordStatus as RecordStatus
				,t.OrderAddeddate
				,t.ClientRemarks
				
				from (
						SELECT t.TransactionId, t.OrganizationId, t.LedgerId, l.LedgerName, t.ShiftId, t.TotalAmount, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
							date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
							date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
							date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
							,t.AddedBy
							,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
							,DeclareNumber
							,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
							,(case when td.Number = d.DeclareNumber then 1 else 0 end ) as IsDada
							,(case when td.Number = right(lpad ((d.DeclareNumber mod 10) * 111 ,3,"0"),3) then 1 else 0 end ) as IsBAkar
							,(case when td.Number = right(lpad ((floor((d.DeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) then 1 else 0 end ) as IsAAkar
							,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
							,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
							,t.RecordStatus as RecordStatus
							,t.AddedDate as OrderAddeddate
							,t.ClientRemarks
							
							FROM transaction_declare t
							inner join transaction_detail_declare td on td.TransactionId = t.TransactionId
							join ledger l on t.LedgerId = l.LedgerId
							inner join `declare_result` as d on d.DeclareDate = t.TransactionDate and d.ShiftId = t.ShiftId and d.OrganizationId = varOrganizationId

							inner join(
							select role_permission_transaction.ExpiryDateTime,role_permission_transaction.DataViewMode,role_permission_transaction.ViewType,role_permission_transaction.ShiftId,role_permission_transaction.ShiftDate,login.UserName from role_permission_transaction 
							join login on login.LoginId = role_permission_transaction.LoginId
							where login.UserName = varUserName 
							and role_permission_transaction.OrganizationId = varOrganizationId
							and role_permission_transaction.ShiftId = varShiftId
							and role_permission_transaction.RecordStatus != 'D'
							and ifnull(role_permission_transaction.IsPageAllow,0) = 1
							) as r_p_t on r_p_t.ShiftId = t.ShiftId 
							and r_p_t.ShiftDate = t.TransactionDate
							and (case when r_p_t.DataViewMode = 1 then t.AddedDate < d.AddedDate when r_p_t.DataViewMode = 2 then t.AddedDate >= d.AddedDate else true end)
							and (case when r_p_t.ViewType = '1' then r_p_t.UserName = t.UpdatedBy else true end)

							where t.OrganizationId = varOrganizationId
							and t.ShiftId = varShiftId
							and t.TransactionDate = varShiftDate
							and (case when varIsDeleted = 1 then t.RecordStatus = 'D' else t.RecordStatus != 'D' end)
							and (varRoleType = 'ALL' 
								or t.UpdatedBy  = varUserName
								)
							and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
					) as t
				group by t.TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
				, t.UpdatedBy, t.TransactionDate , t.TransactionType, t.KFlag, t.IsHissa
				, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
					t.TransactionDate, 
					t.AddedDate, 
					t.UpdatedDate
				,t.AddedBy
				,DeclareNumber
				,IsUpdated
				,UpdateDiff
				,t.RecordStatus 
				,t.OrderAddeddate
				,t.ClientRemarks
				
			) as t
			left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
			order by t.OrderAddeddate desc;

		else
			select t.* ,
			ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
			ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
			ifnull(transaction_audit.LastStatus,0) LastStatus,
			ifnull(transaction_audit.Remark,'') Remark
			from
				(
				select convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
				, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa
				, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
					t.TransactionDate , 
					t.AddedDate, 
					t.UpdatedDate
				,t.AddedBy
				,IsUpdated
				,DeclareNumber
				,UpdateDiff
				,max(IsDada) as IsDada
				,max(IsBAkar) as IsBAkar
				,max(IsAAkar) as IsAAkar
				,t.AddedDayTime
				,t.UpdatedDayTime
				,t.RecordStatus as RecordStatus
				,t.OrderAddeddate
				,t.ClientRemarks
				
				from (
				
						SELECT t.TransactionId, t.OrganizationId, t.LedgerId, l.LedgerName, t.ShiftId, t.TotalAmount, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
							date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
							date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
							date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
							,t.AddedBy
							,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
							,DeclareNumber
							,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
							,(case when td.Number = d.DeclareNumber then 1 else 0 end ) as IsDada
							,(case when td.Number = right(lpad ((d.DeclareNumber mod 10) * 111 ,3,"0"),3) then 1 else 0 end ) as IsBAkar
							,(case when td.Number = right(lpad ((floor((d.DeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) then 1 else 0 end ) as IsAAkar
							,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
							,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
							,t.RecordStatus as RecordStatus
							,t.AddedDate as OrderAddeddate
							,t.ClientRemarks
							
							FROM transaction_declare t
							inner join transaction_detail_declare td on td.TransactionId = t.TransactionId
							join ledger l on t.LedgerId = l.LedgerId
							inner join `declare_result` as d on d.DeclareDate = t.TransactionDate and d.ShiftId = t.ShiftId and d.OrganizationId = varOrganizationId
							where t.OrganizationId = varOrganizationId
							and t.ShiftId = varShiftId
							and t.TransactionDate = varShiftDate
							and (case when varIsDeleted = 1 then t.RecordStatus = 'D' else t.RecordStatus != 'D' end)
							and (varRoleType = 'ALL' 
								or t.UpdatedBy  = varUserName
								)
							and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
					) as t
				group by t.TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
				, t.UpdatedBy, t.TransactionDate , t.TransactionType, t.KFlag, t.IsHissa
				, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
					t.TransactionDate, 
					t.AddedDate, 
					t.UpdatedDate
				,t.AddedBy
				,DeclareNumber
				,IsUpdated
				,UpdateDiff
				,t.RecordStatus 
				,t.OrderAddeddate
				,t.ClientRemarks
				
			) as t
			left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
			order by t.OrderAddeddate desc;
		end case;
	end case;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `declare_transaction_audit_all_of_organization`(
IN varOrganizationId int(20)
, IN varShiftId int(20)
, IN varShiftDate DATE
 ,in varIsAudit int 
 ,in varMistakeStatus int
 ,in varModifyStatus int
 ,IN varLedgerName varchar(50)
)
begin
		
		select t.* ,l.LedgerName ,shift.ShiftName
		,ifnull(transaction_audit.TransactionAuditId,0) TransactionAuditId
		,ifnull(transaction_audit.Amount,0) Amount,
		ifnull(transaction_audit.AmountUpdated,0) AmountUpdated,
		ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
		ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
		ifnull(transaction_audit.LastStatus,0) LastStatus,
		ifnull(transaction_audit.Remark,'') Remark,
		ifnull(transaction_audit.AddedBy,'') AddedByAudit,
		ifnull(transaction_audit.AddedDate,'1970-01-01 00:00:00') AddedDateAudit,
		ifnull(transaction_audit.UpdatedBy,'') UpdatedByAudit,
		ifnull(transaction_audit.UpdatedDate,'1970-01-01 00:00:00') UpdatedDateAudit,
		(case when ifnull(transaction_audit.MistakeStatus,0) = 2 then 1 else 0 end) ReAudit
		from
			(
			select convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId, t.ShiftId, t.TotalAmount
			, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa
			, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				t.TransactionDate , 
				t.AddedDate, 
				t.UpdatedDate
			,t.AddedBy
			,IsUpdated
			,DeclareNumber
			,UpdateDiff
			,max(IsDada) as IsDada
			,max(IsBAkar) as IsBAkar
			,max(IsAAkar) as IsAAkar
			,t.AddedDayTime
			,t.UpdatedDayTime
			,t.OrderAddeddate
			
			from (
				SELECT t.TransactionId, t.OrganizationId, t.LedgerId, t.ShiftId, t.TotalAmount
				, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa
				, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
					date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
					date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
					date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
				,t.AddedBy
				,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
				,DeclareNumber
				,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
				,(case when td.Number = d.DeclareNumber then 1 else 0 end ) as IsDada
				,(case when td.Number = right(lpad ((d.DeclareNumber mod 10) * 111 ,3,"0"),3) then 1 else 0 end ) as IsBAkar
				,(case when td.Number = right(lpad ((floor((d.DeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) then 1 else 0 end ) as IsAAkar
				,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
				,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
				,t.AddedDate as OrderAddeddate
				
				
				FROM transaction_declare t
					inner join transaction_detail_declare td on td.TransactionId = t.TransactionId
					
					inner join `declare_result` as d on d.RecordStatus != 'D' and d.DeclareDate = t.TransactionDate and d.ShiftId = t.ShiftId and d.OrganizationId = varOrganizationId
					where t.OrganizationId = varOrganizationId
					and t.TransactionDate = varShiftDate
					and (ifnull(varShiftId , 0 ) = 0 or t.ShiftId = varShiftId)
					and t.TransactionDate = varShiftDate
					and t.RecordStatus != 'D'

				) as t
			group by t.TransactionId, t.OrganizationId, t.LedgerId, t.ShiftId, t.TotalAmount
			, t.UpdatedBy, t.TransactionDate , t.TransactionType, t.KFlag, t.IsHissa
			, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				t.TransactionDate, 
				t.AddedDate, 
				t.UpdatedDate
			,t.AddedBy
			,DeclareNumber
			,IsUpdated
			,UpdateDiff
			,t.OrderAddeddate
		) as t
		left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
		inner join ledger l on t.LedgerId = l.LedgerId and ifnull(l.ParentLedgerId,0) = 0
		inner join shift on shift.ShiftId = t.ShiftId 
		inner join login on login.UserName = t.AddedBy
		where (case when varIsAudit = 1 then (transaction_audit.TransactionAuditId is null or ifnull(transaction_audit.MistakeStatus,0) = 2) when varIsAudit = 2 then transaction_audit.TransactionAuditId is not null else true end)
		and (ifnull(transaction_audit.MistakeStatus,0) mod 2 = ifnull(varMistakeStatus,0) or ifnull(varMistakeStatus,0) = -1)
		and (transaction_audit.ModifyStatus = ifnull(varModifyStatus,0) or ifnull(varModifyStatus,0) = -1)
		and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
		and login.LoginType not in (3,4,5)
		
		order by t.OrderAddeddate;
			

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `declare_transaction_detail_row_of_organization`(
IN varOrganizationId int(20)
, IN varTransactionId bigint(21)
, IN varLedgerId bigint(21)
, IN varShiftDate DATE
, IN varShiftId bigint(21)
)
SELECT td.*, IF(CHAR_LENGTH(td.Number) = 2, ROUND(td.Number), td.Number) as Number
	FROM transaction_detail_declare td
	join transaction_declare t on td.TransactionId = t.TransactionId
	where td.OrganizationId = varOrganizationId
	and (ifnull(varTransactionId,0) = 0 or td.TransactionId = varTransactionId)
	and (ifnull(varLedgerId,0) = 0 or t.LedgerId = varLedgerId)
	and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
	and t.TransactionDate = varShiftDate
	and td.RecordStatus != 'D'
	and t.RecordStatus != 'D'
    order by td.OrderNumber ASC$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `declare_transaction_narration_row_of_organization`(IN varOrganizationId int(20), IN varTransactionId bigint(21))
SELECT tn.*
	FROM transaction_narration_declare tn
	where tn.OrganizationId = varOrganizationId
	and tn.TransactionId = varTransactionId
	and tn.RecordStatus != 'D'$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `declare_transaction_row_of_organization`(IN varOrganizationId int(20), IN varTransactionId bigint(21))
SELECT t.TransactionId, t.OrganizationId, t.LedgerId
    ,t.SelfHissa
    ,t.OtherHissa
	, l.LedgerName, t.ShiftId, t.TotalAmount, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
	date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
	date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
	date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
	,t.Tax
	
	FROM transaction_declare t
	join ledger l on t.LedgerId = l.LedgerId
	where t.OrganizationId = varOrganizationId
	and t.TransactionId = varTransactionId
	and t.RecordStatus != 'D'
    order by t.UpdatedDate desc$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `dynamic_fair_trade_sel_main_jantri`(
       IN `TransactionDates` DATE,
       IN `varShiftId` BIGINT(21),
	   IN `varOrganizationId` BIGINT(8),
	   IN `varLedgerId` BIGINT(8),
	   IN `varAgentId` bigint(8),
	   IN `varAmountLess` INT,
	   IN `varPercentLess` INT,
	   in `varMultiplyUp` float
)
begin
	declare varRoundBy int;
	
	select organization.RoundOffOnMainJantri into varRoundBy 
		from organization 
		where organization.OrganizationId = varOrganizationId
	;
	
	call dynamic_fair_trade_sel_preductiondata_allnumber(TransactionDates,varShiftId,varOrganizationId,2);
	
	select Number as Number
	,profit
	,
	(case when (select organization.IsMainJantriRoundOf from organization where organization.OrganizationId = varOrganizationId) = 1 then 
		(
			(
			
				(case when 
				round(((  (sum((case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
																else 0 end)
									else NEW_BAL end)
								) * varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0) 
					>0
					then 
				round(((sum(  (case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
																else 0 end)
									else NEW_BAL end)
								) * varMultiplyUp
					- varAmountLess) * (100 - varPercentLess)/100),0) 
					else
						0
					end
				)	
				div varRoundBy
			) * varRoundBy 
			+ IF
			(
				(case when 
				round((((sum((case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
																else 0 end)
									else NEW_BAL end)
								) * varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0) 
					>0
					then 
				round(((sum(  (case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
																else 0 end)
									else NEW_BAL end)
								) * varMultiplyUp
					- varAmountLess) * (100 - varPercentLess)/100),0) 
					else
						0
					end
				)	
				MOD varRoundBy = 0, 0, varRoundBy
			)
		)
	else
		(case when 
		round((((sum((case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
														else 0 end)
							else NEW_BAL end)
						) * varMultiplyUp )
			- varAmountLess) * (100 - varPercentLess)/100),0) 
			>0
			then 
		round(((sum(  (case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
														else 0 end)
							else NEW_BAL end) 
						) * varMultiplyUp
			- varAmountLess) * (100 - varPercentLess)/100),0) 
			else
				0
			end
		)	
	end
	)
	as NEW_BAL
	
    from 
	(
		SELECT SUM(IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)) AS KhaiAmount
		,SUM(IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)) AS LagaiAmount
		,
		sum((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))) as Amount
		
		,(sum(((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)))
		*(((100-ifnull(t.SelfHissa,0))/100))*(((100-ifnull(t.OtherHissa,0))/100))
				)
		 )
		AS NEW_BAL
		,l.DibbaAmount,l.IsDibba
		,mainjantrinumbers.Num  as Number
		,mainjantrinumbers.profit as Profit
		FROM transaction_detail td
		JOIN transaction t ON td.TransactionId = t.TransactionId
		and (t.TransactionMode = 1 or ifnull(varLedgerId,0) != 0)
		and t.TransactionDate = TransactionDates  
		and  t.ShiftId = varShiftId
		and  td.RecordStatus!='D'
		and  t.RecordStatus!='D'
		and (ifnull(varOrganizationId,0) = 0 or t.OrganizationId = varOrganizationId)
		join ledger l on t.LedgerId = l.LedgerId
				right join mainjantrinumbers on td.Number = (case when td.NumberType = 1 then mainjantrinumbers.Num  
						when td.NumberType = 2 then right(lpad ((mainjantrinumbers.Num mod 10) * 111 ,3,"0"),3)
						when td.NumberType = 3 then right(lpad ((floor((mainjantrinumbers.Num/10)) mod 10) * 1111 ,4,"0"),4)
						else -1
						end)
		where 1=1
		and (ifnull(varLedgerId,0) = 0 or t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
		and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
													where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = 31))									
			)
		GROUP BY mainjantrinumbers.Num,mainjantrinumbers.profit,l.DibbaAmount,l.IsDibba
	) as AA
	group by AA.Number
	Order By AA.Number ASC;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `dynamic_fair_trade_sel_main_jantri_declare`(
       IN `TransactionDates` DATE,
       IN `varShiftId` BIGINT(21),
	   IN `varOrganizationId` BIGINT(8),
	   IN `varLedgerId` BIGINT(8),
	   IN `varAgentId` bigint(8),
	   IN `varAmountLess` INT,
	   IN `varPercentLess` INT,
	   in `varMultiplyUp` float
)
begin
	declare varRoundBy int;
	
	select organization.RoundOffOnMainJantri into varRoundBy 
		from organization 
		where organization.OrganizationId = varOrganizationId
	;

	#call dynamic_fair_trade_sel_preductiondata_allnumber_declare(TransactionDates,varShiftId,varOrganizationId,2);

	select Number as Number
	,profit
	,
	(case when (select organization.IsMainJantriRoundOf from organization where organization.OrganizationId = varOrganizationId) = 1 then 
		(
			(
			
				(case when 
				round((((sum((case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
																else 0 end)
									else NEW_BAL end)
								) * varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0) 
					>0
					then 
				round(((sum(  (case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
																else 0 end)
									else NEW_BAL end)
								) * varMultiplyUp
					- varAmountLess) * (100 - varPercentLess)/100),0) 
					else
						0
					end
				)	
				div varRoundBy
			) * varRoundBy 
			+ IF
			(
				(case when 
				round((((sum((case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
																else 0 end)
									else NEW_BAL end)
								) * varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0) 
					>0
					then 
				round(((sum(  (case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
																else 0 end)
									else NEW_BAL end)
								) * varMultiplyUp
					- varAmountLess) * (100 - varPercentLess)/100),0) 
					else
						0
					end
				)	
				MOD varRoundBy = 0, 0, varRoundBy
			)
		)
	else
		(case when 
		round((((sum((case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
														else 0 end)
							else NEW_BAL end)
						) * varMultiplyUp )
			- varAmountLess) * (100 - varPercentLess)/100),0) 
			>0
			then 
		round(((sum(  (case when ifnull(IsDibba,'NO') = 'YES' then (case when NEW_BAL > DibbaAmount then (NEW_BAL - DibbaAmount) 
														else 0 end)
							else NEW_BAL end)
						) * varMultiplyUp
			- varAmountLess) * (100 - varPercentLess)/100),0) 
			else
				0
			end
		)	
	end
	)
	as NEW_BAL
	
    from 
	(
		SELECT SUM(IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)) AS KhaiAmount
		,SUM(IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)) AS LagaiAmount
		,
		sum((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))) as Amount
		
		,(sum(((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)))
		*(((100-ifnull(t.SelfHissa,0))/100))*(((100-ifnull(t.OtherHissa,0))/100))
				)
		 )
		AS NEW_BAL
		,l.DibbaAmount,l.IsDibba
		,mainjantrinumbers.Num  as Number
		,mainjantrinumbers.profit as Profit
		FROM transaction_detail_declare td
		JOIN transaction_declare t ON td.TransactionId = t.TransactionId
		and (t.TransactionMode = 1 or ifnull(varLedgerId,0) != 0)
		and t.TransactionDate = TransactionDates  
		and  t.ShiftId = varShiftId
		and  td.RecordStatus!='D'
		and  t.RecordStatus!='D'
		and (ifnull(varOrganizationId,0) = 0 or t.OrganizationId = varOrganizationId)
		join ledger l on t.LedgerId = l.LedgerId
				right join mainjantrinumbers on td.Number = (case when td.NumberType = 1 then mainjantrinumbers.Num  
						when td.NumberType = 2 then right(lpad ((mainjantrinumbers.Num mod 10) * 111 ,3,"0"),3)
						when td.NumberType = 3 then right(lpad ((floor((mainjantrinumbers.Num/10)) mod 10) * 1111 ,4,"0"),4)
						else -1
						end)
		where 1=1
		and (ifnull(varLedgerId,0) = 0 or t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
		and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
													where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = 31))									
			)
		GROUP BY mainjantrinumbers.Num,mainjantrinumbers.profit,l.DibbaAmount,l.IsDibba
	) as AA
	group by AA.Number
	Order By AA.Number ASC;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `dynamic_fair_trade_sel_preductiondata_allnumber`(
IN `varTransactionDate` DATE, 
IN `varShiftId` BIGINT(8),
IN `varOrganizationId` BIGINT(8),
IN `varIsNotShow` smallint(6) 
)
begin
	declare intRow smallint default 0;
	
		delete from mainjantrinumbersprofit;
		
		set intRow = 1;
		SET @s = CONCAT('insert into mainjantrinumbersprofit(' );
		SET @sTemp = '';
		
		SET @s = CONCAT(@s,'amount',convert(intRow,char));
		
		SET @sTemp = CONCAT(@sTemp,'sum((ifnull((if((Number = ',convert(intRow,char),' or Number = right(lpad ((',convert(intRow,char),' mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((',convert(intRow,char),'/10)) mod 10) * 1111 ,4,"0"),4)) and transaction.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction.TransactionMode = 1 ,transaction_detail.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(transaction.SelfHissa,0))/100))*(((100-ifnull(transaction.OtherHissa,0))/100))
		)as amount',convert(intRow,char),'
		');

		set intRow = intRow + 1;

		while intRow <= 100 Do
			SET @s = CONCAT(@s,',amount',convert(intRow,char));
			
				SET @sTemp = CONCAT(@sTemp,',sum((ifnull((if((Number = ',convert(intRow,char),' or Number = right(lpad ((',convert(intRow,char),' mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((',convert(intRow,char),'/10)) mod 10) * 1111 ,4,"0"),4)) and transaction.TransactionMode = 1 ,Amount * Rate ,0 )),0)
				- ifnull((if(transaction.TransactionMode = 1 ,transaction_detail.FinalAmount ,0 )),0)
				)
				*(((100-ifnull(transaction.SelfHissa,0))/100))*(((100-ifnull(transaction.OtherHissa,0))/100))
				)as amount',convert(intRow,char),'
				');
							
			set intRow = intRow + 1;
		end while;

		SET @s = CONCAT(@s,')

select
		');
		
		SET @sTemp = CONCAT(@sTemp,' 
		from transaction 
		inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
		where transaction.TransactionDate = ''',convert(varTransactionDate,char),'''
		and  transaction.ShiftId = ',convert(varShiftId,char),'
		and  transaction.OrganizationId = ',convert(varOrganizationId,char),'
		and transaction.TransactionMode = 1 
		and transaction.RecordStatus!=''D''
		and transaction_detail.RecordStatus!=''D''
			');

		SET @s = CONCAT(@s,@sTemp);
	   
		PREPARE stmt FROM @s;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;


		set intRow = 1;
		
		while intRow <= 100 Do
			SET @s = CONCAT('update mainjantrinumbers set profit = (select ifnull(Amount',convert(intRow,char),',0) from mainjantrinumbersprofit)
			where Num = ',convert(intRow,char),' ' );

			PREPARE stmt FROM @s;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

			set intRow = intRow + 1;
		end while;
			
	if ifnull(varIsNotShow,0) = 0 then 
		begin
			select mainjantrinumbersprofit.*,ifnull(TotalSaleTable.Amount ,0) as Amount 
			,round(ifnull(TotalSaleTable.NetSale ,0)) as NetSale
			from mainjantrinumbersprofit
			left join (
			select ifnull(sum(transaction_detail.Amount),0) as Amount,transaction_detail.Number 
			,ifnull(sum((transaction_detail.FinalAmount)*(((100-ifnull(transaction.SelfHissa,0))/100))*(((100-ifnull(transaction.OtherHissa,0))/100))),0) as NetSale
			from transaction
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and  transaction.ShiftId = varShiftId
			and  transaction.OrganizationId = varOrganizationId
			and transaction.TransactionMode = 1 
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			) as TotalSaleTable on 1=1
			;
		end;
	elseif ifnull(varIsNotShow,0) = 1 then 
		begin
			select mainjantrinumbers.Num
			,ifnull((-(mainjantrinumbers.Profit)),0) as Profit
			,ifnull(TotalSaleTable.Amount ,0) as Amount
			,round(ifnull(TotalSaleTable.NetSale ,0)) as NetSale
			,round((ifnull((-(mainjantrinumbers.Profit)),0) / 
				ifnull((select case when ifnull(sum((transaction_detail.FinalAmount)
					*(((100-ifnull(transaction.SelfHissa,0))/100))*(((100-ifnull(transaction.OtherHissa,0))/100))),0) = 0 then
						1
					else
						ifnull(sum((transaction_detail.FinalAmount)
						*(((100-ifnull(transaction.SelfHissa,0))/100))*(((100-ifnull(transaction.OtherHissa,0))/100))),0)
					end
				from transaction
				inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
				where transaction.TransactionDate = varTransactionDate
				and  transaction.ShiftId = varShiftId
				and  transaction.OrganizationId = varOrganizationId
				and transaction.TransactionMode = 1 
				and transaction.RecordStatus!='D'
				and transaction_detail.RecordStatus!='D'
				),1)
			) * 100)
			as Percent
			,ifnull(declare_count.DeclareCountForLastMonth,0) as DeclareCountForLastMonth
			
            from mainjantrinumbers 
			left join (
			select ifnull(sum(transaction_detail.Amount),0) as Amount,transaction_detail.Number 
			,ifnull(sum((transaction_detail.FinalAmount)*(((100-ifnull(transaction.SelfHissa,0))/100))*(((100-ifnull(transaction.OtherHissa,0))/100))),0) as NetSale
			from transaction
			inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
			where transaction.TransactionDate = varTransactionDate
			and  transaction.ShiftId = varShiftId
			and  transaction.OrganizationId = varOrganizationId
			and transaction.TransactionMode = 1 
			and transaction.RecordStatus!='D'
			and transaction_detail.RecordStatus!='D'
			group by (case when length(transaction_detail.Number) > 2 then transaction_detail.Number 
				else convert(transaction_detail.Number,signed) end)
			) as TotalSaleTable on TotalSaleTable.Number = mainjantrinumbers.Num
			left join (
				select count(1) as DeclareCountForLastMonth,DeclareNumber from declare_result
				where ShiftId = varShiftId
				and DeclareDate between date_add(varTransactionDate,INTERVAL -1 MONTH) and date_add(varTransactionDate,INTERVAL -1 DAY)
				and RecordStatus!='D'
				group by DeclareNumber 
			) as declare_count on declare_count.DeclareNumber = mainjantrinumbers.Num
			order by Profit
			
			;

		end;
    end if;
    
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `dynamic_fair_trade_sel_preductiondata_allnumber_declare`(
IN `varTransactionDate` DATE, 
IN `varShiftId` BIGINT(8),
IN `varOrganizationId` BIGINT(8),
IN `varIsNotShow` smallint(6) 
)
begin
	declare intRow smallint default 0;
	
		delete from mainjantrinumbersprofit;
		
		set intRow = 1;
		SET @s = CONCAT('insert into mainjantrinumbersprofit(' );
		SET @sTemp = '';
		
		SET @s = CONCAT(@s,'amount',convert(intRow,char));
		
		SET @sTemp = CONCAT(@sTemp,'sum((ifnull((if((Number = ',convert(intRow,char),' or Number = right(lpad ((',convert(intRow,char),' mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((',convert(intRow,char),'/10)) mod 10) * 1111 ,4,"0"),4)) and transaction_declare.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction_declare.TransactionMode = 1 ,transaction_detail_declare.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(SelfHissa,0))/100))*(((100-ifnull(OtherHissa,0))/100))
		)as amount',convert(intRow,char),'
		');

		set intRow = intRow + 1;

		while intRow <= 100 Do
			SET @s = CONCAT(@s,',amount',convert(intRow,char));
			
				SET @sTemp = CONCAT(@sTemp,',sum((ifnull((if((Number = ',convert(intRow,char),' or Number = right(lpad ((',convert(intRow,char),' mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((',convert(intRow,char),'/10)) mod 10) * 1111 ,4,"0"),4)) and transaction_declare.TransactionMode = 1 ,Amount * Rate ,0 )),0)
				- ifnull((if(transaction_declare.TransactionMode = 1 ,transaction_detail_declare.FinalAmount ,0 )),0)
				)
				*(((100-ifnull(SelfHissa,0))/100))*(((100-ifnull(OtherHissa,0))/100))
				)as amount',convert(intRow,char),'
				');
							
			set intRow = intRow + 1;
		end while;

		SET @s = CONCAT(@s,')

select
		');
		
		SET @sTemp = CONCAT(@sTemp,' 
		from transaction_declare 
		inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
		where transaction_declare.TransactionDate = ''',convert(varTransactionDate,char),'''
		and  transaction_declare.ShiftId = ',convert(varShiftId,char),'
		and  transaction_declare.OrganizationId = ',convert(varOrganizationId,char),'
		and transaction_declare.TransactionMode = 1 
		and transaction_declare.RecordStatus!=''D''
		and transaction_detail_declare.RecordStatus!=''D''
			');

		SET @s = CONCAT(@s,@sTemp);
	   
		PREPARE stmt FROM @s;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;


		set intRow = 1;
		
		while intRow <= 100 Do
			SET @s = CONCAT('update mainjantrinumbers set profit = (select ifnull(Amount',convert(intRow,char),',0) from mainjantrinumbersprofit)
			where Num = ',convert(intRow,char),' ' );

			PREPARE stmt FROM @s;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

			set intRow = intRow + 1;
		end while;
			
	if ifnull(varIsNotShow,0) = 0 then 
		begin
			select mainjantrinumbersprofit.*,ifnull(TotalSaleTable.Amount ,0) as Amount 
			,round(ifnull(TotalSaleTable.NetSale ,0)) as NetSale
			from mainjantrinumbersprofit
			left join (
				select ifnull(sum(transaction_detail_declare.Amount),0) as Amount
				,ifnull(sum((transaction_detail_declare.FinalAmount)*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))),0) as NetSale

				from transaction_declare
				inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
				where transaction_declare.TransactionDate = varTransactionDate
				and  transaction_declare.ShiftId = varShiftId
				and  transaction_declare.OrganizationId = varOrganizationId
				and transaction_declare.TransactionMode = 1 
				and transaction_declare.RecordStatus!='D'
				and transaction_detail_declare.RecordStatus!='D'
			) as TotalSaleTable on 1=1
			;
		end;
	elseif ifnull(varIsNotShow,0) = 1 then 
		begin
			select mainjantrinumbers.Num,ifnull((-(mainjantrinumbers.Profit)),0) as Profit
			,ifnull(TotalSaleTable.Amount ,0) as Amount
			,round(ifnull(TotalSaleTable.NetSale ,0)) as NetSale
			,round((ifnull((-(mainjantrinumbers.Profit)),0) / 
				ifnull((select case when ifnull(sum((transaction_detail_declare.FinalAmount)
					*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))),0) = 0 then
						1
					else
						ifnull(sum((transaction_detail_declare.FinalAmount)
						*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))),0)
					end
				from transaction_declare
				inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
				where transaction_declare.TransactionDate = varTransactionDate
				and  transaction_declare.ShiftId = varShiftId
				and  transaction_declare.OrganizationId = varOrganizationId
				and transaction_declare.TransactionMode = 1 
				and transaction_declare.RecordStatus!='D'
				and transaction_detail_declare.RecordStatus!='D'
				),1)
			) * 100)
			as Percent,ifnull(declare_count.DeclareCountForLastMonth,0) as DeclareCountForLastMonth
            from mainjantrinumbers 
			left join (
			select ifnull(sum(transaction_detail_declare.Amount),0) as Amount
			,transaction_detail_declare.Number 
			,ifnull(sum((transaction_detail_declare.FinalAmount)*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))),0) 
			as NetSale
			
			from transaction_declare
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate = varTransactionDate
			and  transaction_declare.ShiftId = varShiftId
			and  transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
			group by (case when length(transaction_detail_declare.Number) > 2 then transaction_detail_declare.Number 
				else convert(transaction_detail_declare.Number,signed) end)
			) as TotalSaleTable on TotalSaleTable.Number = mainjantrinumbers.Num
			left join (
				select count(1) as DeclareCountForLastMonth,DeclareNumber from declare_result
				where ShiftId = varShiftId
				and DeclareDate between date_add(varTransactionDate,INTERVAL -1 MONTH) and date_add(varTransactionDate,INTERVAL -1 DAY)
				and RecordStatus!='D'
				group by DeclareNumber 
			) as declare_count on declare_count.DeclareNumber = mainjantrinumbers.Num
			order by Profit
			
			;

		end;
    end if;
    
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `dynamic_fair_trade_sel_StatusBeforeNewsData`(
IN `varTransactionDate` DATE, 
IN `varShiftId` BIGINT(8),
IN `varOrganizationId` BIGINT(8),
IN `varNumber` varchar(500)
)
begin
	declare intRow smallint default 0;
	declare SingleNumber varchar(10);

		
		SET @s = CONCAT('select	transaction.LedgerId,ledger.LedgerName
		,ifnull(ProfitTable.NoOfProfit,0) as LastFiveDayProfitNo
		,sum(Amount) as TotSale' );
		set intRow = 1;
		
		WHILE INSTR(varNumber, ',') DO
			
			SET SingleNumber = substring_index(varNumber,',',1);
			SET varNumber = substring(varNumber,length(SingleNumber)+2);
			
				SET @s = CONCAT(@s,',-sum((ifnull((if((Number = ',convert(SingleNumber,char),' or Number = right(lpad ((',convert(SingleNumber,char),' mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((',convert(SingleNumber,char),'/10)) mod 10) * 1111 ,4,"0"),4)) and transaction.TransactionMode = 1 ,Amount * Rate ,0 )),0)
				- ifnull((if(transaction.TransactionMode = 1 ,transaction_detail.FinalAmount ,0 )),0)
				)
				*(((100-ifnull(transaction.SelfHissa,0))/100))*(((100-ifnull(transaction.OtherHissa,0))/100))
				)as Amount',convert(intRow,char),',',convert(SingleNumber,char),' as Number',convert(intRow,char),'
				');
							
			set intRow = intRow + 1;
		end while;

		SET @s = CONCAT(@s,',-sum((ifnull((if((Number = ',convert(varNumber,char),' or Number = right(lpad ((',convert(varNumber,char),' mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((',convert(varNumber,char),'/10)) mod 10) * 1111 ,4,"0"),4)) and transaction.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction.TransactionMode = 1 ,transaction_detail.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(transaction.SelfHissa,0))/100))*(((100-ifnull(transaction.OtherHissa,0))/100))
		)as Amount',convert(intRow,char),',',convert(varNumber,char),' as Number',convert(intRow,char),'
		');

		SET @s = CONCAT(@s,' 
		from transaction 
		inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
		inner join ledger on ledger.LedgerId = transaction.LedgerId
		left join 
			(
			select sum(case when TodayProfit < 0 then 1 else 0 end) as NoOfProfit
			,LedgerId
			from
			(
				select vd.VoucherDate,
					
					CONVERT((SUM(IF(vd.VoucherType in (22,23,24,25,26,27,28,29,30,31,32), IF(vd.AmountType = ''Dr'', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2))
					as TodayProfit
					,vd.LedgerId
					
					from voucher_detail as vd
					
					where (vd.VoucherDate between ''',convert(date_add(varTransactionDate,INTERVAL -5 DAY),char),''' 
									and ''',convert(date_add(varTransactionDate,INTERVAL -1 DAY),char),''')
					and (vd.RecordStatus!=''D'') 
					and (vd.ShiftId = ',convert(varShiftId,char),' )
					group by vd.VoucherDate,vd.LedgerId
			
			) as AA
			group by LedgerId
			) as ProfitTable on ProfitTable.LedgerId = transaction.LedgerId
			
		where transaction.TransactionDate = ''',convert(varTransactionDate,char),'''
		and  transaction.ShiftId = ',convert(varShiftId,char),'
		and  transaction.OrganizationId = ',convert(varOrganizationId,char),'
		and transaction.TransactionMode = 1 
		and transaction.RecordStatus!=''D''
		and transaction_detail.RecordStatus!=''D''
		group by transaction.LedgerId,ledger.LedgerName
		order by ledger.LedgerName
    		');

		
		PREPARE stmt FROM @s;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `dynamic_fair_trade_sel_StatusBeforeNewsData_declare`(
IN `varTransactionDate` DATE, 
IN `varShiftId` BIGINT(8),
IN `varOrganizationId` BIGINT(8),
IN `varNumber` varchar(500)
)
begin
	declare intRow smallint default 0;
	declare SingleNumber varchar(10);

		
		SET @s = CONCAT('select	transaction_declare.LedgerId
		,ifnull(ProfitTable.NoOfProfit,0) as LastFiveDayProfitNo
		,ledger.LedgerName,sum(Amount) as TotSale' );
		set intRow = 1;
		
		WHILE INSTR(varNumber, ',') DO
			
			SET SingleNumber = substring_index(varNumber,',',1);
			SET varNumber = substring(varNumber,length(SingleNumber)+2);
			
				SET @s = CONCAT(@s,',-sum((ifnull((if((Number = ',convert(SingleNumber,char),' or Number = right(lpad ((',convert(SingleNumber,char),' mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((',convert(SingleNumber,char),'/10)) mod 10) * 1111 ,4,"0"),4)) and transaction_declare.TransactionMode = 1 ,Amount * Rate ,0 )),0)
				- ifnull((if(transaction_declare.TransactionMode = 1 ,transaction_detail_declare.FinalAmount ,0 )),0)
				)
				*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))
				)as Amount',convert(intRow,char),',',convert(SingleNumber,char),' as Number',convert(intRow,char),'
				');
							
			set intRow = intRow + 1;
		end while;

		SET @s = CONCAT(@s,',-sum((ifnull((if((Number = ',convert(varNumber,char),' or Number = right(lpad ((',convert(varNumber,char),' mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((',convert(varNumber,char),'/10)) mod 10) * 1111 ,4,"0"),4)) and transaction_declare.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction_declare.TransactionMode = 1 ,transaction_detail_declare.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))
		)as Amount',convert(intRow,char),',',convert(varNumber,char),' as Number',convert(intRow,char),'
		');

		SET @s = CONCAT(@s,' 
		from transaction_declare 
		inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
		left join ledger on ledger.LedgerId = transaction_declare.LedgerId
		left join 
			(
			select sum(case when TodayProfit < 0 then 1 else 0 end) as NoOfProfit
			,LedgerId
			from
			(
				select vd.VoucherDate,
					
					CONVERT((SUM(IF(vd.VoucherType in (22,23,24,25,26,27,28,29,30,31,32), IF(vd.AmountType = ''Dr'', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2))
					as TodayProfit
					,vd.LedgerId
					
					from voucher_detail as vd
					
					where (vd.VoucherDate between ''',convert(date_add(varTransactionDate,INTERVAL -5 DAY),char),''' 
									and ''',convert(date_add(varTransactionDate,INTERVAL -1 DAY),char),''')
					and (vd.RecordStatus!=''D'') 
					and (vd.ShiftId = ',convert(varShiftId,char),' )
					group by vd.VoucherDate,vd.LedgerId
			
			) as AA
			group by LedgerId
			) as ProfitTable on ProfitTable.LedgerId = transaction_declare.LedgerId

		where transaction_declare.TransactionDate = ''',convert(varTransactionDate,char),'''
		and  transaction_declare.ShiftId = ',convert(varShiftId,char),'
		and  transaction_declare.OrganizationId = ',convert(varOrganizationId,char),'
		and transaction_declare.TransactionMode = 1 
		and transaction_declare.RecordStatus!=''D''
		and transaction_detail_declare.RecordStatus!=''D''
		group by transaction_declare.LedgerId,ledger.LedgerName
		order by ledger.LedgerName
    		');

		
		PREPARE stmt FROM @s;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
/*
select @s;
  */      
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `hawa_patti_ledger_detail_of_organizationWithBalance`(
 	IN varOrganizationId bigint,
	IN varFromDate DATE,
	IN varToDate DATE,
	IN varToLedgerIds bigint
 )
begin
	declare varVapsiWorkingDays INT default 0;

	SELECT VapsiWorkingDays into varVapsiWorkingDays FROM organization
		where organization.OrganizationId = varOrganizationId
		;

	select 
		hpTable.LedgerId as LedgerId
		,hpTable.LedgerName as LedgerName
		,hpTable.HPLedgerId as HPLedgerId 
		,hpTable.Hissa as Hissa
		,hpTable.FromDate as FromDate
		,CONVERT(ifnull(hpTable.ProfitAndLoss,0), DECIMAL(16,2)) as ProfitAndLoss
		,CONVERT(ifnull(hpTable.HPAmount,0), DECIMAL(16,2)) as HPAmount 
		,ifnull(hpTable.WorkingDays,0) as WorkingDays
		
		,vapsiTable.vapsi as vapsi
		,CONVERT(ifnull(vapsiTable.VapsiBaseAmount,0), DECIMAL(16,2))  as VapsiBaseAmount 
		,CONVERT(ifnull(vapsiTable.vapsiAmount,0), DECIMAL(16,2)) as vapsiAmount 
		,vapsiTable.IsTPV as IsTPV
		
		,CONVERT(ifnull(settTable.opening,0), DECIMAL(16,2)) as SettelmentAmount

		,-CONVERT(ifnull(hpTable.HPAmount,0), DECIMAL(16,2))  
		-CONVERT(ifnull(vapsiTable.vapsiAmount,0), DECIMAL(16,2)) 
		+CONVERT(ifnull(settTable.opening,0), DECIMAL(16,2)) as TotalSettelmentAmount



	from 
	(
		SELECT l.LedgerId,l.LedgerName
		,ifnull(vd.FromDate,ifnull(vd.FromDate,FromDate)) as FromDate
		,hissa.Hissa
		,ifnull(l.HPLedgerId,0) as HPLedgerId 
		,ifnull(sum(ProfitAndLoss),0) ProfitAndLoss
		,(ifnull(sum(ProfitAndLoss) ,0) * ifnull(hissa.Hissa,0) )/100 as HPAmount 
		,ifnull((vdWorking.WorkingDays),0) WorkingDays
		from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.HPLedgerId,ledger.AgentLedgerId
			from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
			and (varToLedgerIds = 0 or ifnull(ledger.HPLedgerId,0) = varToLedgerIds)
			and ledger.OrganizationId = varOrganizationId
			) as l 
		left join hissa on hissa.LedgerId = l.LedgerId and hissa.HissaLedgerId = 11	and hissa.RecordStatus != 'D' and ifnull(hissa.Hissa,0) != 0
		left JOIN (select
			vd.LedgerId,varFromDate as FromDate,
			sum(IF(vd.ShiftId != 0,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) ProfitAndLoss
			from voucher_detail as vd
			
/*			left join (select hp_hissa.LedgerId,max(DATE_ADD(hp_hissa.HPToDate, INTERVAL 1 DAY)) as FromDate from hp_hissa where hp_hissa.RecordStatus != 'D'
			group by LedgerId) as hp_hissa on hp_hissa.LedgerId = vd.LedgerId 
*/
			where vd.VoucherDate between varFromDate and varToDate
			#and varFromDate not in (select HPFromDate from hp_hissa where hp_hissa.RecordStatus != 'D' and hp_hissa.LedgerId = vd.LedgerId)
			and vd.LedgerId not in (select hp_hissa.LedgerId from hp_hissa where hp_hissa.RecordStatus != 'D' and hp_hissa.HPFromDate = varFromDate)
			and (vd.RecordStatus!='D') 
			group by vd.LedgerId 
			) as vd on vd.LedgerId = l.LedgerId   
		left join (
			select LedgerId,count(WorkingDays) as WorkingDays
				from
				(
				select		
				vd.LedgerId,count(1) WorkingDays
				from voucher_detail as vd
				where vd.VoucherDate between varFromDate and varToDate
				and (vd.RecordStatus!='D') 
				and vd.VoucherType in (22,23,24)
				group by vd.LedgerId,vd.VoucherDate
				) as vd 
				group by LedgerId
			) as vdWorking on vdWorking.LedgerId = l.LedgerId   
		GROUP BY l.LedgerId,l.LedgerName,hissa.Hissa
		,vd.FromDate,l.AddedDate
		,ifnull(l.HPLedgerId,0)  
	) as hpTable 
	left join
	(
		SELECT DISTINCT l.LedgerId
		,varFromDate as FromDate
		,l.vapsi
		,(ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) * (100 - ifnull(Hissa,0))) /100  as VapsiBaseAmount 
		,(((ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) * (100 - ifnull(Hissa,0))) /100)  
			* ifnull(l.vapsi,0) )/100 as vapsiAmount 
		,(case when ifnull((select sum(Vapsi) from third_party_vapsi where third_party_vapsi.LedgerId = l.LedgerId and RecordStatus != 'D'),0) > 0 then 'Yes' else 'No' end) as IsTPV

		from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.vapsi,ledger.AgentLedgerId 
			from ledger where ledger.GroupId in (3,4,5)
			and ifnull(ledger.Vapsi,0) != 0 and ledger.RecordStatus!='D' 
			and ifnull(ledger.ParentLedgerId,0) = 0 
			and ledger.OrganizationId = varOrganizationId
			and (varToLedgerIds = 0 or ifnull(ledger.HPLedgerId,0) = varToLedgerIds)
			and (ifnull(varVapsiWorkingDays,0) = 0 
					or ledger.LedgerId in (
						(select vd.LedgerId
							from (
								select		
								vd.LedgerId,vd.VoucherDate
								from voucher_detail as vd
								where vd.VoucherDate between varFromDate and varToDate
								and (vd.RecordStatus!='D') 
								and vd.VoucherType in (22,23,24)
								group by vd.LedgerId,vd.VoucherDate
							) as vd
						group by vd.LedgerId
						having count(1) >= varVapsiWorkingDays
						)
					)
				) 
			
			) as l  
		left JOIN (select
			(case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
																else ledgerBaap.ParentLedgerId end) LedgerId,varFromDate as FromDate,
			sum(IF(vd.ShiftId != 0,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) ProfitAndLoss
			from voucher_detail as vd
			inner join shift on vd.ShiftId = shift.ShiftId and ifnull(shift.IsCreateVapsi,1) = 1
			left join (select ledger.LedgerId,ledger.ParentLedgerId from ledger 
			WHERE (ledger.RecordStatus!='D') 
			and ledger.OrganizationId = varOrganizationId
			and ledger.GroupId in (3,4,5)
			)as ledger on vd.LedgerId = ledger.LedgerId
			left join (select ledger.LedgerId,ledger.ParentLedgerId from ledger 
			WHERE (ledger.RecordStatus!='D') 
			and ledger.OrganizationId = varOrganizationId
			and ledger.GroupId in (3,4,5)
			)as ledgerBaap on ledger.ParentLedgerId = ledgerBaap.LedgerId
			
			/*
			left join (select vapsi.LedgerId,max(DATE_ADD(vapsi.vapsiToDate, INTERVAL 1 DAY)) as FromDate from vapsi where vapsi.RecordStatus != 'D'
			group by LedgerId) as vapsi on vapsi.LedgerId = (case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 then ledger.ParentLedgerId
																else ledgerBaap.ParentLedgerId end)
			*/
			
			where vd.VoucherDate between varFromDate and varToDate
/*			and varFromDate not in (select vapsi.VapsiFromDate from vapsi where vapsi.RecordStatus != 'D' and vapsi.LedgerId = (case when ledger.ParentLedgerId = 0 then vd.LedgerId 
																WHEN ledgerBaap.ParentLedgerId = 0 then ledger.ParentLedgerId
																else ledgerBaap.ParentLedgerId end))
*/
			and (case when ledger.ParentLedgerId = 0 then vd.LedgerId 
				WHEN ledgerBaap.ParentLedgerId = 0 then ledger.ParentLedgerId
				else ledgerBaap.ParentLedgerId end) not in (select vapsi.LedgerId from vapsi where vapsi.RecordStatus != 'D' and vapsi.VapsiFromDate = varFromDate)

			and (vd.RecordStatus!='D') 
			group by (case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
																else ledgerBaap.ParentLedgerId end)
			) as vd on vd.LedgerId = l.LedgerId   
		left join (select sum(Hissa) Hissa,LedgerId from hissa where LedgerId != HissaLedgerId and hissa.RecordStatus != 'D' group by LedgerId ) 
				as hissa  on hissa.LedgerId = l.LedgerId 
/*
		left join (select vapsi.LedgerId,max(DATE_ADD(vapsi.vapsiToDate, INTERVAL 1 DAY)) as FromDate from vapsi where vapsi.RecordStatus != 'D'
				group by LedgerId) as vapsiDate on vapsiDate.LedgerId = l.LedgerId
*/		
		GROUP BY l.LedgerId,l.Vapsi
		,vd.FromDate,l.AddedDate,ifnull(Hissa,0)
	) as vapsiTable on hpTable.LedgerId = vapsiTable.LedgerId
	left join 
	(
		SELECT DISTINCT l.LedgerId
		,(OPBal.opening) as opening,l.HPLedgerId 

		from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.HPLedgerId,ledger.AgentLedgerId
			from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
			and (varToLedgerIds = 0 or ifnull(ledger.HPLedgerId,0) = varToLedgerIds)
			and ledger.OrganizationId = varOrganizationId
			) as l 
		left JOIN (Select LedgerId
				,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
				from voucher_detail aa
						Where 
						aa.VoucherDate <= varToDate
						and aa.VoucherType != 2
						and aa.RecordStatus != 'D' 
						and aa.OrganizationId = varOrganizationId
						group by aa.LedgerId 
			) as OPBal on OPBal.LedgerId = l.LedgerId
		where ifnull(opening,0) != 0
	) as settTable on settTable.LedgerId = hpTable.LedgerId
	where 1=1
    Order By hpTable.LedgerName;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `hawa_patti_ledger_of_organization`(
 IN varOrganizationId bigint
 ,IN varLedgerName varchar(100)
 )
begin
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where ledger.LedgerId in (select hp.HPLedgerId from ledger as hp where hp.OrganizationId = varOrganizationId
            and hp.RecordStatus != 'D'
			and hp.IsHide = '0')
			and ledger.LedgerName like concat(varLedgerName , '%')
			order by ledger.LedgerName asc;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `hawa_patti_ledger_of_organizationWithBalance`(
 	IN varOrganizationId bigint,
	IN varFromDate DATE,
	IN varToDate DATE,
	IN varLedgerName varchar(100)
 )
begin
		declare varVapsiWorkingDays bigint default 0;

		SELECT VapsiWorkingDays into varVapsiWorkingDays FROM organization
			where organization.OrganizationId = varOrganizationId
			;

		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId
			,ifnull(ledger.AgentLedgerId,0) as AgentLedgerId
			,ifnull(agent.CommanMasterName,'NA') as AgentName
			,ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			
			,CONVERT(ifnull(HPVouch.ProfitAndLoss,0), DECIMAL(16,2)) as ProfitAndLoss
			,CONVERT(ifnull(HPVouch.WorkingDays,0), DECIMAL(16,2)) as WorkingDays
			,CONVERT(ifnull(HPVouch.HPAmount,0), DECIMAL(16,2)) as HPAmount

			,CONVERT(ifnull(VapsiVouch.VapsiBaseAmount,0), DECIMAL(16,2)) as VapsiBaseAmount
			,CONVERT(ifnull(VapsiVouch.vapsiAmount,0), DECIMAL(16,2)) as vapsiAmount
			,CONVERT(ifnull(SettVouch.opening,0), DECIMAL(16,2)) as SettelmentAmount

			,-CONVERT(ifnull(HPVouch.HPAmount,0), DECIMAL(16,2)) 
			-CONVERT(ifnull(VapsiVouch.vapsiAmount,0), DECIMAL(16,2)) 
			+CONVERT(ifnull(SettVouch.opening,0), DECIMAL(16,2)) as TotalSettelmentAmount

			from (select ledger.LedgerId,
				ledger.OrganizationId,
				ledger.ParentLedgerId,
				ledger.LedgerName,
                ledger.AgentLedgerId,
				ledger.GroupId,
				ledger.RecordStatus
				,ledger.AddedBy
				from ledger 
				where ledger.LedgerId in (select hp.HPLedgerId from ledger as hp where hp.OrganizationId = varOrganizationId
				and hp.RecordStatus != 'D'
				and hp.IsHide = '0')
				and ledger.LedgerName like concat(varLedgerName , '%')
			) as ledger
			left join 
			(
				select sum(ProfitAndLoss) as ProfitAndLoss
				,sum(WorkingDays) as WorkingDays
				,sum(HPAmount) as HPAmount
				,HPLedgerId as HPLedgerId
				from
				(
					SELECT DISTINCT l.LedgerId
					,ifnull(vd.FromDate,ifnull(vd.FromDate,FromDate)) as FromDate
					,hissa.Hissa
					,ifnull(l.HPLedgerId,0) as HPLedgerId 
					,ifnull(sum(ProfitAndLoss),0) ProfitAndLoss
					,(ifnull(sum(ProfitAndLoss) ,0) * ifnull(hissa.Hissa,0) )/100 as HPAmount 
					,ifnull((vdWorking.WorkingDays),0) WorkingDays
					from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.HPLedgerId,ledger.AgentLedgerId
						from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
						#and (varToLedgerIds = 0 or ifnull(ledger.HPLedgerId,0) = varToLedgerIds)
						and (ifnull(ledger.HPLedgerId,0) != 0)
						and ledger.OrganizationId = varOrganizationId
						) as l 
					left join hissa on hissa.LedgerId = l.LedgerId and hissa.HissaLedgerId = 11	and hissa.RecordStatus != 'D' and ifnull(hissa.Hissa,0) != 0
					left JOIN (select
						vd.LedgerId,varFromDate as FromDate,
						sum(IF(vd.ShiftId != 0,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) ProfitAndLoss
						from voucher_detail as vd
/*						left join (select hp_hissa.LedgerId,max(DATE_ADD(hp_hissa.HPToDate, INTERVAL 1 DAY)) as FromDate from hp_hissa where hp_hissa.RecordStatus != 'D'
						group by LedgerId) as hp_hissa on hp_hissa.LedgerId = vd.LedgerId 
*/
						where vd.VoucherDate between varFromDate and varToDate
						and vd.LedgerId not in (select hp_hissa.LedgerId from hp_hissa where hp_hissa.RecordStatus != 'D' and hp_hissa.HPFromDate = varFromDate)
						
						and (vd.RecordStatus!='D') 
						group by vd.LedgerId 
						) as vd on vd.LedgerId = l.LedgerId   
					left join (
						select LedgerId,count(WorkingDays) as WorkingDays
							from
							(
							select		
							vd.LedgerId,count(1) WorkingDays
							from voucher_detail as vd
							where vd.VoucherDate between varFromDate and varToDate
							and (vd.RecordStatus!='D') 
							and vd.VoucherType in (22,23,24)
							group by vd.LedgerId,vd.VoucherDate
							) as vd 
							group by LedgerId
						) as vdWorking on vdWorking.LedgerId = l.LedgerId   
					GROUP BY l.LedgerId,l.LedgerName,hissa.Hissa
					,vd.FromDate,l.AddedDate
					,ifnull(l.HPLedgerId,0)  
				) as vd
				group by HPLedgerId
			) as HPVouch on HPVouch.HPLedgerId = ledger.LedgerId

			left join
			(
				select vd.HPLedgerId
				,sum(VapsiBaseAmount) as VapsiBaseAmount
				,sum(vapsiAmount) as vapsiAmount
				from 
				(
					SELECT DISTINCT l.LedgerId,l.HPLedgerId
					,varFromDate as FromDate
					,l.vapsi
					,(ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) * (100 - ifnull(Hissa,0))) /100  as VapsiBaseAmount 
					,(((ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) * (100 - ifnull(Hissa,0))) /100)  
						* ifnull(l.vapsi,0) )/100 as vapsiAmount 

					from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.vapsi,ledger.AgentLedgerId ,ledger.HPLedgerId
						from ledger where ledger.GroupId in (3,4,5)
						and ifnull(ledger.Vapsi,0) != 0 and ledger.RecordStatus!='D' 
						and ifnull(ledger.ParentLedgerId,0) = 0 
						and ledger.OrganizationId = varOrganizationId
						and (ifnull(ledger.HPLedgerId,0) != 0)
						and (ifnull(varVapsiWorkingDays,0) = 0 
								or ledger.LedgerId in (
									(select vd.LedgerId
										from (
											select		
											vd.LedgerId,vd.VoucherDate
											from voucher_detail as vd
											where vd.VoucherDate between varFromDate and varToDate
											and (vd.RecordStatus!='D') 
											and vd.VoucherType in (22,23,24)
											group by vd.LedgerId,vd.VoucherDate
										) as vd
									group by vd.LedgerId
									having count(1) >= varVapsiWorkingDays
									)
								)
							) 

						) as l  
					left JOIN (select
						(case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
																			else ledgerBaap.ParentLedgerId end) LedgerId,varFromDate as FromDate,
						sum(IF(vd.ShiftId != 0,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) ProfitAndLoss
						from voucher_detail as vd
						inner join shift on vd.ShiftId = shift.ShiftId and ifnull(shift.IsCreateVapsi,1) = 1
						left join (select ledger.LedgerId,ledger.ParentLedgerId from ledger 
						WHERE (ledger.RecordStatus!='D') 
						and ledger.OrganizationId = varOrganizationId
						and ledger.GroupId in (3,4,5)
						)as ledger on vd.LedgerId = ledger.LedgerId
						left join (select ledger.LedgerId,ledger.ParentLedgerId from ledger 
						WHERE (ledger.RecordStatus!='D') 
						and ledger.OrganizationId = varOrganizationId
						and ledger.GroupId in (3,4,5)
						)as ledgerBaap on ledger.ParentLedgerId = ledgerBaap.LedgerId
						
/*						left join (select vapsi.LedgerId,max(DATE_ADD(vapsi.vapsiToDate, INTERVAL 1 DAY)) as FromDate from vapsi where vapsi.RecordStatus != 'D'
						group by LedgerId) as vapsi on vapsi.LedgerId = (case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 then ledger.ParentLedgerId
																			else ledgerBaap.ParentLedgerId end)
*/						
						where vd.VoucherDate between varFromDate and varToDate
						and (case when ledger.ParentLedgerId = 0 then vd.LedgerId 
							WHEN ledgerBaap.ParentLedgerId = 0 then ledger.ParentLedgerId
							else ledgerBaap.ParentLedgerId end) not in (select vapsi.LedgerId from vapsi where vapsi.RecordStatus != 'D' and vapsi.VapsiFromDate = varFromDate)

						and (vd.RecordStatus!='D') 
						group by (case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
																			else ledgerBaap.ParentLedgerId end)
						) as vd on vd.LedgerId = l.LedgerId   
					left join (select sum(Hissa) Hissa,LedgerId from hissa where LedgerId != HissaLedgerId and hissa.RecordStatus != 'D' group by LedgerId ) 
							as hissa  on hissa.LedgerId = l.LedgerId 
					/*
					left join (select vapsi.LedgerId,max(DATE_ADD(vapsi.vapsiToDate, INTERVAL 1 DAY)) as FromDate from vapsi where vapsi.RecordStatus != 'D'
							group by LedgerId) as vapsiDate on vapsiDate.LedgerId = l.LedgerId
					*/
					
					GROUP BY l.LedgerId,l.Vapsi
					,vd.FromDate,l.AddedDate,ifnull(Hissa,0),l.HPLedgerId
				) as vd 
				group by vd.HPLedgerId
			) as VapsiVouch on VapsiVouch.HPLedgerId = ledger.LedgerId
			left join
			( 
				SELECT sum(OPBal.opening) as opening,l.HPLedgerId 

				from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.HPLedgerId,ledger.AgentLedgerId
					from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
					and (ifnull(ledger.HPLedgerId,0) != 0)
					and ledger.OrganizationId = varOrganizationId
					) as l 
				left JOIN (Select LedgerId
						,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
						from voucher_detail aa
								Where 
								aa.VoucherDate <= varToDate
								and aa.VoucherType != 2
								and aa.RecordStatus != 'D' 
								and aa.OrganizationId = varOrganizationId
								group by aa.LedgerId 
					) as OPBal on OPBal.LedgerId = l.LedgerId
				where ifnull(opening,0) != 0
				group By l.HPLedgerId
			) as SettVouch on SettVouch.HPLedgerId = ledger.LedgerId
			left join comman_master agent on agent.CommanMasterId = ledger.AgentLedgerId and CommanMasterType = 1			
            left join login on ledger.LedgerId = login.LedgerId
			where 
			(CONVERT(ifnull(HPVouch.ProfitAndLoss,0), DECIMAL(16,2)) != 0
			or CONVERT(ifnull(HPVouch.HPAmount,0), DECIMAL(16,2)) != 0
			or CONVERT(ifnull(VapsiVouch.vapsiAmount,0), DECIMAL(16,2)) != 0 
			or CONVERT(ifnull(SettVouch.opening,0), DECIMAL(16,2)) != 0 )
			order by ledger.LedgerName asc;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `history_login_of_organization`(IN varOrganizationId bigint(20)
,  IN `varLoginId` bigint(20)
,  IN `varFromDate` DATE
, IN `varToDate` DATE
, in varAddedBy varchar(50)
)
BEGIN
	SELECT sl.*, date_format(sl.AddedDate, '%d-%m-%Y %h:%i:%s %p') as AddedDate
    FROM sys_logs sl
    WHERE sl.OrganizationId = varOrganizationId
	AND date_format(sl.AddedDate, '%Y-%m-%d') >= varFromDate
    AND date_format(sl.AddedDate, '%Y-%m-%d') <= varToDate
	and ( sl.LoginId = varLoginId or ifnull(varLoginId,0) = 0 )
    AND sl.RecordStatus != 'D'
	and (sl.AddedBy = varAddedBy or ifnull(varAddedBy,'') = '')
	order by sl.AddedDate Desc;
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `kist_all_of_organization`(IN varOrganizationId bigint(20)
,  IN `varFromDate` DATE
, IN `varToDate` DATE
, IN `varLedgerId` bigint(20)
, IN `varAgentId` bigint(8)
)
BEGIN
	SELECT k.*,l.LedgerName
    FROM kist k
    JOIN ledger l ON k.LedgerId = l.LedgerId

    WHERE k.OrganizationId = varOrganizationId
	AND k.KistDate >= varFromDate
    AND k.KistDate <= varToDate
	AND k.RecordStatus != 'D'
		and (ifnull(varLedgerId,0) = 0 or k.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
		and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
													where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = 31))								
			)
	order by k.KistDate Asc;
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `ledger_all_of_organization`(
IN varOrganizationId int
, IN varLedgerName varchar(50)
, IN varLedgerId int
, IN varUserName varchar(100)
, IN varRoleId int
, IN varRoleType varchar(20)
, IN varIsHide int   # 0 for Active , 1 For Hide , 2 for Deleted
, IN varAgentId int
, IN varGroupAgentId int
, IN varIsCapping int
)
begin
# RoleId = 2 super admin, 3 distributer,4 ressaler ,5 panter
case varRoleId 
	when 3 then
		SELECT l.*,
			chat_group.ChatGroupName,
			date_format(l.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
			date_format(l.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate, 
			g.GroupName,
			ifnull(agent.CommanMasterName,'') as AgentName
			,lg.LoginName,lg.UserName,lg.LoginType,lg.Mobile,lg.Address, lg.AccountStatus as LoginStatus
            ,hpledger.LedgerName as HPLedgerName
			,ifnull(ledger_telegram.TelegramId,0) TelegramId 
			,ifnull(ledger_telegram.LedgerTelegramId,0) LedgerTelegramId
			,ifnull(ledger_telegram.AccessHash,'') AccessHash
			
			FROM ledger l
			join ledger_group g on l.GroupId = g.GroupId
			left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1
			left join chat_group on chat_group.ChatGroupId = l.ChatGroupId 
			join login lg on lg.LedgerId = l.LedgerId 
			left join ledger hpledger on l.HPLedgerId = hpledger.LedgerId
			left join ledger_telegram on l.LedgerId = ledger_telegram.LedgerId and ledger_telegram.RecordStatus <> 'D'
			where l.OrganizationId = varOrganizationId
			and (varLedgerName is null or l.LedgerName LIKE CONCAT('%', varLedgerName , '%'))
			and ((l.RecordStatus != 'D' and ifnull(varIsHide,0) != 2 ) or (l.RecordStatus = 'D' and varIsHide = 2 ))
			and l.GroupId != 7
			and (ifnull(l.IsHide,0) = ifnull(varIsHide,0) or ifnull(varIsHide,0) = 2)
			and (l.ParentLedgerId = varLedgerId or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
			and (varRoleType = 'ALL' 
				or l.UpdatedBy  = varUserName
				)
			and (ifnull(varIsCapping,-1) = -1 or (case when varIsCapping = 1 then l.TransactionCappingAmount <> 0 else l.TransactionCappingAmount = 0 end))
			order by l.LedgerName ASC;

	when 4 then
		SELECT l.*,
			chat_group.ChatGroupName,
			date_format(l.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
			date_format(l.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate, 
			g.GroupName,
			ifnull(agent.CommanMasterName,'') as AgentName
			,lg.LoginName,lg.UserName,lg.LoginType,lg.Mobile,lg.Address, lg.AccountStatus as LoginStatus
            ,hpledger.LedgerName as HPLedgerName
			,ifnull(ledger_telegram.TelegramId,0) TelegramId 
			,ifnull(ledger_telegram.LedgerTelegramId,0) LedgerTelegramId
			,ifnull(ledger_telegram.AccessHash,'') AccessHash
			FROM ledger l
			join ledger_group g on l.GroupId = g.GroupId
			left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1
			left join chat_group on chat_group.ChatGroupId = l.ChatGroupId 
			join login lg on lg.LedgerId = l.LedgerId 
			left join ledger hpledger on l.HPLedgerId = hpledger.LedgerId
			left join ledger_telegram on l.LedgerId = ledger_telegram.LedgerId and ledger_telegram.RecordStatus <> 'D'

			where l.OrganizationId = varOrganizationId
			and (varLedgerName is null or l.LedgerName LIKE CONCAT('%', varLedgerName , '%'))
			and ((l.RecordStatus != 'D' and ifnull(varIsHide,0) != 2 ) or (l.RecordStatus = 'D' and varIsHide = 2 ))
			and l.GroupId != 7
			and (ifnull(l.IsHide,0) = ifnull(varIsHide,0) or ifnull(varIsHide,0) = 2)
			and ( l.ParentLedgerId = varLedgerId)
			and (varRoleType = 'ALL' 
				or l.UpdatedBy  = varUserName
				)
			and (ifnull(varIsCapping,-1) = -1 or (case when varIsCapping = 1 then l.TransactionCappingAmount <> 0 else l.TransactionCappingAmount = 0 end))
			order by l.LedgerName ASC;

	when 5 then
		SELECT l.*,
			chat_group.ChatGroupName,
			date_format(l.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
			date_format(l.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate, 
			g.GroupName,
			ifnull(agent.CommanMasterName,'') as AgentName
			,lg.LoginName,lg.UserName,lg.LoginType,lg.Mobile,lg.Address, lg.AccountStatus as LoginStatus
            ,hpledger.LedgerName as HPLedgerName
			,ifnull(ledger_telegram.TelegramId,0) TelegramId 
			,ifnull(ledger_telegram.LedgerTelegramId,0) LedgerTelegramId
			,ifnull(ledger_telegram.AccessHash,'') AccessHash
			FROM ledger l
			join ledger_group g on l.GroupId = g.GroupId
			left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1
			left join chat_group on chat_group.ChatGroupId = l.ChatGroupId 
			join login lg on lg.LedgerId = l.LedgerId 
			left join ledger hpledger on l.HPLedgerId = hpledger.LedgerId
			left join ledger_telegram on l.LedgerId = ledger_telegram.LedgerId and ledger_telegram.RecordStatus <> 'D'

			where l.OrganizationId = varOrganizationId
			and (varLedgerName is null or l.LedgerName LIKE CONCAT('%', varLedgerName , '%'))
			and ((l.RecordStatus != 'D' and ifnull(varIsHide,0) != 2 ) or (l.RecordStatus = 'D' and varIsHide = 2 ))
			and l.GroupId != 7
			and (ifnull(l.IsHide,0) = ifnull(varIsHide,0) or ifnull(varIsHide,0) = 2)
			and 1<>1 /*not show to fanter even his account not show*/
			and (l.LedgerId = varLedgerId )
			and (varRoleType = 'ALL' 
				or l.UpdatedBy  = varUserName
				)
			and (ifnull(varIsCapping,-1) = -1 or (case when varIsCapping = 1 then l.TransactionCappingAmount <> 0 else l.TransactionCappingAmount = 0 end))
			order by l.LedgerName ASC;

	else
			SELECT l.*,
			chat_group.ChatGroupName,
			date_format(l.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
			date_format(l.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate, 
			g.GroupName,
			ifnull(agent.CommanMasterName,'') as AgentName
			,lg.LoginName,lg.UserName,lg.LoginType,lg.Mobile,lg.Address, lg.AccountStatus as LoginStatus
            ,hpledger.LedgerName as HPLedgerName
			,ifnull(ledger_telegram.TelegramId,0) TelegramId 
			,ifnull(ledger_telegram.LedgerTelegramId,0) LedgerTelegramId
			,ifnull(ledger_telegram.AccessHash,'') AccessHash
			FROM ledger l
			join ledger_group g on l.GroupId = g.GroupId
			left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1
			left join chat_group on chat_group.ChatGroupId = l.ChatGroupId 
			left join login lg on lg.LedgerId = l.LedgerId 
			left join ledger hpledger on l.HPLedgerId = hpledger.LedgerId
			left join ledger_telegram on l.LedgerId = ledger_telegram.LedgerId and ledger_telegram.RecordStatus <> 'D'
			where l.OrganizationId = varOrganizationId
			and (varLedgerName is null or l.LedgerName LIKE CONCAT('%', varLedgerName , '%'))
			and ((l.RecordStatus != 'D' and ifnull(varIsHide,0) != 2 ) or (l.RecordStatus = 'D' and varIsHide = 2 ))
			and l.GroupId != 7
			and (ifnull(l.IsHide,0) = ifnull(varIsHide,0) or ifnull(varIsHide,0) = 2)
			and (varRoleType = 'ALL' 
				or l.UpdatedBy  = varUserName
				)
			and (agent.LedgerId = varAgentId or ifnull(varAgentId,0) = 0 )
			and (l.AgentLedgerId = varGroupAgentId or ifnull(varGroupAgentId,0) = 0 )
			and (ifnull(varIsCapping,-1) = -1 or (case when varIsCapping = 1 then l.TransactionCappingAmount <> 0 else l.TransactionCappingAmount = 0 end))
			
			order by l.LedgerName ASC;

	end case;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `ledger_by_group`(
	IN varOrganizationId int(20), 
    IN varLedgerName varchar(50), 
    IN varGroupId varchar(50), 
    IN varParentId int(20),
    IN varDistributerId int(20)
    )
BEGIN
	SELECT ledger.LedgerName,ledger.LedgerId,ledger.GroupId, ledger.RecordStatus
	,ifnull(login.Mobile,'')Mobile
	,ifnull(login.UserName,'')UserName
	,ifnull(ledger.AccountStatus,'')AccountStatus
	,ifnull(ledger.ParentLedgerId,0)ParentLedgerId
	,ledger.Grantor
	,round(ledger_limit.LedgerBalance,0)LedgerBalance
	,round(ledger_limit.LedgerLimit,0)LedgerLimit
	,round(ledger_limit.TransConsum,0)TransConsum
	,round(ledger_limit.FinalLimit,0)FinalLimit
	FROM ledger ledger
	left join ledger_limit on ledger_limit.LedgerId = ledger.LedgerId 
	left join login on login.LedgerId = ledger.LedgerId
	where (ledger.OrganizationId = varOrganizationId or ledger.OrganizationId = 0 or ifnull(varOrganizationId,0) = 0 )
	and ledger.LedgerName LIKE CONCAT('', ifnull(varLedgerName,'') , '%')
	and (FIND_IN_SET(ledger.GroupId,varGroupId) > 0 or ifnull(varGroupId,'') = '')
	and (ledger.ParentLedgerId = varParentId or ifnull(varParentId,0) = 0 or ledger.LedgerId = varParentId)
    and ((ledger.LedgerId in (select Retailer.LedgerId from ledger as Retailer 
			where Retailer.ParentLedgerId in (select Distributer.LedgerId from ledger as Distributer where Distributer.ParentLedgerId = varDistributerId)) 
			or ifnull(varDistributerId,0) = 0 )
        or (ledger.ParentLedgerId = varDistributerId or ifnull(varDistributerId,0) = 0 )
        or ledger.LedgerId = varDistributerId
            )
	and ledger.RecordStatus != 'D'
    and ledger.IsHide = '0'
    order by ledger.LedgerName ASC;
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `ledger_Info`(
	IN varOrganizationId int
	, IN varLedgerId int
	, IN varGroupId varchar(50)
	, IN varParentId int
	, IN varDistributerId int
#	, IN varRetailerId int
	)
BEGIN
	SELECT ledger.LedgerId,
    ledger.OrganizationId,
    ledger.ParentLedgerId,
    ledger.LedgerName,
    ledger.RealName,
    ledger.Grantor,
    ledger.GroupId,
    ledger.AgentLedgerId,
    (select agent.CommanMasterName from comman_master as agent 
		where agent.CommanMasterId = ledger.AgentLedgerId and CommanMasterType = 1) 
        as AgentLedgerName ,
    ledger.LimitType,
    ledger.DaraRate,
    ledger.DaraCommission,
    ledger.AkharRate,
    ledger.AkharCommission,
    ledger.Vapsi,
    ledger.TPVapsi, 
    ledger.TPCommission,
    ledger.IsHissa,
    ledger.IsDibba,
    ledger.DibbaAmount,
    ledger.RefLedgerId,
    (select RefLedger.LedgerName from ledger as RefLedger where RefLedger.LedgerId = ledger.RefLedgerId) as RefLedgerName ,
    ledger.IsReport,
    ledger.TransactionMode,
	(case when ledger.ParentLedgerId = 0 then ledger.TransactionCappingAmount else parentledger.TransactionCappingAmount end) as TransactionCappingAmount,
    ledger.IsTransactionAllow,
    ledger.AccountStatus,
    ledger.RecordStatus,
    ledger.AddedBy,
    ledger.AddedDate,
    ledger.UpdatedBy,
    ledger.UpdatedDate
	,ledger.DealingType
	,ledger_limit.LedgerBalance 
    ,ledger_limit.LedgerLimit 
    ,ledger_limit.TransConsum 
    ,ledger_limit.FinalLimit 
	,ifnull(ledger_telegram.TelegramId,0) TelegramId 
	,ifnull(ledger_telegram.LedgerTelegramId,0) LedgerTelegramId
	,ifnull(ledger_telegram.AccessHash,'') AccessHash
    ,ifnull((select Ret.LedgerName from ledger as Ret where Ret.GroupId = 4 and Ret.LedgerId = ledger.ParentLedgerId),'Self') as RetailerName
	,ifnull((select Distrib.LedgerName from ledger as Distrib where Distrib.GroupId = 3 and Distrib.LedgerId = ledger.ParentLedgerId
		union
	select (select Distrib.LedgerName from ledger as Distrib where Distrib.GroupId = 3 and Distrib.LedgerId = Ret.ParentLedgerId) 
	from ledger as Ret where Ret.GroupId = 4 and Ret.LedgerId = ledger.ParentLedgerId),'Self') as DistributorName
	,login.LoginId
	,login.Mobile
    ,login.Address
	,login.UserName
    ,login.AccountStatus LoginStatus
    ,ledger.HPLedgerId
    ,hpledger.LedgerName as HPLedgerName
    ,ifnull((select sum(Hissa) from 
	hissa 
	where hissa.RecordStatus!='D' 
    and hissa.LedgerId = ledger.LedgerId 
    and hissa.LedgerId = hissa.HissaLedgerId),0) as SelfHissa
    ,ifnull((select sum(Hissa) from 
	hissa 
	where hissa.RecordStatus!='D' 
    and hissa.LedgerId = ledger.LedgerId 
    and hissa.LedgerId != hissa.HissaLedgerId),0) as OtherHissa
	,ifnull(ledger.IsApplyLedgerConfigOnTransaction,0) IsApplyLedgerConfigOnTransaction
	,ledger.IsRisky
	,ledger.TransactionLock
	
    FROM ledger 
	left join ledger_limit on ledger.LedgerId = ledger_limit.LedgerId
	left join login on ledger.LedgerId = login.LedgerId
	left join ledger hpledger on ledger.HPLedgerId = hpledger.LedgerId
	
	left join ledger parentledger on ledger.ParentLedgerId = parentledger.LedgerId
	left join ledger_telegram on ledger.LedgerId = ledger_telegram.LedgerId and ledger_telegram.RecordStatus <> 'D'
	
    where (ledger.OrganizationId = varOrganizationId or ledger.OrganizationId = 0 or ifnull(varOrganizationId,0) = 0 )
	and (ledger.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0 )
	and (FIND_IN_SET(ledger.GroupId,varGroupId) > 0 or ifnull(varGroupId,'') = '')
	and (ledger.ParentLedgerId = varParentId or ifnull(varParentId,0) = 0 )
	and ledger.RecordStatus != 'D'
	and ledger.IsHide = '0'
#	and (ledger.LedgerId in (select Retailer.LedgerId from ledger as Retailer where Retailer.ParentLedgerId = varRetailerId) or ifnull(varRetailerId,0) = 0 )

	and (ledger.LedgerId in (select Retailer.LedgerId from ledger as Retailer 
			where Retailer.ParentLedgerId in (select Distributer.LedgerId from ledger as Distributer where Distributer.ParentLedgerId = varDistributerId)) 
			or ifnull(varDistributerId,0) = 0 
			or
			(ledger.LedgerId in (select Fantar.LedgerId from ledger as Fantar where Fantar.ParentLedgerId = varDistributerId) )			
			)
    order by ledger.LedgerName desc;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `ledger_Info_by_ledgerId`(IN varOrganizationId int(20), IN varLedgerId varchar(50))
SELECT l.*
	,ledger_limit.LedgerBalance 
    ,ledger_limit.LedgerLimit 
    ,ledger_limit.TransConsum 
    ,ledger_limit.FinalLimit 
    FROM ledger l
	left join ledger_limit on l.LedgerId = ledger_limit.LedgerId
    where l.OrganizationId = varOrganizationId
	and l.LedgerId = varLedgerId
	and l.RecordStatus != 'D'
    order by l.LedgerName desc$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `ledger_List`(
 IN varLedgerId int(20),
 IN varListType int(20), # 0 for self ,1 for only ressaler, 2 only panter ,3 for ressaler and panter
 IN varLedgerName varchar(200)
 )
begin
case varListType 
	when 3 then
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where (ledger.LedgerId = varLedgerId or ledger.ParentLedgerId = varLedgerId 
				or ledger.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
            and ledger.LedgerName like concat('',varLedgerName,'%')
			and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			order by ledger.LedgerName asc;
	when 2 then
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where (ledger.LedgerId = varLedgerId or ((ledger.ParentLedgerId = varLedgerId 
				or ledger.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId)
                )
                and ledger.GroupId in (5))
					)
            and ledger.LedgerName like concat('',varLedgerName,'%')
			and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			order by ledger.LedgerName asc;
	when 1 then
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where (ledger.LedgerId = varLedgerId or ((ledger.ParentLedgerId = varLedgerId 
				or ledger.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId)
                )
                and ledger.GroupId in (4))
					)
            and ledger.LedgerName like concat('',varLedgerName,'%')
			and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			order by ledger.LedgerName asc;
	when 0 then
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where ledger.LedgerId = varLedgerId 
            and ledger.LedgerName like concat('',varLedgerName,'%')
			and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			order by ledger.LedgerName asc;
	else
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where (ledger.OrganizationId = varLedgerId or ledger.OrganizationId = 0)
            and ledger.LedgerName like concat('',varLedgerName,'%')
			and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			and ledger.GroupId not in (7)
			order by ledger.LedgerName asc;
	end case;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `ledger_List_for_voucher`(
 IN varLedgerId int(20),
 IN varListType int(20), # 0 for self ,1 for only ressaler, 2 only panter ,3 for ressaler and panter
 IN varLedgerName varchar(200)
 )
begin
case varListType 
	when 3 then
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where (ledger.LedgerId = varLedgerId or ledger.ParentLedgerId = varLedgerId 
				or ledger.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
            and ledger.LedgerName like concat('',varLedgerName,'%')
			and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			order by ledger.LedgerName asc;
	when 2 then
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where (ledger.LedgerId = varLedgerId or ((ledger.ParentLedgerId = varLedgerId 
				or ledger.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId)
                )
                and ledger.GroupId in (5))
					)
            and ledger.LedgerName like concat('',varLedgerName,'%')
			and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			order by ledger.LedgerName asc;
	when 1 then
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where (ledger.LedgerId = varLedgerId or ((ledger.ParentLedgerId = varLedgerId 
				or ledger.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId)
                )
                and ledger.GroupId in (4))
					)
            and ledger.LedgerName like concat('',varLedgerName,'%')
			and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			order by ledger.LedgerName asc;
	when 0 then
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where ledger.LedgerId = varLedgerId 
            and ledger.LedgerName like concat('',varLedgerName,'%')
			and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			order by ledger.LedgerName asc;
	else
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			from ledger 
            left join login on ledger.LedgerId = login.LedgerId
			where (ledger.OrganizationId = varLedgerId or ledger.OrganizationId = 0)
            and ledger.LedgerName like concat('',varLedgerName,'%')
			and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			order by ledger.LedgerName asc;
	end case;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_comman_master`(
IN `varOrganizationId` bigint(21)
, IN `varCommanMasterType` bigint(21)
, IN `varCommanMasterName` varchar(30)
)
SELECT payroll_comman_master.CommanMasterId
,payroll_comman_master.CommanName
,payroll_comman_master.OrganizationId
,payroll_comman_master.CommanType
,payroll_comman_master.IsAllow
,payroll_comman_master.CommanOrder
,payroll_comman_master.RecordStatus
,payroll_comman_master.AddedBy
,payroll_comman_master.AddedDate
,payroll_comman_master.UpdatedBy
,payroll_comman_master.UpdatedDate

FROM payroll_comman_master
where payroll_comman_master.CommanType = varCommanMasterType
and (ifnull(payroll_comman_master.CommanName,'') LIKE CONCAT(ifnull(varCommanMasterName,'') , '%'))
and (ifnull(payroll_comman_master.OrganizationId,0) = varOrganizationId or ifnull(payroll_comman_master.OrganizationId,0) = 0 or ifnull(varOrganizationId,0) = 0 )
and payroll_comman_master.RecordStatus != 'D'
order by payroll_comman_master.CommanOrder$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_salary_staff_list`(IN varOrganizationId int(20)
, IN varLedgerName varchar(50)
, IN varLedgerId int(20)
, IN varUserName varchar(100)
)
begin
select
	l.LedgerName,
	lg.LoginId,
	lg.OrganizationId,
	lg.LedgerId,
	lg.LoginName,
	lg.UserName,
	lg.LoginType,
	lg.Mobile,
	lg.Address,
	lg.StaffWorkMode,
	lg.AccountStatus,
	lg.RecordStatus,
	lg.AddedBy,
	lg.AddedDate,
	lg.UpdatedBy,
	lg.UpdatedDate,

	date_format(lg.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
	date_format(lg.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate, 
	r.RoleName, l.GroupId
	,ifnull(payroll_staff_structure.SalaryCount,0) as SalaryCount
	,SalaryAmount as TotalSalary
	,ifnull(payroll_staff_structure.AssetCount,0) as AssetCount
	,AssetAmount as AssetAmount
	
	FROM ledger l
	inner join (select LedgerId,sum(SalaryCount) as SalaryCount,sum(SalaryAmount) as SalaryAmount
				,sum(AssetCount) as AssetCount,sum(AssetAmount) as AssetAmount 
				from 
					( 
						select LedgerId,count(1) as SalaryCount
						,sum(case when AmountType = 1 then Amount 
								when AmountType = 2 then 
								(Amount * ifnull((select sum(BS.Amount) from payroll_staff_structure as BS 
												where BS.CommanMasterId = 1 and BS.LedgerId = payroll_staff_structure.LedgerId),0)/100)
								else 0 end) as SalaryAmount
						,0 as AssetCount ,0 as AssetAmount
						from payroll_staff_structure 
						where RecordStatus != 'D' group by LedgerId
						union all
						select LedgerId,0 as SalaryCount,0 as SalaryAmount
						,count(1) as AssetCount ,sum(Amount) as AssetAmount
						from payroll_staff_stock
						where RecordStatus != 'D' group by LedgerId
					) as StaffStu group by StaffStu.LedgerId
				) as payroll_staff_structure on l.LedgerId = payroll_staff_structure.LedgerId
	left join login lg on lg.LedgerId = l.LedgerId and lg.RecordStatus != 'D'
	left join role r on lg.LoginType = r.RoleId and r.OrganizationId = l.OrganizationId and r.RecordStatus != 'D' 
					
	where l.OrganizationId = varOrganizationId
	and l.RecordStatus != 'D'
	and (varLedgerName is null or l.LedgerName LIKE CONCAT('%', varLedgerName , '%'))
	and (l.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0 )
	and (lg.UserName = varUserName or ifnull(varUserName,'') = '')
	order by l.LedgerName asc;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_staff_attendance`(
	IN varOrganizationId int(20), 
	IN varMonth int,
	IN varYear int,
	in varLedgerId bigint
    )
BEGIN

	select 
	ledger.LedgerName
	,payroll_attendance.LedgerId
	,payroll_attendance.AttendanceDate
	,payroll_attendance.AttendanceMonth 
	,payroll_attendance.AttendanceYear 
	,payroll_attendance.WorkingDays 
	,payroll_attendance.TotalDays
	,payroll_attendance.Absent
	,payroll_attendance.PaidLeave
	,payroll_attendance.Present 
	,payroll_attendance.MonthEndLeaveApplicable 
	,payroll_attendance.TotalEntryCount 
	,payroll_attendance.Remark 
	,payroll_attendance.RecordStatus 
	,payroll_attendance.AddedBy 
	,payroll_attendance.AddedDate 
	,payroll_attendance.UpdatedBy 
	,payroll_attendance.UpdatedDate 

	,login.UserName
	,login.LoginType
	,login.Mobile
	,login.Address 
	
	from payroll_attendance 
	JOIN ledger on ledger.LedgerId = payroll_attendance.LedgerId
	left join login on login.LedgerId = ledger.LedgerId 
	where (payroll_attendance.OrganizationId = varOrganizationId or ifnull(varOrganizationId,0) = 0)
	and payroll_attendance.AttendanceMonth = varMonth
	and payroll_attendance.AttendanceYear = varYear
	and (payroll_attendance.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0 )
	order by ledger.LedgerName,login.UserName
	;	

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_staff_attendance_detail`(
	IN varOrganizationId int(20), 
	IN varMonth int,
	IN varYear int,
	in varLedgerId bigint,
	in varAddedBy varchar(20),
	in varLoginType int
    )
BEGIN

	declare varFromDate datetime;
	declare varToDate datetime;
	declare varTempDate date;
	
	set varFromDate = CONVERT( CONCAT(convert(varYear,char),'-',convert(varMonth,char) ,'-',convert(01,char)),DATE);
	if varMonth <> 12 then
		set varToDate = CONVERT( CONCAT(convert(varYear,char),'-',convert(varMonth+1,char) ,'-',convert(01,char)),DATE);
	else
		set varToDate = CONVERT( CONCAT(convert(varYear+1,char),'-',convert(01,char) ,'-',convert(01,char)),DATE);
	end if;
	set varToDate = DATE_ADD(varToDate, INTERVAL -1 DAY);
	set varTempDate = varFromDate;
	
	create temporary table MonthDates(EntryDates date);
	
	while varTempDate <= varToDate do
		insert into MonthDates(EntryDates) values(varTempDate)
		;
		set varTempDate = DATE_ADD(varTempDate, INTERVAL +1 DAY)
        ;
	end while;
	
		select 
			EntryDates
			
			,(case when payroll_leave.IsPaid = 0 then 1 else 0 end) as UnpaidLeave
			,(case when payroll_leave.IsPaid = 1 then 1 else 0 end) as PaidLeave
			
			,(case when varLoginType in (11) then 
					(case when ifnull(Atten.EntryCount,0) < 1000 then 0 else 1 end)							
				when varLoginType in (12) then 
					(case when ifnull(Atten.EntryCount,0) < 10 then 0 else 1 end)							
				else 
					(case when payroll_leave.IsPaid is null then 1 else 0 end)
				end )as Present
			
			
			,ifnull((Atten.EntryCount),0) EntryCount
			
			from MonthDates 
			left join payroll_leave on payroll_leave.LeaveDate = MonthDates.EntryDates 
					and payroll_leave.RecordStatus != 'D' 
					and payroll_leave.LedgerId = varLedgerId 
			left join 
				(
					select DATE(transaction_declare.TransactionDate) as TransactionDate 
					,sum(EntryCount) as EntryCount 
					from 
						(select transaction_declare.OrganizationId, DATE(transaction_declare.TransactionDate) as TransactionDate 
						,count(1) as EntryCount 
						from transaction_detail_declare  
						Join transaction_declare on transaction_detail_declare.TransactionId = transaction_declare.TransactionId
						where transaction_detail_declare.RecordStatus != 'D'
						and transaction_declare.RecordStatus != 'D'
						and DATE(transaction_declare.TransactionDate) between varFromDate and varToDate 
						and transaction_declare.AddedBy = varAddedBy
						group by DATE(transaction_declare.TransactionDate)
						union all
						SELECT t.OrganizationId,t.ShiftDate
						,count(1) as EntryCount 
						from transaction_audit t 
						where (t.RecordStatus != 'D')
						and (t.ShiftDate between varFromDate and varToDate)
						and t.AddedBy = varAddedBy
						group by t.ShiftDate					
						) as transaction_declare
					group by TransactionDate
				) as Atten on Atten.TransactionDate = MonthDates.EntryDates
			order by MonthDates.EntryDates
		;
		
	drop temporary table MonthDates;
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_staff_leave`(
	IN varOrganizationId int(20) 
	, in varLedgerId bigint
	, IN `varFromDate` DATE 
	, IN `varToDate` DATE 
    )
BEGIN

select 
  payroll_leave.LeaveId,
  payroll_leave.OrganizationId ,
  payroll_leave.LedgerId ,
  ledger.LedgerName ,
  payroll_leave.LeaveDate ,
  payroll_leave.IsPaid ,
  payroll_leave.Remark ,  
  payroll_leave.RecordStatus ,
  payroll_leave.AddedBy ,
  payroll_leave.AddedDate ,
  payroll_leave.UpdatedBy ,
  payroll_leave.UpdatedDate 
from payroll_leave
inner join ledger on payroll_leave.LedgerId = ledger.LedgerId
where payroll_leave.RecordStatus != 'D'
and payroll_leave.OrganizationId = varOrganizationId
and payroll_leave.LeaveDate between varFromDate and varToDate
and (ifnull(payroll_leave.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
;
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_staff_salary_register`(
	IN varOrganizationId int(20), 
	IN varMonth int,
	IN varYear int,
	in varLedgerId bigint
	, IN `varFromDate` DATE 
	, IN `varToDate` DATE 
	, in varAgentLedgerId bigint
    )
BEGIN

	begin
		DECLARE varCommanMasterId bigint;
		DECLARE intRow int;
		DECLARE varCommanName varchar(100);
		
		DECLARE finishedEarning INTEGER DEFAULT 0;
		DEClARE curEarning 
			CURSOR FOR 
			select payroll_comman_master.CommanMasterId,payroll_comman_master.CommanName from payroll_comman_master
			where payroll_comman_master.RecordStatus != 'D'
			and (payroll_comman_master.OrganizationId = varOrganizationId or payroll_comman_master.OrganizationId = 0 )
			and ifnull(payroll_comman_master.IsAllow,0) = 1
			and ifnull(payroll_comman_master.CommanType,0) = 2
			order by payroll_comman_master.CommanOrder        
		;
		
		DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finishedEarning = 1;
					
		set varCommanMasterId = 0;
		set intRow = 1;

		SET @s = CONCAT('		
						select 1 as DataFlag,payroll_salary.SalaryId,payroll_salary.VoucherId,ledger.LedgerName,login.UserName
							,login.Mobile,login.Address,login.AccountStatus LoginStatus,login.LoginName
							,login.LoginType,role.RoleId,role.RoleName,round(ledger_limit.LedgerBalance,0) Closing

							,payroll_salary.SalaryDate
							,payroll_salary.LedgerId,payroll_salary.SalaryMonth,payroll_salary.SalaryYear
							,payroll_salary.WorkingDays,payroll_salary.TotalDays
							,(ifnull(payroll_salary.WorkingDays,0) - ifnull(payroll_salary.Present,0) - ifnull(payroll_salary.PaidLeave,0)) as Absent,payroll_salary.PaidLeave
							,payroll_salary.Present,payroll_salary.TotalEntryCount
							,round(payroll_staff_structure.Amount,0)BasicSalary
						' );

		SET @sTemp = CONCAT('		
						SELECT 0 as DataFlag,0 SalaryId,0 VoucherId,'''' as LedgerName ,'''' UserName	
						,'''' as Mobile,'''' as Address,'''' as LoginStatus,'''' as LoginName
						,'''' as LoginType,0 as RoleId,'''' as RoleName,0 Closing
						,'''' SalaryDate
						,0 LedgerId,0 SalaryMonth,0 SalaryYear
						,0 WorkingDays,0 TotalDays,0 Absent,0 PaidLeave
						,0 Present,0 TotalEntryCount
						,0 BasicSalary
						' );

		SET @sBottom = CONCAT('		
							SELECT 2 as DataFlag,0 SalaryId,0 VoucherId,'''' as LedgerName ,'''' UserName	
							,'''' as Mobile,'''' as Address,'''' as LoginStatus,'''' as LoginName
							,'''' as LoginType,0 as RoleId,'''' as RoleName,0 Closing
							,'''' SalaryDate
							,0 LedgerId,0 SalaryMonth,0 SalaryYear

							,sum(ifnull(payroll_salary.WorkingDays,0))WorkingDays
							,sum(ifnull(payroll_salary.TotalDays,0))TotalDays
							,sum(ifnull(payroll_salary.Absent,0))Absent
							,sum(ifnull(payroll_salary.PaidLeave,0))PaidLeave
							,sum(ifnull(payroll_salary.Present,0))Present
							,sum(ifnull(payroll_salary.TotalEntryCount,0))TotalEntryCount
							,sum(round(payroll_salary.BasicSalary,0))BasicSalary
						' );
		SET @sBottomInner = CONCAT(' 
							from (		
								SELECT 
								(ifnull(payroll_salary.WorkingDays,0))WorkingDays
								,(ifnull(payroll_salary.TotalDays,0))TotalDays
								,(ifnull(payroll_salary.Absent,0))Absent
								,(ifnull(payroll_salary.PaidLeave,0))PaidLeave
								,(ifnull(payroll_salary.Present,0))Present
								,(ifnull(payroll_salary.TotalEntryCount,0))TotalEntryCount
								,(round(payroll_salary.BasicSalary,0))BasicSalary
						' );



		OPEN curEarning;
				
	getEarning: LOOP

			FETCH curEarning INTO varCommanMasterId,varCommanName;
			IF finishedEarning = 1 THEN 
				LEAVE getEarning;
			END IF;

			
			SET @s = CONCAT(@s,'
			,''',varCommanName,''' as Earning',convert(intRow,char),' 
			,round(sum(case when payroll_salary_detail.CommanMasterId = ',convert(varCommanMasterId,char),' then payroll_salary_detail.Amount else 0 end),0) as EarningAmount',convert(intRow,char),'
			');

				SET @sTemp = CONCAT(@sTemp,'
				,''',varCommanName,''' as Earning',convert(intRow,char),' 
				,',convert(varCommanMasterId,char),' as EarningAmount',convert(intRow,char),'
				');
				
			SET @sBottom = CONCAT(@sBottom,'
			,''',varCommanName,''' as Earning',convert(intRow,char),' 
			,round(sum(EarningAmount',convert(intRow,char),'),0) as EarningAmount',convert(intRow,char),'
			');

			SET @sBottomInner = CONCAT(@sBottomInner,'
			,''',varCommanName,''' as Earning',convert(intRow,char),' 
			,round(sum(case when payroll_salary_detail.CommanMasterId = ',convert(varCommanMasterId,char),' then payroll_salary_detail.Amount else 0 end),0) as EarningAmount',convert(intRow,char),'
			');

			set intRow = intRow + 1;
			
		END LOOP getEarning;
		CLOSE curEarning;
	end;

	begin
		DECLARE varCommanMasterId bigint;
		DECLARE intRow int;
		DECLARE varCommanName varchar(100);
		
		DECLARE finishedDeduction INTEGER DEFAULT 0;
		DEClARE curDeduction 
			CURSOR FOR 
			select payroll_comman_master.CommanMasterId,payroll_comman_master.CommanName from payroll_comman_master
			where payroll_comman_master.RecordStatus != 'D'
			and (payroll_comman_master.OrganizationId = varOrganizationId or payroll_comman_master.OrganizationId = 0 )
			and ifnull(payroll_comman_master.IsAllow,0) = 1
			and ifnull(payroll_comman_master.CommanType,0) = 3
			order by payroll_comman_master.CommanOrder        
		;
		
		DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finishedDeduction = 1;
					
		set varCommanMasterId = 0;
		set intRow = 1;

		SET @s = CONCAT(@s,'		
							,round((ifnull(payroll_salary.BasicSalary,0) + ifnull(payroll_salary.Allowances,0)),0) as GrossAmount
						' );

		SET @sTemp = CONCAT(@sTemp,'		
						,0 GrossAmount
						' );

		SET @sBottom = CONCAT(@sBottom,'		
							,sum(round((ifnull(payroll_salary.GrossAmount,0)),0)) as GrossAmount
						' );
		SET @sBottomInner = CONCAT(@sBottomInner,'		
							,(round((ifnull(payroll_salary.BasicSalary,0) + ifnull(payroll_salary.Allowances,0)),0)) as GrossAmount
						' );


		OPEN curDeduction;
				
	getDeduction: LOOP

			FETCH curDeduction INTO varCommanMasterId,varCommanName;
			IF finishedDeduction = 1 THEN 
				LEAVE getDeduction;
			END IF;

			
			SET @s = CONCAT(@s,'
			,''',varCommanName,''' as Deduction',convert(intRow,char),' 
			,round(sum(case when payroll_salary_detail.CommanMasterId = ',convert(varCommanMasterId,char),' then payroll_salary_detail.Amount else 0 end),0) as DeductionAmount',convert(intRow,char),'
			');

				SET @sTemp = CONCAT(@sTemp,'
				,''',varCommanName,''' as Deduction',convert(intRow,char),' 
				,',convert(varCommanMasterId,char),' as DeductionAmount',convert(intRow,char),'
				');
				
			SET @sBottom = CONCAT(@sBottom,'
			,''',varCommanName,''' as Deduction',convert(intRow,char),' 
			,round(sum(DeductionAmount',convert(intRow,char),'),0) as DeductionAmount',convert(intRow,char),'
			');

			SET @sBottomInner = CONCAT(@sBottomInner,'
			,''',varCommanName,''' as Deduction',convert(intRow,char),' 
			,round(sum(case when payroll_salary_detail.CommanMasterId = ',convert(varCommanMasterId,char),' then payroll_salary_detail.Amount else 0 end),0) as DeductionAmount',convert(intRow,char),'
			');

			set intRow = intRow + 1;
			
		END LOOP getDeduction;
		CLOSE curDeduction;
	end;

	SET @s = CONCAT(@s,'		
						,round(payroll_salary.Deductions,0)Deductions,round(payroll_salary.NetSalary,0)NetSalary,payroll_salary.Remark
						,payroll_salary.RecordStatus,payroll_salary.AddedBy
						,payroll_salary.AddedDate,payroll_salary.UpdatedBy,payroll_salary.UpdatedDate
					' );

	SET @sTemp = CONCAT(@sTemp,'		
					,0 Deductions,0 NetSalary
					,'''' as Remark
					,'''' as RecordStatus,'''' as AddedBy
					,'''' as AddedDate,'''' as UpdatedBy,'''' as UpdatedDate
					' );

	SET @sBottom = CONCAT(@sBottom,'		
						,sum(round(payroll_salary.Deductions,0))Deductions
						,sum(round(payroll_salary.NetSalary,0))NetSalary
						,'''' as Remark
						,'''' as RecordStatus,'''' as AddedBy
						,'''' as AddedDate,'''' as UpdatedBy,'''' as UpdatedDate
					' );
	SET @sBottomInner = CONCAT(@sBottomInner,'		
						,(round(payroll_salary.Deductions,0))Deductions
						,(round(payroll_salary.NetSalary,0))NetSalary
					' );



	SET @s = CONCAT(@s,'
	from payroll_salary
	left join payroll_salary_detail on payroll_salary_detail.SalaryId = payroll_salary.SalaryId
	left join payroll_staff_structure on payroll_staff_structure.LedgerId = payroll_salary.LedgerId 
				and payroll_staff_structure.CommanMasterId = 1 and payroll_staff_structure.RecordStatus != ''D''
	left join ledger on ledger.LedgerId = payroll_salary.LedgerId
	left join login on login.LedgerId = ledger.LedgerId 
	left join role on role.RoleId = login.LoginType and role.RecordStatus != ''D'' and role.OrganizationId = ',convert(varOrganizationId,char),'

	left join comman_master agent on agent.CommanMasterId = ledger.AgentLedgerId and CommanMasterType = 1			
	/*
	left join ledger as directagent on directagent.LedgerId = l.AgentLedgerId
	*/
	inner join ledger_limit on ledger_limit.LedgerId = ledger.LedgerId and ledger_limit.RecordStatus != ''D''

/*		(Select  aa.LedgerId
			,sum((case when aa.AmountType = ''Dr'' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) Closing
			from voucher_detail aa

			WHERE  
					aa.VoucherType != 2
					and aa.RecordStatus != ''D'' 
					and aa.OrganizationId = ',convert(varOrganizationId,char),'
			group by aa.LedgerId 
		) as OPBal on OPBal.LedgerId = ledger.LedgerId
*/
	
	where (payroll_salary.OrganizationId = ',convert(varOrganizationId,char),' )
	and payroll_salary.RecordStatus != ''D''
	and (case when ',convert(ifnull(varMonth,0),char),' = 0 or ',convert(ifnull(varYear,0),char),' = 0 
			then payroll_salary.SalaryDate between ''',convert(varFromDate,char),''' and ''',convert(varToDate,char),''' else 
				payroll_salary.SalaryMonth = ',convert(varMonth,char),'
				and payroll_salary.SalaryYear = ',convert(varYear,char),'
			end)
	and (payroll_salary.LedgerId = ',convert(varLedgerId,char),' or ',convert(ifnull(varLedgerId,0),char),' = 0 )
	and (
		(case when ledger.GroupId in (3,4,5) then 
				(ifnull(agent.LedgerId,0) = ',convert(ifnull(varAgentLedgerId,0),char),' or ',convert(ifnull(varAgentLedgerId,0),char),' = 0)
			else
				(ifnull(ledger.AgentLedgerId,0) = ',convert(ifnull(varAgentLedgerId,0),char),' or ',convert(ifnull(varAgentLedgerId,0),char),' = 0)
			end
		)	
		)
	group by 
		payroll_salary.SalaryId,ledger.LedgerName,login.UserName,login.UserName
		,payroll_salary.SalaryDate
		,payroll_salary.LedgerId,payroll_salary.SalaryMonth,payroll_salary.SalaryYear
		,payroll_salary.WorkingDays,payroll_salary.Present,payroll_salary.TotalEntryCount
		,payroll_salary.BasicSalary,payroll_salary.Allowances
		,payroll_salary.Deductions,payroll_salary.NetSalary,payroll_salary.Remark
		,payroll_salary.RecordStatus,payroll_salary.AddedBy
		,payroll_salary.AddedDate,payroll_salary.UpdatedBy,payroll_salary.UpdatedDate

	')
	;
	SET @sBottom = CONCAT(@sBottom,'
				',@sBottomInner,'
		from payroll_salary
		left join payroll_salary_detail on payroll_salary_detail.SalaryId = payroll_salary.SalaryId
		left join ledger on ledger.LedgerId = payroll_salary.LedgerId

		left join comman_master agent on agent.CommanMasterId = ledger.AgentLedgerId and CommanMasterType = 1			
		/*
		left join ledger as directagent on directagent.LedgerId = l.AgentLedgerId
		*/

		where (payroll_salary.OrganizationId = ',convert(varOrganizationId,char),' )
		and payroll_salary.RecordStatus != ''D''
		and (case when ',convert(ifnull(varMonth,0),char),' = 0 or ',convert(ifnull(varYear,0),char),' = 0 
				then payroll_salary.SalaryDate between ''',convert(varFromDate,char),''' and ''',convert(varToDate,char),''' else 
					payroll_salary.SalaryMonth = ',convert(varMonth,char),'
					and payroll_salary.SalaryYear = ',convert(varYear,char),'
				end)
		and (payroll_salary.LedgerId = ',convert(varLedgerId,char),' or ',convert(ifnull(varLedgerId,0),char),' = 0 )
		and (
		(case when ledger.GroupId in (3,4,5) then 
				(ifnull(agent.LedgerId,0) = ',convert(ifnull(varAgentLedgerId,0),char),' or ',convert(ifnull(varAgentLedgerId,0),char),' = 0)
			else
				(ifnull(ledger.AgentLedgerId,0) = ',convert(ifnull(varAgentLedgerId,0),char),' or ',convert(ifnull(varAgentLedgerId,0),char),' = 0)
			end
		)	
		)
		group by payroll_salary.SalaryId
		,payroll_salary.WorkingDays
		,payroll_salary.TotalDays
		,payroll_salary.Absent
		,payroll_salary.PaidLeave
		,payroll_salary.Present
		,payroll_salary.TotalEntryCount
		,payroll_salary.BasicSalary
		,payroll_salary.Deductions
		,payroll_salary.NetSalary
    ) as payroll_salary
	order by DataFlag,LedgerName,UserName,SalaryYear,SalaryMonth
	')
	
	;


	SET @s = CONCAT(@sTemp,'
			union all
			'
			,@s,'
			union all
			'
			,@sBottom)
	;
	PREPARE stmt FROM @s;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	/*
	select @s;
	*/
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_staff_salary_register_detail`(
	IN varOrganizationId int(20), 
	in varSalaryId bigint
    )
BEGIN

	select payroll_comman_master.CommanName,payroll_salary_detail.SalaryDetailId
		,payroll_salary_detail.OrganizationId,payroll_salary_detail.SalaryId
		,payroll_salary_detail.CommanMasterId,payroll_salary_detail.Amount,payroll_salary_detail.KistId
		,payroll_salary_detail.DetailRemark
		,payroll_comman_master.CommanType
	from payroll_salary_detail 
	join payroll_comman_master on payroll_comman_master.CommanMasterId = payroll_salary_detail.CommanMasterId
	and payroll_comman_master.RecordStatus != 'D'
	where (payroll_salary_detail.OrganizationId = varOrganizationId or ifnull(varOrganizationId,0) = 0)
	and payroll_salary_detail.RecordStatus != 'D'
	and payroll_salary_detail.SalaryId = varSalaryId
	order by payroll_comman_master.CommanOrder
	;	

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_staff_stock`(
IN `varOrganizationId` bigint(21)
, IN `varLedgerId` bigint(21)
)
SELECT payroll_comman_master.CommanName
,payroll_staff_stock.StaffStockId 
,payroll_staff_stock.LedgerId 
,payroll_staff_stock.OrganizationId 
,payroll_staff_stock.CommanMasterId 
,payroll_staff_stock.Amount 
,payroll_staff_stock.Quantity 
,payroll_staff_stock.Brand 
,payroll_staff_stock.BillPartNo 
,payroll_staff_stock.Remark 
,payroll_staff_stock.RecordStatus
,payroll_staff_stock.AddedBy
,payroll_staff_stock.AddedDate
,payroll_staff_stock.UpdatedBy
,payroll_staff_stock.UpdatedDate

FROM payroll_staff_stock  
join payroll_comman_master  on payroll_staff_stock.CommanMasterId = payroll_comman_master.CommanMasterId
where payroll_staff_stock.LedgerId = varLedgerId
and (ifnull(payroll_staff_stock.OrganizationId,0) = varOrganizationId )
and payroll_staff_stock.RecordStatus != 'D'
order by payroll_comman_master.CommanOrder$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_staff_structure`(
IN `varOrganizationId` bigint(21)
, IN `varLedgerId` bigint(21)
, IN `varCommanMasterType` int
)
SELECT payroll_comman_master.CommanName
,payroll_comman_master.CommanType
,payroll_staff_structure.StructureId 
,payroll_staff_structure.LedgerId 
,payroll_staff_structure.OrganizationId 
,payroll_staff_structure.CommanMasterId 
,payroll_staff_structure.Amount 
,payroll_staff_structure.AmountType 
,payroll_staff_structure.Remark 
,payroll_staff_structure.RecordStatus
,payroll_staff_structure.AddedBy
,payroll_staff_structure.AddedDate
,payroll_staff_structure.UpdatedBy
,payroll_staff_structure.UpdatedDate

FROM payroll_staff_structure  
join payroll_comman_master  on payroll_staff_structure.CommanMasterId = payroll_comman_master.CommanMasterId
where payroll_comman_master.CommanType = varCommanMasterType
and payroll_staff_structure.LedgerId = varLedgerId
and (ifnull(payroll_staff_structure.OrganizationId,0) = varOrganizationId )
and payroll_staff_structure.RecordStatus != 'D'
order by payroll_comman_master.CommanOrder$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_staff_structure_default`(
IN `varOrganizationId` bigint(21)
, IN `varCommanMasterType` int
, IN `varCommanMasterId` bigint
)
SELECT payroll_comman_master.CommanName
,payroll_comman_master.CommanType
,payroll_staff_structure_default.DefaultStructureId 
,payroll_staff_structure_default.OrganizationId 
,payroll_staff_structure_default.RoleId 
,payroll_staff_structure_default.CommanMasterId 
,payroll_staff_structure_default.Amount 
,payroll_staff_structure_default.AmountType 
,payroll_staff_structure_default.Remark 
,payroll_staff_structure_default.RecordStatus
,payroll_staff_structure_default.AddedBy
,payroll_staff_structure_default.AddedDate
,payroll_staff_structure_default.UpdatedBy
,payroll_staff_structure_default.UpdatedDate

FROM payroll_staff_structure_default  
join payroll_comman_master  on payroll_staff_structure_default.CommanMasterId = payroll_comman_master.CommanMasterId
where payroll_comman_master.CommanType = varCommanMasterType
and (ifnull(payroll_staff_structure_default.CommanMasterId,0) = varCommanMasterId or varCommanMasterId = 0 )
and (ifnull(payroll_staff_structure_default.OrganizationId,0) = varOrganizationId )
and payroll_staff_structure_default.RecordStatus != 'D'
order by payroll_comman_master.CommanOrder$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_rpt_stock_issue_return`(
IN `varOrganizationId` bigint(21)
, IN `varStaffStockId` bigint(21)
)
SELECT payroll_comman_master.CommanName
,payroll_issue_return_stock.IssueReturnStockId 
,payroll_issue_return_stock.StaffStockId 
,payroll_issue_return_stock.LedgerId 
,payroll_issue_return_stock.OrganizationId 
,payroll_issue_return_stock.CommanMasterId 
,payroll_issue_return_stock.IssueDate 
,payroll_issue_return_stock.Amount 
,payroll_issue_return_stock.Quantity 
,payroll_issue_return_stock.Brand 
,payroll_issue_return_stock.BillPartNo 
,payroll_issue_return_stock.IsReturn 
,payroll_issue_return_stock.Remark 
,payroll_issue_return_stock.RecordStatus
,payroll_issue_return_stock.AddedBy
,payroll_issue_return_stock.AddedDate
,payroll_issue_return_stock.UpdatedBy
,payroll_issue_return_stock.UpdatedDate

FROM payroll_issue_return_stock  
join payroll_comman_master  on payroll_issue_return_stock.CommanMasterId = payroll_comman_master.CommanMasterId
where payroll_issue_return_stock.StaffStockId = varStaffStockId
and (ifnull(payroll_issue_return_stock.OrganizationId,0) = varOrganizationId )
and payroll_issue_return_stock.RecordStatus != 'D'
order by payroll_issue_return_stock.IssueDate desc,payroll_issue_return_stock.AddedDate desc$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_sys_staff_attendance_create`(
	IN varOrganizationId int(20), 
	IN varMonth int,
	IN varYear int,
	in varLedgerId bigint
    )
BEGIN

			
	declare varFromDate datetime;
	declare varToDate datetime;
	
	set varFromDate = CONVERT( CONCAT(convert(varYear,char),'-',convert(varMonth,char) ,'-',convert(01,char)),DATE);
	if varMonth <> 12 then
		set varToDate = CONVERT( CONCAT(convert(varYear,char),'-',convert(varMonth+1,char) ,'-',convert(01,char)),DATE);
	else
		set varToDate = CONVERT( CONCAT(convert(varYear+1,char),'-',convert(01,char) ,'-',convert(01,char)),DATE);
	end if;
	set varToDate = DATE_ADD(varToDate, INTERVAL -1 DAY);
				
	if exists (select LedgerId from payroll_salary where (OrganizationId = varOrganizationId or ifnull(varOrganizationId,0) = 0)
				and SalaryMonth = varMonth
				and SalaryYear = varYear and VoucherId != 0 and RecordStatus != 'D') then	
		select 	0 as UpdateTable;
	
	else
		delete from payroll_attendance 
		where (OrganizationId = varOrganizationId or ifnull(varOrganizationId,0) = 0)
		and AttendanceMonth = varMonth
		and AttendanceYear = varYear
		;
		
		insert into payroll_attendance(
		  OrganizationId ,
		  LedgerId ,
		  AttendanceDate , AttendanceMonth , AttendanceYear ,
		  WorkingDays ,
		  TotalDays ,
		  Absent ,
		  PaidLeave ,
		  Present ,
		  MonthEndLeaveApplicable ,
		  TotalEntryCount ,
		  Remark ,  
		  RecordStatus ,
		  AddedBy ,
		  AddedDate ,
		  UpdatedBy ,
		  UpdatedDate 
		)
			select 
			Atten.OrganizationId
			,Atten.LedgerId
			,convert(CURRENT_TIMESTAMP(),date),varMonth,varYear
			,datediff(varToDate,varFromDate) as WorkingDays
			,datediff(varToDate,varFromDate) + 1 as TotalDays
			,ifnull((select count(1) from payroll_leave where payroll_leave.RecordStatus != 'D' and Month(LeaveDate) = varMonth and Year(LeaveDate) = varYear 
						and payroll_leave.LedgerId = Atten.LedgerId and ifnull(payroll_leave.IsPaid,0) = 0),0)
			,ifnull((select count(1) from payroll_leave where payroll_leave.RecordStatus != 'D' and Month(LeaveDate) = varMonth and Year(LeaveDate) = varYear 
						and payroll_leave.LedgerId = Atten.LedgerId and ifnull(payroll_leave.IsPaid,0) = 1),0)
			,(case when Atten.LoginType in (11) then 
					sum(case when ifnull(Atten.EntryCount,0) < 1000 then 0 else 1 end)							
				when Atten.LoginType in (12) then 
					sum(case when ifnull(Atten.EntryCount,0) < 10 then 0 else 1 end)							
				else 
					(datediff(varToDate,varFromDate) ) 
					- ifnull((select count(1) from payroll_leave where payroll_leave.RecordStatus != 'D' and Month(LeaveDate) = varMonth and Year(LeaveDate) = varYear
							and payroll_leave.LedgerId = Atten.LedgerId ),0)
				end )as Present
			,(case when Atten.LoginType in (11) then 
					ifnull((case when sum(case when ifnull(Atten.EntryCount,0) < 500 then 0 else 1 end) >= datediff(varToDate,varFromDate) then 1 else 0 end),0)
				else 
					0
				end )as MonthEndLeaveApplicable
			/*,(case when Atten.LoginType in (11,12) then 
					sum(case when ifnull(Atten.EntryCount,0) < 500 then 0 else 1 end)
					+ (case when sum(case when ifnull(Atten.EntryCount,0) < 500 then 0 else 1 end) >= 15 then 1 else 0 end)
				else 
					(datediff(varToDate,varFromDate) + 1) 
				end )as Attendance
			*/
			,ifnull(sum(Atten.EntryCount),0) EntryCount
			,'' as Remark
			,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP()
			from (
				select ledger.OrganizationId,ledger.LedgerId,ledger.LedgerName,login.UserName,day_transaction.TransactionDate,EntryCount
				,login.Mobile
				,login.Address 
				,login.LoginType
				
				from (select ledger.OrganizationId,ledger.LedgerId,ledger.LedgerName from ledger 
					where (ledger.OrganizationId = varOrganizationId or ifnull(varOrganizationId,0) = 0)
					and (ifnull(ledger.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
					and ledger.GroupId in (2,3,5,6,7)
					and ledger.RecordStatus != 'D') as ledger
				inner join (select LedgerId from payroll_staff_structure where RecordStatus != 'D' group by LedgerId) 
					as payroll_staff_structure on ledger.LedgerId = payroll_staff_structure.LedgerId
				left join login on login.LedgerId = ledger.LedgerId and LoginType not in (2,7) 
				left join (
					select transaction_declare.OrganizationId, DATE(transaction_declare.TransactionDate) as TransactionDate 
					,transaction_declare.AddedBy,sum(EntryCount) as EntryCount 
					from 
						(select transaction_declare.OrganizationId, DATE(transaction_declare.TransactionDate) as TransactionDate 
						,transaction_declare.AddedBy,count(1) as EntryCount 
						from transaction_detail_declare  
						Join transaction_declare on transaction_detail_declare.TransactionId = transaction_declare.TransactionId
						where transaction_declare.OrganizationId = varOrganizationId
						and transaction_detail_declare.RecordStatus != 'D'
						and transaction_declare.RecordStatus != 'D'
						and DATE(transaction_declare.TransactionDate) between varFromDate and varToDate 
						group by DATE(transaction_declare.TransactionDate),transaction_declare.AddedBy
						union all
						SELECT t.OrganizationId,t.ShiftDate
						, t.AddedBy ,count(1) as EntryCount 
						from transaction_audit t 
						where (t.RecordStatus != 'D')
						and (t.ShiftDate between varFromDate and varToDate)
						and t.OrganizationId = varOrganizationId
						group by t.ShiftDate, t.AddedBy					
						) as transaction_declare
					group by TransactionDate,transaction_declare.OrganizationId,transaction_declare.AddedBy
				) as day_transaction on login.UserName = day_transaction.AddedBy
				order by ledger.LedgerName,day_transaction.TransactionDate
			) as Atten
			group by Atten.OrganizationId,Atten.LedgerId,Atten.LoginType,Atten.LedgerName,Atten.UserName
			,Atten.Mobile
			,Atten.Address 
		;
		select 	1 as UpdateTable;
	end if;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_sys_staff_salary_create`(
	IN varOrganizationId int(20), 
	IN varMonth int,
	IN varYear int,
	in varLedgerId bigint
    )
BEGIN

	DECLARE finishedorganization INTEGER DEFAULT 0;
	DEClARE curorganization 
		CURSOR FOR 
		select OrganizationId from organization 
		where (ifnull(OrganizationId,0) = varOrganizationId or ifnull(varOrganizationId,0) = 0 ) 
		and RecordStatus != 'D'
		and (ifnull(IsAutoSalaryCreate,0) = 1 or ifnull(varOrganizationId,0) <> 0)
	;
	
	DECLARE CONTINUE HANDLER 
	FOR NOT FOUND SET finishedorganization = 1;

	if exists (select SalaryId from payroll_salary 
					where OrganizationId = varOrganizationId
					and SalaryMonth = varMonth
					and SalaryYear = varYear
					and ifnull(VoucherId,0) != 0
					and (ifnull(LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0)
					) then	
		select 0 Flag ;
	else
		OPEN curorganization;
				
		getOrganization: LOOP

			FETCH curorganization INTO varOrganizationId;
			IF finishedorganization = 1 THEN 
				LEAVE getOrganization;
			END IF;

			begin
				declare varSalaryId bigint;
				
				declare varLoopLedgerId bigint;
				declare varRoleId bigint;
				declare varAttendance int;
				declare varMonthEndLeaveApplicable int;
				declare varWorkingDays int;
				declare varTotalDays int;
				declare varAbsent int;
				declare varPaidLeave int;

				declare varEntryCount int;
				declare varSalaryCommanMasterId int;
				
				declare  varBasicSalaryAmount float;
				declare  varNetAmount float;
				declare  varTotalAllowance float;
				declare  varTotalDeduction float;
				
				declare  varCommanMasterId bigint;
				declare  varAmount float;
				declare  varAmountType int;
				declare  varCommanOrder int;
				declare  varCommanType int;
				
				set varSalaryCommanMasterId = 100;
							
				set varSalaryId = 0;
				
				delete from payroll_salary_detail 
				where SalaryId in (Select payroll_salary.SalaryId from payroll_salary where OrganizationId = varOrganizationId
						and (LedgerId = varLedgerId or varLedgerId = 0 )
						and SalaryMonth = varMonth
						and SalaryYear = varYear)
				;	
				delete from payroll_salary 
				where OrganizationId = varOrganizationId
				and (LedgerId = varLedgerId or varLedgerId = 0)
				and SalaryMonth = varMonth
				and SalaryYear = varYear
				;
				
				/*
				salary not created for 
				(RoleId not equal to 1,3,4,5)
				
				or Group Id = 2 & 7
				*/
				begin
					DECLARE finished INTEGER DEFAULT 0;
					DEClARE curLedger 
						CURSOR FOR 
						select 
						payroll_attendance.LedgerId,login.LoginType
						,ifnull(payroll_attendance.Present,0) as Attendance
						,ifnull(payroll_attendance.MonthEndLeaveApplicable,0) as MonthEndLeaveApplicable
						,payroll_attendance.WorkingDays 
						,payroll_attendance.TotalDays
						,payroll_attendance.Absent
						,payroll_attendance.PaidLeave
						,payroll_attendance.TotalEntryCount 
						
						from payroll_attendance 
						left join login on login.LedgerId = payroll_attendance.LedgerId 
						where (payroll_attendance.OrganizationId = varOrganizationId or ifnull(varOrganizationId,0) = 0)
						and payroll_attendance.AttendanceMonth = varMonth
						and payroll_attendance.AttendanceYear = varYear
						and (payroll_attendance.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0 )
						order by payroll_attendance.LedgerId
						;	

						
					DECLARE CONTINUE HANDLER 
					FOR NOT FOUND SET finished = 1;
					
					OPEN curLedger;
							
					getLedger: LOOP

						FETCH curLedger INTO varLoopLedgerId,varRoleId,varAttendance,varMonthEndLeaveApplicable,varWorkingDays,varTotalDays,varAbsent,varPaidLeave,varEntryCount;
						IF finished = 1 THEN 
							LEAVE getLedger;
						END IF;
						
						/* Insert Salary Table */

						insert into payroll_salary(OrganizationId,SalaryDate
						,LedgerId,SalaryMonth,SalaryYear
						,WorkingDays,TotalDays,Absent,PaidLeave
						,Present,TotalEntryCount
						,BasicSalary,Allowances,Deductions,NetSalary,Remark
						,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
						values(varOrganizationId,convert(CURRENT_TIMESTAMP(),date)
						,varLoopLedgerId,varMonth,varYear
						,varWorkingDays,varTotalDays,varAbsent,varPaidLeave
						,varAttendance,varEntryCount
						,0,0,0,0,''
						,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
						;
							
						set varSalaryId = LAST_INSERT_ID();
						
						/* Salary detail loop start from here */

						Set varBasicSalaryAmount = 0;
						Set varNetAmount = 0;
						Set varTotalAllowance = 0;
						Set varTotalDeduction = 0;
						if varAttendance > 0 then
							begin		
								DECLARE finishedsalarydetail INTEGER DEFAULT 0;		
								DEClARE cursalarydetail 
									CURSOR FOR 
									select payroll_staff_structure.CommanMasterId,payroll_staff_structure.Amount,payroll_staff_structure.AmountType
									,payroll_comman_master.CommanType,payroll_comman_master.CommanOrder
									from payroll_staff_structure
									join payroll_comman_master on payroll_comman_master.CommanMasterId = payroll_staff_structure.CommanMasterId
									and payroll_comman_master.RecordStatus != 'D'
									where payroll_staff_structure.LedgerId = varLoopLedgerId
									and payroll_staff_structure.OrganizationId = varOrganizationId
									#and payroll_staff_structure.CommanMasterId <> varSalaryCommanMasterId
									and payroll_staff_structure.RecordStatus != 'D'
									union all 
									select payroll_staff_structure_default.CommanMasterId,payroll_staff_structure_default.Amount,payroll_staff_structure_default.AmountType
									,payroll_comman_master.CommanType,payroll_comman_master.CommanOrder
									from payroll_staff_structure_default
									join payroll_comman_master on payroll_comman_master.CommanMasterId = payroll_staff_structure_default.CommanMasterId
									where payroll_staff_structure_default.OrganizationId = varOrganizationId
									and payroll_staff_structure_default.RoleId = varRoleId
									#and payroll_staff_structure_default.CommanMasterId <> varSalaryCommanMasterId
									and payroll_staff_structure_default.RecordStatus != 'D'
									order by CommanMasterId
								;
								
								DECLARE CONTINUE HANDLER 
								FOR NOT FOUND SET finishedsalarydetail = 1;
											
								OPEN cursalarydetail;
								getsalarydetail: LOOP

									FETCH cursalarydetail INTO varCommanMasterId,varAmount,varAmountType,varCommanType,varCommanOrder;
									IF finishedsalarydetail = 1 THEN 
										LEAVE getsalarydetail;
									END IF;

									if varCommanMasterId = 2 then
										if varRoleId = 11 or varRoleId = 12  then
											if varMonthEndLeaveApplicable = 1 then
												Set varAmount = varAmount;					
											else
												Set varAmount = 0;					
											end if;
										end if;
									elseif varCommanMasterId = 11 then
										begin
											DECLARE varKistId bigint;
											DECLARE finishedkist INTEGER DEFAULT 0;
											DEClARE curkist 
												CURSOR FOR 
											select Amount,KistId from kist
											where RecordStatus = 'A'
											and KistStatus = 'UNPAID'
											#and month(kist.KistDate) = varMonth
											and kist.KistDate <= CURRENT_TIMESTAMP()
											and LedgerId = varLoopLedgerId;
											
											DECLARE CONTINUE HANDLER 
											FOR NOT FOUND SET finishedkist = 1;

											OPEN curkist;
													
											getkist: LOOP

												FETCH curkist INTO varAmount,varKistId;
												IF finishedkist = 1 THEN 
													LEAVE getkist;
												END IF;

												Set varTotalDeduction = varTotalDeduction + varAmount;
												Set varNetAmount = varNetAmount - varAmount;

												insert into payroll_salary_detail(OrganizationId,SalaryId
												,CommanMasterId,Amount,KistId
												,DetailRemark
												,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
												values(varOrganizationId,varSalaryId
												,varCommanMasterId,varAmount,varKistId
												,''
												,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
												;
											

											END LOOP getkist;
											CLOSE curkist;
										end;
									else
										if varAmountType = 1 then
											Set varAmount = varAmount;					
										elseif varAmountType = 2 then
											Set varAmount = varAmount * varBasicSalaryAmount / 100 ;
										elseif varAmountType = 3 then
											Set varAmount = varAmount * varEntryCount ;
										end if;
									end if;
									
									if varCommanMasterId != 11 then
										if varCommanMasterId = 1 then #CommanMasterId of BasicSalary = 1
											if varTotalDays > 1 then
												Set varAmount = (varAmount * (varAttendance + varPaidLeave))/(varTotalDays - 1);					
												Set varBasicSalaryAmount = varAmount;					
												Set varNetAmount = varNetAmount + varBasicSalaryAmount;
											end if;
										else
											if varCommanType = 2 then
												Set varTotalAllowance = varTotalAllowance + varAmount;
												Set varNetAmount = varNetAmount + varAmount;
											elseif varCommanType = 3 then
												Set varTotalDeduction = varTotalDeduction + varAmount;
												Set varNetAmount = varNetAmount - varAmount;
											end if;
										end if;
										
										/* Insert Salary Detail Table */

										insert into payroll_salary_detail(OrganizationId,SalaryId
										,CommanMasterId,Amount,KistId
										,DetailRemark
										,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
										values(varOrganizationId,varSalaryId
										,varCommanMasterId,varAmount,0
										,''
										,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
										;
									end if;
									
								END LOOP getsalarydetail;
								CLOSE cursalarydetail;
							end;
						end if;
						
						update payroll_salary set BasicSalary = varBasicSalaryAmount
						,Allowances = varTotalAllowance
						,Deductions = varTotalDeduction
						,NetSalary = varNetAmount
						where SalaryId = varSalaryId
						;
						
						
						/* create voucher for salary */
						/*
						call payroll_sys_staff_salary_paid(varOrganizationId,varSalaryId);
						*/
						
					END LOOP getLedger;
					CLOSE curLedger;
				end;
			end;
		END LOOP getorganization;
		CLOSE curorganization;
		
		select 1 Flag;
	end if;
	
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_sys_staff_salary_paid`(
	IN varOrganizationId int(20), 
	IN varMonth int,
	IN varYear int,
	in varLedgerId bigint
	,in varSalaryId bigint
    )
BEGIN
	declare varVoucherId bigint;
	declare varAmount float;
	declare varDeductions float;
	declare varVoucherType int;
	declare varSalaryLedgerId int;

	declare varKistVoucherType int;
	declare varKistLedgerId int;
	
	
	DECLARE finished INTEGER DEFAULT 0;
	DEClARE curLedger 
		CURSOR FOR 
		select SalaryId,LedgerId,Deductions,NetSalary 
			from payroll_salary
			where (payroll_salary.OrganizationId = varOrganizationId  )
			and (ifnull(LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and (ifnull(SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
			and ifnull(VoucherId ,0 ) = 0 
			and payroll_salary.RecordStatus != 'D'
			and payroll_salary.SalaryMonth = varMonth
			and payroll_salary.SalaryYear = varYear
		;
	
	
	DECLARE CONTINUE HANDLER 
	FOR NOT FOUND SET finished = 1;

/*    
	delete from voucher where VoucherId in (
		select VoucherId 
			from payroll_salary
			where (payroll_salary.OrganizationId = varOrganizationId  )
			and (ifnull(LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and (ifnull(SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
			and payroll_salary.RecordStatus != 'D'
			and payroll_salary.SalaryMonth = varMonth
			and payroll_salary.SalaryYear = varYear
			)
		;
	delete from voucher_detail where VoucherId in (
		select VoucherId 
			from payroll_salary
			where (payroll_salary.OrganizationId = varOrganizationId  )
			and (ifnull(LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and (ifnull(SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
			and payroll_salary.RecordStatus != 'D'
			and payroll_salary.SalaryMonth = varMonth
			and payroll_salary.SalaryYear = varYear
			)
		;

		update payroll_salary set VoucherId = 0 
			where (payroll_salary.OrganizationId = varOrganizationId  )
			and (ifnull(LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and (ifnull(SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
			and payroll_salary.RecordStatus != 'D'
			and payroll_salary.SalaryMonth = varMonth
			and payroll_salary.SalaryYear = varYear
		;
*/
		
	set varVoucherType = 1;   #voucher type 1 for genral voucher
	set varSalaryLedgerId = 14;  #Salary Account LedgerId

	set varKistVoucherType = 3;   #voucher type 1 for kist voucher
	set varKistLedgerId = 7;  #kist Account LedgerId

	OPEN curLedger;
			
	getLedger: LOOP

		FETCH curLedger INTO varSalaryId,varLedgerId,varDeductions,varAmount;
		IF finished = 1 THEN 
			LEAVE getLedger;
		END IF;


		begin
			DECLARE varKistId bigint;
			DECLARE varKistAmount float;
			DECLARE varKistStatus varchar(20);
			
			DECLARE finishedkist INTEGER DEFAULT 0;
			DEClARE curkist 
				CURSOR FOR 
			select payroll_salary_detail.KistId,payroll_salary_detail.Amount,kist.KistStatus from payroll_salary_detail
			join kist on kist.KistId = payroll_salary_detail.KistId
			where payroll_salary_detail.RecordStatus = 'A'
			and payroll_salary_detail.OrganizationId = varOrganizationId
			and payroll_salary_detail.SalaryId = varSalaryId
			and payroll_salary_detail.KistId != 0
			;
			DECLARE CONTINUE HANDLER 
			FOR NOT FOUND SET finishedkist = 1;

			OPEN curkist;
					
			getkist: LOOP

				FETCH curkist INTO varKistId,varKistAmount,varKistStatus;
				IF finishedkist = 1 THEN 
					LEAVE getkist;
				END IF;
				set varDeductions = varDeductions - varKistAmount;
				set varAmount = varAmount + varKistAmount;
				
				if varKistStatus = 'UNPAID' then
					set varVoucherId = 0;
					
					insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
					,Amount,Remark,LagaiKhai
					,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
					values(varOrganizationId,date(CURRENT_TIMESTAMP()),0,varKistVoucherType,'AUTO',varKistAmount,'KIST IN SALARY',1
					,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
					;
					
					
					set varVoucherId = LAST_INSERT_ID();

					insert into voucher_detail(OrganizationId,
					VoucherId
					,LedgerId
					,VoucherDetailType,ShiftId
					,VoucherDate
					,VoucherType
					,Amount
					,AmountType
					,OppositeLedgerId
					,Flag1
					,Remark,SelfHissa,OtherHissa
					,MondayFinalFlag,VoucherMode,FromLedgerId
					,OpenAmount
					,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
					)
					values(varOrganizationId,varVoucherId
					,varLedgerId
					,0,0
					,date(CURRENT_TIMESTAMP())
					,varKistVoucherType
					,varKistAmount
					,'Dr'
					,varKistLedgerId
					,'','',0,0
					,'False','AUTO',0
					,0
					,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
					;

					insert into voucher_detail(OrganizationId,
					VoucherId
					,LedgerId
					,VoucherDetailType,ShiftId
					,VoucherDate
					,VoucherType
					,Amount
					,AmountType
					,OppositeLedgerId
					,Flag1
					,Remark,SelfHissa,OtherHissa
					,MondayFinalFlag,VoucherMode,FromLedgerId
					,OpenAmount
					,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
					)
					values(varOrganizationId,varVoucherId
					,varKistLedgerId
					,0,0
					,date(CURRENT_TIMESTAMP())
					,varKistVoucherType
					,varKistAmount
					,'Cr'
					,varLedgerId
					,'','',0,0
					,'False','AUTO',0
					,0
					,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
					;
						
					update kist set PaidVoucherId = varVoucherId
						,KistStatus = 'PAID'
						where ifnull(KistId,0) = varKistId 
					;
				end if;

			END LOOP getkist;
			CLOSE curkist;
		end;
	
		set varVoucherId = 0;
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,date(CURRENT_TIMESTAMP()),0,varVoucherType,'AUTO',varAmount,'SALARY',1
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		
		set varVoucherId = LAST_INSERT_ID();

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,varVoucherId
		,varLedgerId
		,0,0
		,date(CURRENT_TIMESTAMP())
		,varVoucherType
		,varAmount
		,'Cr'
		,varSalaryLedgerId
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;

		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,varVoucherId
		,varSalaryLedgerId
		,0,0
		,date(CURRENT_TIMESTAMP())
		,varVoucherType
		,varAmount
		,'Dr'
		,varLedgerId
		,'','',0,0
		,'False','AUTO',0
		,0
		,'A','SERVER',CURRENT_TIMESTAMP(),'SERVER',CURRENT_TIMESTAMP())
		;
			
		update payroll_salary set VoucherId = varVoucherId
			where ifnull(SalaryId,0) = varSalaryId 
		;


	END LOOP getLedger;
	CLOSE curLedger;
			
	select 1 as Flag;
	

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `payroll_sys_staff_salary_unpaid`(
	IN varOrganizationId int(20), 
	IN varMonth int,
	IN varYear int,
	in varLedgerId bigint
	,in varSalaryId bigint
    )
BEGIN
	DECLARE VoucherIds varchar(5000)
	;
	select kist.PaidVoucherId into VoucherIds
	from kist 
	join payroll_salary_detail on payroll_salary_detail.KistId = kist.KistId
	join payroll_salary on payroll_salary.SalaryId = payroll_salary_detail.SalaryId
	where (payroll_salary.OrganizationId = varOrganizationId  )
	and (ifnull(payroll_salary.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
	and (ifnull(payroll_salary.SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
	and ifnull(payroll_salary.VoucherId ,0 ) != 0 
	and payroll_salary.RecordStatus != 'D'
	and payroll_salary_detail.RecordStatus != 'D'
	and payroll_salary.SalaryMonth = varMonth
	and payroll_salary.SalaryYear = varYear
	;
	
	/* Kist voucher delete */
	delete from voucher 
	where FIND_IN_SET(VoucherId, VoucherIds)
	;
/*	
	where VoucherId in (
			select kist.PaidVoucherId
			from kist 
			join payroll_salary_detail on payroll_salary_detail.KistId = kist.KistId
			join payroll_salary on payroll_salary.SalaryId = payroll_salary_detail.SalaryId
			where (payroll_salary.OrganizationId = varOrganizationId  )
			and (ifnull(payroll_salary.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and (ifnull(payroll_salary.SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
			and ifnull(payroll_salary.VoucherId ,0 ) != 0 
			and payroll_salary.RecordStatus != 'D'
			and payroll_salary_detail.RecordStatus != 'D'
			and payroll_salary.SalaryMonth = varMonth
			and payroll_salary.SalaryYear = varYear
	)
	;
*/

	delete from voucher_detail 
	where FIND_IN_SET(VoucherId, VoucherIds)
	;

/*	where VoucherId in (
			select kist.PaidVoucherId
			from kist 
			join payroll_salary_detail on payroll_salary_detail.KistId = kist.KistId
			join payroll_salary on payroll_salary.SalaryId = payroll_salary_detail.SalaryId
			where (payroll_salary.OrganizationId = varOrganizationId  )
			and (ifnull(payroll_salary.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and (ifnull(payroll_salary.SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
			and ifnull(payroll_salary.VoucherId ,0 ) != 0 
			and payroll_salary.RecordStatus != 'D'
			and payroll_salary_detail.RecordStatus != 'D'
			and payroll_salary.SalaryMonth = varMonth
			and payroll_salary.SalaryYear = varYear
	)
	;
*/
	
	/*   Kist Update */
	update kist set PaidVoucherId = 0
		,KistStatus = 'UNPAID'
		where ifnull(KistId,0) in (
			select payroll_salary_detail.KistId
			from payroll_salary_detail 
			join payroll_salary on payroll_salary.SalaryId = payroll_salary_detail.SalaryId
			where (payroll_salary.OrganizationId = varOrganizationId  )
			and (ifnull(payroll_salary.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and (ifnull(payroll_salary.SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
			and ifnull(payroll_salary.VoucherId ,0 ) != 0 
			and payroll_salary.RecordStatus != 'D'
			and payroll_salary_detail.RecordStatus != 'D'
			and payroll_salary.SalaryMonth = varMonth
			and payroll_salary.SalaryYear = varYear
	)
	; 


	/*   Salary Voucher Delete */

	select VoucherId into VoucherIds
		from payroll_salary
		where (payroll_salary.OrganizationId = varOrganizationId  )
		and (ifnull(payroll_salary.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
		and (ifnull(payroll_salary.SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
		and ifnull(payroll_salary.VoucherId ,0 ) != 0 
		and payroll_salary.RecordStatus != 'D'
		and payroll_salary.SalaryMonth = varMonth
		and payroll_salary.SalaryYear = varYear
	;


	delete from voucher 
	where FIND_IN_SET(VoucherId, VoucherIds)
	;

/*	
	where VoucherId in (
		select VoucherId
			from payroll_salary
			where (payroll_salary.OrganizationId = varOrganizationId  )
			and (ifnull(payroll_salary.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and (ifnull(payroll_salary.SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
			and ifnull(payroll_salary.VoucherId ,0 ) != 0 
			and payroll_salary.RecordStatus != 'D'
			and payroll_salary.SalaryMonth = varMonth
			and payroll_salary.SalaryYear = varYear
	)
	;
*/

	delete from voucher_detail 
	where FIND_IN_SET(VoucherId, VoucherIds)
	;

/*	where VoucherId in (
		select VoucherId
			from payroll_salary
			where (payroll_salary.OrganizationId = varOrganizationId  )
			and (ifnull(payroll_salary.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and (ifnull(payroll_salary.SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
			and ifnull(payroll_salary.VoucherId ,0 ) != 0 
			and payroll_salary.RecordStatus != 'D'
			and payroll_salary.SalaryMonth = varMonth
			and payroll_salary.SalaryYear = varYear
	)
	;
*/

	/*   Salary update */
	update payroll_salary set VoucherId = 0
		where (payroll_salary.OrganizationId = varOrganizationId  )
		and (ifnull(payroll_salary.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
		and (ifnull(payroll_salary.SalaryId,0) = varSalaryId or ifnull(varSalaryId,0) = 0 )
		and ifnull(payroll_salary.VoucherId ,0 ) != 0 
		and payroll_salary.RecordStatus != 'D'
		and payroll_salary.SalaryMonth = varMonth
		and payroll_salary.SalaryYear = varYear
	;
	
	select 1 as Flag;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `process_hp_voucher`(
in varOrganizationId bigint(21)
,in varLedgerId bigint
,in varHPLedgerId bigint
,in varTransactionDate DATE
,in varFromDate DATE
,in varToDate DATE
,in varHPBaseAmount float 
,in varAmount float
,in varHPPercent float
,in varLoginUserName varchar(50)      

)
begin

declare VoucherId BIGINT default 0;

declare varVoucherType smallint default 5;
declare varOppositLedgerId smallint default 11;

declare varShiftId smallint default 0;


			
	set varVoucherType = 5;
	set varOppositLedgerId = 11;
	set varShiftId = 0;


		
		/*      Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_HP',0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
		;
			
  
		set VoucherId = LAST_INSERT_ID();

		/* HP to party */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varHPLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,(case when varAmount > 0 then varAmount else -varAmount end)
		,(case when varAmount > 0 then 'Cr' else 'Dr' end)
		,varOppositLedgerId
		,varLedgerId,(select max(LedgerName) from ledger where LedgerId = varLedgerId),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
		;
		

		/* HP from HP Account */
		
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varOppositLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,(case when varAmount > 0 then varAmount else -varAmount end)
		,(case when varAmount > 0 then 'Dr' else 'Cr' end)
		,varHPLedgerId
		,varLedgerId,(select max(LedgerName) from ledger where LedgerId = varLedgerId),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
		)
        ;

		/*      HP Table Entry */

		INSERT INTO hp_hissa
		(
		OrganizationId,
		LedgerId,
		HPLedgerId,
		VoucherId,
		VoucherDate,
		HPFromDate,
		HPToDate,
		BaseAmount,
		HPPercent,
		HPAmount,
		RecordStatus,
		AddedBy,
		AddedDate,
		UpdatedBy,
		UpdatedDate)
		VALUES
		(
		varOrganizationId,
		varLedgerId,
		varHPLedgerId,
		VoucherId,
		varTransactionDate,
		varFromDate,
		varToDate,
		varHPBaseAmount,
		varHPPercent,
		varAmount,
		'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP());

	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `process_vapsi_voucher`(
in varOrganizationId bigint(21)
,in varLedgerId bigint
,in varTransactionDate DATE
,in varFromDate DATE
,in varToDate DATE
,in varVapsiBaseAmount float 
,in varAmount float
,in varVapsiPercent float
,in varVapsiAmountOn int    #1 for P&L 2 for Payment
,in varLoginUserName varchar(50)      

)
begin

declare VoucherId BIGINT default 0;

declare varVoucherType smallint default 4;
declare varOppositLedgerId smallint default 5;

declare varShiftId smallint default 0;


			
	set varVoucherType = 4;
	set varOppositLedgerId = 5;
	set varShiftId = 0;


		
		/*      Voucher */
		
		insert into voucher(OrganizationId,VoucherDate,ShiftId,VoucherType,VoucherMode
		,Amount,Remark,LagaiKhai
		,RecordStatus,AddedBy,AddedDate,UpdatedBy,UpdatedDate)
		values(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_VAPSI',0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
		;
			
  
		set VoucherId = LAST_INSERT_ID();

		/* Vapsi to party */
		
		if varVapsiPercent - ifnull((select sum(Vapsi)
						from third_party_vapsi 
						where LedgerId = varLedgerId
						and RecordStatus != 'D'
					),0) <> 0 then 
		
			insert into voucher_detail(OrganizationId,
			VoucherId
			,LedgerId
			,VoucherDetailType,ShiftId
			,VoucherDate
			,VoucherType
			,Amount
			,AmountType
			,OppositeLedgerId
			,Flag1
			,Remark,SelfHissa,OtherHissa
			,MondayFinalFlag,VoucherMode,FromLedgerId
			,OpenAmount
			,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
			)
			values(varOrganizationId,VoucherId
			,varLedgerId
			,0,varShiftId
			,varTransactionDate
			,varVoucherType
			,(varAmount * (varVapsiPercent - ifnull((select sum(Vapsi)
							from third_party_vapsi 
							where LedgerId = varLedgerId
							and RecordStatus != 'D'
						),0))/varVapsiPercent) 
			,'Cr'
			,varOppositLedgerId
			,'','SELF',0,0
			,'False','AUTO',0
			,0
			,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP())
			;
		end if;
		
		/* Vapsi to TPV */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,(case when third_party_vapsi.VapsiLedgerId = 11 then ledger.HPLedgerId else third_party_vapsi.VapsiLedgerId end)
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,varAmount * (ifnull(third_party_vapsi.Vapsi,0))/varVapsiPercent
		,'Cr'
		,varOppositLedgerId
		,'',ifnull((select max(LedgerName) from ledger where LedgerId = varLedgerId),'') ,0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
		from third_party_vapsi 
		join ledger on ledger.LedgerId = third_party_vapsi.LedgerId and ledger.RecordStatus != 'D'
		where third_party_vapsi.LedgerId = varLedgerId
		and third_party_vapsi.RecordStatus != 'D'		
		;
		
		/* Vapsi from Hissa */
/*
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		select varOrganizationId,VoucherId
		,HissaLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,varAmount * (ifnull(Hissa,0))/100
		,'Dr'
		,varOppositLedgerId
		,'','AUTO_VAPSI',0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
		from hissa 
		where LedgerId = varLedgerId
		and RecordStatus != 'D'		
		;
*/
		/* Vapsi from Vapsi Account */
		insert into voucher_detail(OrganizationId,
		VoucherId
		,LedgerId
		,VoucherDetailType,ShiftId
		,VoucherDate
		,VoucherType
		,Amount
		,AmountType
		,OppositeLedgerId
		,Flag1
		,Remark,SelfHissa,OtherHissa
		,MondayFinalFlag,VoucherMode,FromLedgerId
		,OpenAmount
		,RecordStatus	,AddedBy	,AddedDate	,UpdatedBy	,UpdatedDate
		)
		values(varOrganizationId,VoucherId
		,varOppositLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,varAmount
/*	
	,(varAmount * (100 - ifnull((select sum(Hissa)
						from hissa 
						where LedgerId = varLedgerId
						and RecordStatus != 'D'
					),0))/100) 
*/
		,'Dr'
		,varLedgerId
		,'','AUTO_VAPSI',0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
		)
        ;

		/*      Vapsi Table Entry */

		INSERT INTO vapsi
		(
		OrganizationId,
		LedgerId,
		ParentsLedgerId,
		VoucherId,
		VoucherDate,
		VapsiFromDate,
		VapsiToDate,
		BaseAmount,
		VapsiPercent,
		VapsiAmount,
		VapsiOn,
		RecordStatus,
		AddedBy,
		AddedDate,
		UpdatedBy,
		UpdatedDate)
		select
		varOrganizationId,
		varLedgerId,
		VapsiLedgerId,
		VoucherId,
		varTransactionDate,
		varFromDate,
		varToDate,
		varVapsiBaseAmount,
		ifnull(third_party_vapsi.Vapsi,0),
		varAmount * (ifnull(third_party_vapsi.Vapsi,0))/varVapsiPercent,
		varVapsiAmountOn,
		'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
		from 
		(
		select varLedgerId as VapsiLedgerId, (varVapsiPercent - ifnull((select sum(Vapsi)
							from third_party_vapsi 
							where LedgerId = varLedgerId
							and RecordStatus != 'D'
						),0)) as Vapsi
		union all
		select (case when third_party_vapsi.VapsiLedgerId = 11 then ledger.HPLedgerId else third_party_vapsi.VapsiLedgerId end) as VapsiLedgerId,third_party_vapsi.Vapsi
		from third_party_vapsi 
		join ledger on ledger.LedgerId = third_party_vapsi.LedgerId and ledger.RecordStatus != 'D'
		where third_party_vapsi.LedgerId = varLedgerId
		and third_party_vapsi.RecordStatus != 'D'
		) as third_party_vapsi where Vapsi != 0
		;
		
		
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `restore_transactions`(
in varTransactionIds bigint
)
begin

		update transaction_detail_declare set RecordStatus ='A'
		where TransactionId = varTransactionIds 
		;
		
		update transaction_declare set RecordStatus ='A'
		where TransactionId = varTransactionIds 
		;	
  
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_AccessBlock`(
	IN varOrganizationId int(20)
	, IN varRecordStatus varchar(5)
	)
BEGIN
	SELECT sys_access_block.AccessBlockId
    ,sys_access_block.OrganizationId
	,sys_access_block.LoginId
	,sys_access_block.IP
	,sys_access_block.Attempt
	,sys_access_block.Remark
	,sys_access_block.RecordStatus
	,sys_access_block.AddedBy
	,sys_access_block.AddedDate
	,sys_access_block.UpdatedBy
	,sys_access_block.UpdatedDate
	,login.Mobile
    ,login.Address
	,login.UserName
    ,login.AccountStatus LoginStatus
    
    FROM sys_access_block 
	left join login on sys_access_block.LoginId = login.LoginId
	
    where sys_access_block.OrganizationId = varOrganizationId 
	and sys_access_block.RecordStatus = varRecordStatus

    order by sys_access_block.AddedDate desc;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_admin_cash`(
        IN varOrganizationId bigint
		,IN varLedgerId INT
		,IN varFromDate DATE
		,IN varToDate DATE)
    NO SQL
select  'OPENING' as LedgerName
,ifnull(sum((case when voucher_detail.AmountType = 'Cr' then voucher_detail.Amount else -voucher_detail.Amount end

)),0) as Amount
,'Cr' as AmountType
,0 OppositeLedgerId
,'' Remark 
,'' VoucherRemark 
,'' AddedBy
,varFromDate AddedDate
,'' UpdatedBy
,varFromDate UpdatedDate
,varFromDate VoucherDate
,0 VoucherType
,0 ShiftId
,-1000 VoucherId

from voucher_detail
left join voucher on voucher.VoucherId =  voucher_detail.VoucherId
left join ledger on ledger.LedgerId =  voucher_detail.OppositeLedgerId

where voucher.VoucherDate < varFromDate
and voucher_detail.OrganizationId = varOrganizationId 
and voucher_detail.RecordStatus != 'D'
and voucher.RecordStatus != 'D'
and voucher_detail.LedgerId = varLedgerId
and voucher.VoucherType != 2
union all

select  
(case when ifnull(voucher.ShiftId,0) != 0 then (select shift.ShiftName from shift where shift.ShiftId = voucher.ShiftId) else 
(select ledger.LedgerName from ledger where ledger.LedgerId =  voucher_detail.OppositeLedgerId) end) as LedgerName
,ifnull(sum((case when voucher_detail.AmountType = 'Cr' then voucher_detail.Amount else -voucher_detail.Amount end)),0) as Amount
,'Cr' as AmountType
,(case when ifnull(voucher.ShiftId,0) != 0 then 0 else voucher_detail.OppositeLedgerId end) as OppositeLedgerId
,(case when ifnull(voucher.ShiftId,0) != 0 then '' else voucher_detail.Remark end) Remark
,(case when ifnull(voucher.ShiftId,0) != 0 then '' else voucher.Remark end) VoucherRemark
,(case when ifnull(voucher.ShiftId,0) != 0 then '' else voucher.AddedBy end) as AddedBy
,(case when ifnull(voucher.ShiftId,0) != 0 then NULL else voucher.AddedDate end) as AddedDate
,(case when ifnull(voucher.ShiftId,0) != 0 then max(voucher.UpdatedBy) else voucher.UpdatedBy end) as UpdatedBy
,(case when ifnull(voucher.ShiftId,0) != 0 then max(voucher.UpdatedDate) else voucher.UpdatedDate end) as UpdatedDate
,voucher.VoucherDate
,voucher.VoucherType VoucherType
,voucher.ShiftId
,(case when ifnull(voucher.ShiftId,0) != 0 then 0 else voucher.VoucherId end) as VoucherId


from voucher_detail
left join voucher on voucher.VoucherId =  voucher_detail.VoucherId

where voucher.VoucherDate between varFromDate and varToDate
and voucher_detail.OrganizationId = varOrganizationId
and voucher.RecordStatus != 'D'
and voucher_detail.RecordStatus != 'D'
and voucher_detail.LedgerId = varLedgerId
and voucher.VoucherType != 2
group by (case when ifnull(voucher.ShiftId,0) != 0 then 0 else voucher.VoucherId end),voucher.VoucherDate
,voucher.ShiftId

order by VoucherDate,VoucherId ,AddedDate$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_admin_cash_voucher_audit`(
        IN varOrganizationId bigint
		,IN varLedgerId INT
)
    NO SQL
select  
	voucher_audit.VoucherAuditId,
    voucher_audit.OrganizationId,
    voucher_audit.VoucherId,
    (case when voucher_audit.OppositeLedgerId = varLedgerId then voucher_audit.LedgerId else voucher_audit.OppositeLedgerId end

) LedgerId,
    (case when voucher_audit.OppositeLedgerId = varLedgerId then ledger.LedgerName else Opposite.LedgerName end) LedgerName,
    (case when voucher_audit.OppositeLedgerId = varLedgerId then voucher_audit.OppositeLedgerId else voucher_audit.LedgerId end) OppositeLedgerId,
    (case when voucher_audit.OppositeLedgerId = varLedgerId then Opposite.LedgerName else ledger.LedgerName end) OppositeLegerName,
    voucher_audit.VoucherDate,
    voucher_audit.VoucherType,
    voucher_audit.Amount,
    (case when voucher_audit.OppositeLedgerId = varLedgerId then if(voucher_audit.AmountType = 'Dr','Cr','Dr') else voucher_audit.AmountType end) AmountType,
    voucher_audit.Remark,
    voucher_audit.AuditType,
    voucher_audit.AuditStatus,
    voucher_audit.RecordStatus,
    voucher_audit.AddedBy,
    voucher_audit.AddedDate,
    voucher_audit.UpdatedBy,
    voucher_audit.UpdatedDate
	,(case when voucher_audit.OppositeLedgerId = varLedgerId then 1 else 0 end) IsOppositeFlag
from voucher_audit
join ledger on ledger.LedgerId = voucher_audit.LedgerId
join ledger as Opposite on Opposite.LedgerId = voucher_audit.OppositeLedgerId
where voucher_audit.OrganizationId = varOrganizationId
and voucher_audit.RecordStatus != 'D'
and (voucher_audit.LedgerId = varLedgerId or voucher_audit.OppositeLedgerId = varLedgerId )
and voucher_audit.AuditStatus = 1
and voucher_audit.AuditType = 1

union all 

select 
	voucher_audit.VoucherAuditId,
	voucher_audit.OrganizationId,
	voucher_audit.VoucherId,
	voucher_audit.LedgerId,
	ledger.LedgerName as LedgerName,
	voucher_audit.OppositeLedgerId,
	Opposite.LedgerName as OppositeLegerName,
	voucher_audit.VoucherDate,
	voucher_audit.VoucherType,
	voucher_audit.Amount,
	voucher_audit.AmountType,
	voucher_audit.Remark,
	voucher_audit.AuditType,
	voucher_audit.AuditStatus,
	voucher_audit.RecordStatus,
	voucher_audit.AddedBy,
	voucher_audit.AddedDate,
	voucher_audit.UpdatedBy,
	voucher_audit.UpdatedDate
	,IsOppositeFlag
from 
	(
		select  
			voucher_audit.VoucherAuditId,
			voucher_audit.OrganizationId,
			voucher_audit.VoucherId,
			(case when ifnull(voucher_audit.OppositeLedgerId,0) = varLedgerId or vd.OppositeLedgerId = varLedgerId 
				then 
					(case when ifnull(voucher_audit.LedgerId,0) != 0 then voucher_audit.LedgerId else vd.LedgerId end)
				else 
					(case when ifnull(voucher_audit.OppositeLedgerId,0) != 0 then voucher_audit.OppositeLedgerId else vd.OppositeLedgerId end)  
				end) LedgerId,
			/*(case when ifnull(voucher_audit.OppositeLedgerId,0) = varLedgerId or vd.OppositeLedgerId = varLedgerId 
				then 
					ledger.LedgerName 
				else 
					Opposite.LedgerName 
				end) LedgerName,
			*/
			(case when ifnull(voucher_audit.OppositeLedgerId,0)= varLedgerId or vd.OppositeLedgerId = varLedgerId 
				then 
					(case when ifnull(voucher_audit.OppositeLedgerId,0) != 0 then voucher_audit.OppositeLedgerId else vd.OppositeLedgerId end)
				else 
					(case when ifnull(voucher_audit.LedgerId,0) != 0 then voucher_audit.LedgerId else vd.LedgerId end) 
				end) OppositeLedgerId,
			/*(case when ifnull(voucher_audit.OppositeLedgerId,0) = varLedgerId or vd.OppositeLedgerId = varLedgerId 
				then 
					Opposite.LedgerName 
				else 
					ledger.LedgerName 
				end) OppositeLegerName,
			*/
			voucher_audit.VoucherDate,
			voucher_audit.VoucherType,
			(case when ifnull(voucher_audit.Amount,0) != 0 then voucher_audit.Amount else vd.Amount end) Amount,
			(case when ifnull(voucher_audit.OppositeLedgerId,0) = varLedgerId or vd.OppositeLedgerId = varLedgerId 
				then 
					(case when ifnull(voucher_audit.OppositeLedgerId,0) != 0 then if(voucher_audit.AmountType = 'Dr','Cr','Dr') else if(vd.AmountType = 'Dr','Cr','Dr') end) 
				else 
					(case when ifnull(voucher_audit.OppositeLedgerId,0) != 0 then voucher_audit.AmountType else vd.AmountType end) 
				end) AmountType,
			voucher_audit.Remark,
			voucher_audit.AuditType,
			voucher_audit.AuditStatus,
			voucher_audit.RecordStatus,
			voucher_audit.AddedBy,
			voucher_audit.AddedDate,
			voucher_audit.UpdatedBy,
			voucher_audit.UpdatedDate
			,(case when voucher_audit.OppositeLedgerId = varLedgerId or vd.OppositeLedgerId = varLedgerId then 1 else 0 end) IsOppositeFlag
		from voucher_audit
		JOIN voucher_detail vd ON voucher_audit.VoucherId = vd.VoucherId AND (case when voucher_audit.AuditType in (2,3) then true else vd.RecordStatus != 'D' end)
		join (select min(VoucherDetailId)VoucherDetailId 
		,min(case when voucher_detail.RecordStatus != 'D' then 9223372036854000000 else VoucherDetailId end)VoucherDetailIdWithoutDeleted 
		from voucher_detail 
		/* where voucher_detail.RecordStatus != 'D' */
		group by voucher_detail.VoucherId) as MinVoucher on (case when voucher_audit.AuditType in (2,3) then 
												MinVoucher.VoucherDetailId = vd.VoucherDetailId 
											else 
												MinVoucher.VoucherDetailIdWithoutDeleted = vd.VoucherDetailId 
											end)	
		where voucher_audit.OrganizationId = varOrganizationId
		and voucher_audit.RecordStatus != 'D'
		and (voucher_audit.LedgerId = varLedgerId or voucher_audit.OppositeLedgerId = varLedgerId or vd.LedgerId = varLedgerId or vd.OppositeLedgerId = varLedgerId )
		and voucher_audit.AuditStatus = 1
		and voucher_audit.AuditType != 1
	) as voucher_audit
/*JOIN ledger l ON voucher_audit.vdLedgerId = l.LedgerId
JOIN ledger ol ON voucher_audit.vdOppositeLedgerId = ol.LedgerId
*/
left join ledger on ledger.LedgerId = voucher_audit.LedgerId
left join ledger as Opposite on Opposite.LedgerId = voucher_audit.OppositeLedgerId

order by VoucherAuditId$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_agent_linked_ledgers`(
 IN varOrganizationId bigint
 ,IN varLedgerId bigint
 ,IN varToDate date
 )
begin
			
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			,ledger_limit.LedgerBalance
			,voucher_detail.Closing as Amount
			,'Cr' as AmountType
			,0 OppositeLedgerId
			,'' Remark 
			,ledger.AddedBy
			,ledger.AddedDate
			,ledger.UpdatedBy
			,ledger.UpdatedDate
			,(case when ifnull(sett.SettLedgerId,0) then 1 else 0 end) IsSettDone
			
			from ledger 
            left join (select CONVERT(SUM(IF(voucher_detail.AmountType = 'Cr', voucher_detail.Amount, - voucher_detail.Amount)), DECIMAL(16,2)) as Closing,voucher_detail.LedgerId
				from voucher_detail 
					Where voucher_detail.OrganizationId = varOrganizationId
					and voucher_detail.RecordStatus != 'D'
					and voucher_detail.VoucherType != 2
					and voucher_detail.VoucherDate <= varToDate
					Group By voucher_detail.LedgerId) as voucher_detail on voucher_detail.LedgerId = ledger.LedgerId
			left join login on ledger.LedgerId = login.LedgerId
			join ledger_limit on ledger.LedgerId = ledger_limit.LedgerId
			left join (select hp_settelment.LedgerId as SettLedgerId from hp_settelment where hp_settelment.SettelmentToDate >= varToDate
			and hp_settelment.RecordStatus != 'D'
			group by hp_settelment.LedgerId)
					as sett on sett.SettLedgerId = ledger.LedgerId
			where ledger.OrganizationId = varOrganizationId
            and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			and ledger.AgentLedgerId = varLedgerId
			order by ledger.LedgerName asc;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_AllShift`(
		IN FromDate DATE,
		IN ToDate DATE,
        IN varOrganizationId bigint,
        in varGroupAgentId bigint,
        in varLedgerId bigint,
	    in varLoginRoleId bigint,
		in varDealingType varchar(10),
        in varCashAgentId bigint,
        in varLoginId bigint

)
BEGIN
	declare varIsLedgerAsign int;
	set varIsLedgerAsign = 0;
	/*
	if ifnull(varLoginId,0) = 0 then
		set varIsLedgerAsign = 0;
	else
		if not ifnull((select LoginType from login where LoginId = varLoginId),0) in (0,1,2,3,4,5,6) then
			set varIsLedgerAsign = 1;
		end if;
	end if;
	*/
	select l.LedgerId,l.LedgerName,ifnull(l.DealingType,'') DealingType,l.GroupId,ifnull(login.Mobile,'')Mobile
		,ifnull(login.UserName,'')UserName,l.AgentName as AgentName
		,ifnull(ledger_telegram.TelegramId,0) TelegramId 
		,ifnull(ledger_telegram.LedgerTelegramId,0) LedgerTelegramId
		,ifnull(ledger_telegram.AccessHash,'') AccessHash
		,ifnull(l.ParentAgentName,'') as ParentAgentName
		,ifnull(l.HPLedgerName,'') as HPLedgerName
		,ifnull(l.ParentParentAgentName,'') as ParentParentAgentName
		,(case when ifnull(ledger_feedback.FeedbackId,0) = 0 then 0 else 1 end) IsFeedback ,
		ifnull(vd.TotalSale,0)  as TotalSale,
		ifnull(vd.DaraSale,0)  as DaraSale,
		ifnull(vd.BaharKaAkharSale,0)  as BaharKaAkharSale,
		ifnull(vd.AnderKaAkharSale,0)  as AnderKaAkharSale,
		ifnull(vd.TotalCommission,0) as TotalCommission
        ,ifnull(vd.TotalSale,0) 
		+ifnull(vd.TotalCommission,0)
		+ifnull(vd.TotalProfit,0)
		+ifnull(vd.Hissa,0)
		+ifnull(vd.TPC,0)
		as TotalProfit
        ,
		ifnull(vd.DaraOpenProfit,0) as DaraOpenProfit,
		ifnull(vd.BaharKaAkharOpenProfit,0)  as BaharKaAkharOpenProfit,
		ifnull(vd.AnderKaAkharOpenProfit,0)  as AnderKaAkharOpenProfit,
		ifnull(vd.DaraOpen,0)  as DaraOpen,
		ifnull(vd.BaharKaAkharOpen,0) as BaharKaAkharOpen,
		ifnull(vd.AnderKaAkharOpen,0) as AnderKaAkharOpen,
		ifnull(vd.TPC,0) as TPC,
		ifnull(vd.Hissa,0) as Hissa
		,ifnull(vd.HPAmount,0) as HPAmount
		,ifnull(vd.opening,0) as OpeningBalance
		,ifnull(vd.Kist, 0) Kist
		,ifnull(vd.Payment, 0) Payment
		,ledger_limit.FinalLimit as LimitValue
		,ifnull(vd.VapsiAmount,0) VapsiAmount
		,ifnull(vd.opening,0) + ifnull(vd.ClosingBalance,0) as ClosingBalance
		,ifnull((vd.MondayFinalFlag),2) AS MondayFinal 
		,
		ifnull(vd.TotalSale,0) 
		+ifnull(vd.TotalCommission,0)
		+ifnull(vd.TotalProfit,0)
		+ifnull(vd.Hissa,0)
		+ifnull(vd.TPC,0)
		as TodayProfit
		,(case when ifnull(ledger_asign.LedgerId,0) = 0 then 0 else 1 end) LedgerAsign
		,ifnull(TransactionCount,0) as TransactionCount
	from
	(
		SELECT ledger.LedgerId,ledger.LedgerName, ledger.GroupId,ledger.AgentLedgerId,ifnull(ledger.DealingType,'') DealingType, ifnull(agent.CommanMasterName,'NA') as AgentName
		,AgentParent.LedgerName as ParentAgentName
		,AgentParentParent.LedgerName as ParentParentAgentName
		,HPLedger.LedgerName as HPLedgerName
		from ledger
		left join comman_master agent on agent.CommanMasterId = ledger.AgentLedgerId and agent.CommanMasterType = 1
		left join ledger AgentParentParent on agent.ParentAgentLedgerId = AgentParentParent.LedgerId 
		left join ledger AgentParent on agent.LedgerId = AgentParent.LedgerId 
		left join ledger HPLedger on ledger.HPLedgerId = HPLedger.LedgerId 
		
		where ledger.OrganizationId = varOrganizationId
		and (ledger.ParentLedgerId = ifnull(varLedgerId,0) or ledger.LedgerId = ifnull(varLedgerId,0) )
		and (case ifnull(varLoginRoleId,0) when 1 then ledger.GroupId in (2,3,4,5) when 2 then ledger.GroupId in (2,3,4,5) else ledger.GroupId in (3,4,5) end)
		and (ifnull(varGroupAgentId,0) = 0 or ledger.AgentLedgerId = varGroupAgentId)
		/*and (ifnull(varCashAgentId,0) = 0 or ledger.AgentLedgerId in (select CommanMasterId from comman_master where LedgerId = varCashAgentId))
		*/
		and (agent.LedgerId = varCashAgentId or ParentAgentLedgerId = varCashAgentId or ifnull(varCashAgentId,0) = 0 )
		and (varDealingType = '' or ifnull(ledger.DealingType,'') = varDealingType) 
		and ledger.RecordStatus!='D'
		and ledger.IsHide = '0'
		/*
		and (ifnull(varLoginId,0) = 0 or ifnull(varLedgerId,0) !=0 
			or ledger.LedgerId in (select LedgerId from ledger_asign where ledger_asign.RecordStatus != 'D' 
						and (StaffLoginId = varLoginId or StaffLoginId = 0) and AsignDate = FromDate and FromDate = ToDate ) 
			or not exists (select LedgerId from ledger_asign where ledger_asign.RecordStatus != 'D' 
						and (StaffLoginId = varLoginId or StaffLoginId = 0) and AsignDate = FromDate and FromDate = ToDate )
			)
		*/
		and (ifnull(varIsLedgerAsign,0) = 0 
			or ledger.LedgerId in (select LedgerId from ledger_asign where ledger_asign.RecordStatus != 'D' 
						and (StaffLoginId = varLoginId or StaffLoginId = 0) and AsignDate = FromDate and FromDate = ToDate ) 
			or not exists (select LedgerId from ledger_asign where ledger_asign.RecordStatus != 'D' 
						and (StaffLoginId = varLoginId or StaffLoginId = 0) and AsignDate = FromDate and FromDate = ToDate )
			)
	) as l	
	left JOIN 
	( select (case when ledger.LedgerId = varLedgerId then ledger.LedgerId 
						when ledger.ParentLedgerId = varLedgerId then ledger.LedgerId 
						else ledger.ParentLedgerId end) LedgerId
		,sum(TotalSale) TotalSale
		,sum(DaraSale) DaraSale
		,sum(BaharKaAkharSale) BaharKaAkharSale
		,sum(AnderKaAkharSale) AnderKaAkharSale
		,sum(TotalCommission) TotalCommission
		,sum(TotalProfit) TotalProfit
		,sum(DaraOpenProfit) DaraOpenProfit
		,sum(BaharKaAkharOpenProfit) BaharKaAkharOpenProfit
		,sum(AnderKaAkharOpenProfit) AnderKaAkharOpenProfit
		,sum(DaraOpen) DaraOpen
		,sum(BaharKaAkharOpen) BaharKaAkharOpen
		,sum(AnderKaAkharOpen) AnderKaAkharOpen
		,sum(TPC) TPC
		,sum(Hissa) Hissa
		,sum(HPAmount) HPAmount
		,sum(Kist) Kist
		,sum(Payment) Payment
		,sum(VapsiAmount) VapsiAmount
		,sum(ClosingBalance) ClosingBalance
		,max(MondayFinalFlag) MondayFinalFlag
		,sum(opening) opening
		
		from (select LedgerId,ParentLedgerId from ledger where ledger.OrganizationId = varOrganizationId) as ledger
		left join 
			(select 
				CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalSale,
				CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as DaraSale,
				CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as BaharKaAkharSale,
				CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as AnderKaAkharSale,
				CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TotalCommission,
				CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalProfit,
				CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as DaraOpenProfit,
				CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as BaharKaAkharOpenProfit,
				CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as AnderKaAkharOpenProfit,
				CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as DaraOpen,
				CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
				CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as AnderKaAkharOpen,
				CONVERT(SUM(IF(vd.VoucherType = 32, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TPC,
				CONVERT((SUM(IF(vd.VoucherType = 29 or vd.VoucherType = 30 or vd.VoucherType = 31, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Hissa
				,CONVERT((SUM(IF(vd.VoucherType = 5 , IF(vd.AmountType = 'Dr', vd.Amount,  -vd.Amount), 0))), DECIMAL(16,2)) as HPAmount
				,sum(IF(vd.VoucherType = 3,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) Kist
				,sum(IF(vd.VoucherType = 1,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) Payment
				,sum(IF(vd.VoucherType = 4,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) VapsiAmount
				,CONVERT(ifnull((SUM(IF(vd.VoucherType <> 2 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))),0), DECIMAL(16,2)) as ClosingBalance
				,vd.LedgerId 
				,max(case when MondayFinalFlag = 'True' then 0 else 1 end) AS MondayFinalFlag 
				from voucher_detail as vd

				where (vd.VoucherDate between FromDate and ToDate)
				and (vd.RecordStatus!='D') 
				and vd.OrganizationId = varOrganizationId
				group by vd.LedgerId 
								
			) as vd on ledger.LedgerId = vd.LedgerId
		left join 
			(Select aa.LedgerId 
				,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
				from voucher_detail aa

						Where 
						aa.VoucherDate < FromDate
						and aa.VoucherType != 2
						and aa.RecordStatus != 'D' 
						and aa.OrganizationId = varOrganizationId
				group by aa.LedgerId 
						
			) as OPBal on OPBal.LedgerId = ledger.LedgerId
		group by (case when ledger.LedgerId = varLedgerId then ledger.LedgerId 
						when ledger.ParentLedgerId = varLedgerId then ledger.LedgerId 
						else ledger.ParentLedgerId end)

	) as vd on vd.LedgerId = l.LedgerId
								
	left join (
		select
			WorkingDays.LedgerId 
			,sum(TransactionCount) AS TransactionCount 
			from 
			(select
				vd.LedgerId 
				,max(case when ShiftId > 0 then 1 else 0 end) AS TransactionCount 
				from voucher_detail as vd

				where (vd.VoucherDate between FromDate and ToDate)
				and (vd.RecordStatus!='D') 
				and vd.OrganizationId = varOrganizationId
				group by vd.LedgerId,vd.VoucherDate 
			)as WorkingDays
			group by WorkingDays.LedgerId
	) as WorkingDays on WorkingDays.LedgerId = l.LedgerId
/*		
	left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
*/    
	left join ledger_limit on ledger_limit.LedgerId = l.LedgerId
	left join login on login.LedgerId = l.LedgerId
	left join (
			select max(FeedbackId) as FeedbackId,ledger_feedback.LedgerId from ledger_feedback 
			where ledger_feedback.FeedbackDate = ToDate
			group by ledger_feedback.LedgerId
			) as ledger_feedback on ledger_feedback.LedgerId = l.LedgerId
	left join ledger_asign on ledger_asign.LedgerId = l.LedgerId 
						and ledger_asign.RecordStatus != 'D' 
						and ledger_asign.StaffLoginId = 0
						and AsignDate = ToDate
	left join ledger_telegram on l.LedgerId = ledger_telegram.LedgerId and ledger_telegram.RecordStatus <> 'D'
	where
		not (
		ifnull(vd.TotalSale,0) between -1 and 1 
		and ifnull(vd.TotalCommission,0) between -1 and 1 
		and ifnull(vd.TotalProfit,0) between -1 and 1 
		and ifnull(vd.DaraOpen,0) between -1 and 1 
		and ifnull(vd.BaharKaAkharOpen,0) between -1 and 1 
		and ifnull(vd.AnderKaAkharOpen,0) between -1 and 1 
		and ifnull(vd.TPC,0) between -1 and 1 
		and ifnull(vd.Hissa,0) between -1 and 1 
		and ifnull(vd.HPAmount,0) between -1 and 1 
		and ifnull(vd.opening,0) between -1 and 1 
		and ifnull(vd.Kist, 0) between -1 and 1 
		and ifnull(vd.Payment, 0) between -1 and 1 
		and ifnull(vd.VapsiAmount,0) between -1 and 1 
		and ifnull(vd.ClosingBalance,0) between -1 and 1 
		)
	
	/*
		ifnull(vd.TotalSale,0) <> 0
		or ifnull(vd.TotalCommission,0) <> 0
		or ifnull(vd.TotalProfit,0) <> 0
		or ifnull(vd.DaraOpen,0) <> 0
		or ifnull(vd.BaharKaAkharOpen,0) <> 0
		or ifnull(vd.AnderKaAkharOpen,0) <> 0
		or ifnull(vd.TPC,0) <> 0
		or ifnull(vd.Hissa,0) <> 0
		or ifnull(vd.HPAmount,0) <> 0
		or round(ifnull(vd.opening,0)) <> 0
		or ifnull(vd.Kist, 0) <> 0
		or ifnull(vd.Payment, 0) <> 0
		or ifnull(vd.VapsiAmount,0) <> 0
		or round(ifnull(vd.opening,0) + ifnull(vd.ClosingBalance,0)) <> 0
	*/
	
	Order By LedgerName
	;
	
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_AllShift_Short`(
		IN FromDate DATE,
		IN ToDate DATE,
        IN varOrganizationId bigint,
        in varGroupAgentId bigint,
        in varLedgerId bigint,
	    in varLoginRoleId bigint,
		in varDealingType varchar(10),
        in varCashAgentId bigint,
        in varLoginId bigint

)
BEGIN
	declare varIsLedgerAsign int;
	set varIsLedgerAsign = 1;
	/*
	if ifnull(varLoginId,0) = 0 then
		set varIsLedgerAsign = 0;
	else
		if not ifnull((select LoginType from login where LoginId = varLoginId),0) in (0,1,2,3,4,5,6) then
			set varIsLedgerAsign = 1;
		end if;
	end if;
	*/
	
	select l.LedgerId,l.LedgerName,ifnull(l.DealingType,'') DealingType,l.GroupId,ifnull(login.Mobile,'')Mobile
		,ifnull(login.UserName,'')UserName,ifnull(agent.CommanMasterName,'NA') as AgentName,
		(case when ifnull(ledger_feedback.FeedbackId,0) = 0 then 0 else 1 end) IsFeedback ,
		ifnull(vd.TotalSale,0)  as TotalSale,
		ifnull(vd.DaraSale,0)  as DaraSale,
		ifnull(vd.BaharKaAkharSale,0)  as BaharKaAkharSale,
		ifnull(vd.AnderKaAkharSale,0)  as AnderKaAkharSale,
		ifnull(vd.TotalCommission,0) as TotalCommission
        ,ifnull(vd.TotalSale,0) 
		+ifnull(vd.TotalCommission,0)
		+ifnull(vd.TotalProfit,0)
		+ifnull(vd.Hissa,0)
		+ifnull(vd.TPC,0)
		as TotalProfit
        ,
		ifnull(vd.DaraOpenProfit,0) as DaraOpenProfit,
		ifnull(vd.BaharKaAkharOpenProfit,0)  as BaharKaAkharOpenProfit,
		ifnull(vd.AnderKaAkharOpenProfit,0)  as AnderKaAkharOpenProfit,
		ifnull(vd.DaraOpen,0)  as DaraOpen,
		ifnull(vd.BaharKaAkharOpen,0) as BaharKaAkharOpen,
		ifnull(vd.AnderKaAkharOpen,0) as AnderKaAkharOpen,
		ifnull(vd.TPC,0) as TPC,
		ifnull(vd.Hissa,0) as Hissa
		,ifnull(vd.HPAmount,0) as HPAmount
		,ifnull(vd.opening,0) as OpeningBalance
		,ifnull(vd.Kist, 0) Kist
		,ifnull(vd.Payment, 0) Payment
		,ledger_limit.FinalLimit as LimitValue
		,ifnull(vd.VapsiAmount,0) VapsiAmount
		,ifnull(vd.opening,0) + ifnull(vd.ClosingBalance,0) as ClosingBalance
		,ifnull((vd.MondayFinalFlag),2) AS MondayFinal 
		,
		ifnull(vd.TotalSale,0) 
		+ifnull(vd.TotalCommission,0)
		+ifnull(vd.TotalProfit,0)
		+ifnull(vd.Hissa,0)
		+ifnull(vd.TPC,0)
		as TodayProfit
		,(case when ifnull(ledger_asign.LedgerId,0) = 0 then 0 else 1 end) LedgerAsign
	from
	(
		SELECT ledger.LedgerId,ledger.LedgerName, ledger.GroupId,ledger.AgentLedgerId,ifnull(ledger.DealingType,'') DealingType
		from ledger
		where ledger.OrganizationId = varOrganizationId
		and (ledger.ParentLedgerId = ifnull(varLedgerId,0) or ledger.LedgerId = ifnull(varLedgerId,0) )
		and (case ifnull(varLoginRoleId,0) when 1 then ledger.GroupId in (2,3,4,5) when 2 then ledger.GroupId in (2,3,4,5) else ledger.GroupId in (3,4,5) end)
		and (ifnull(varGroupAgentId,0) = 0 or ledger.AgentLedgerId = varGroupAgentId)
		and (ifnull(varCashAgentId,0) = 0 or ledger.AgentLedgerId in (select CommanMasterId from comman_master where LedgerId = varCashAgentId))
		and (varDealingType = '' or ifnull(ledger.DealingType,'') = varDealingType) 
		and ledger.RecordStatus!='D'
		and ledger.IsHide = '0'
		/*
		and (ifnull(varLoginId,0) = 0 or ifnull(varLedgerId,0) !=0 
			or ledger.LedgerId in (select LedgerId from ledger_asign where ledger_asign.RecordStatus != 'D' 
						and (StaffLoginId = varLoginId or StaffLoginId = 0) and AsignDate = FromDate and FromDate = ToDate ) 
			or not exists (select LedgerId from ledger_asign where ledger_asign.RecordStatus != 'D' 
						and (StaffLoginId = varLoginId or StaffLoginId = 0) and AsignDate = FromDate and FromDate = ToDate )
			)
		*/
		and (ifnull(varIsLedgerAsign,0) = 0 
			or ledger.LedgerId in (select LedgerId from ledger_asign where ledger_asign.RecordStatus != 'D' and ledger_asign.OrganizationId = varOrganizationId
						and (StaffLoginId = varLoginId or StaffLoginId = 0) and AsignDate = FromDate and FromDate = ToDate ) 
			or not exists (select LedgerId from ledger_asign where ledger_asign.RecordStatus != 'D' and ledger_asign.OrganizationId = varOrganizationId
						and (StaffLoginId = varLoginId or StaffLoginId = 0) and AsignDate = FromDate and FromDate = ToDate )
			)
	) as l	
	left JOIN 
	( select (case when ledger.LedgerId = varLedgerId then ledger.LedgerId 
						when ledger.ParentLedgerId = varLedgerId then ledger.LedgerId 
						else ledger.ParentLedgerId end) LedgerId
		,sum(TotalSale) TotalSale
		,sum(DaraSale) DaraSale
		,sum(BaharKaAkharSale) BaharKaAkharSale
		,sum(AnderKaAkharSale) AnderKaAkharSale
		,sum(TotalCommission) TotalCommission
		,sum(TotalProfit) TotalProfit
		,sum(DaraOpenProfit) DaraOpenProfit
		,sum(BaharKaAkharOpenProfit) BaharKaAkharOpenProfit
		,sum(AnderKaAkharOpenProfit) AnderKaAkharOpenProfit
		,sum(DaraOpen) DaraOpen
		,sum(BaharKaAkharOpen) BaharKaAkharOpen
		,sum(AnderKaAkharOpen) AnderKaAkharOpen
		,sum(TPC) TPC
		,sum(Hissa) Hissa
		,sum(HPAmount) HPAmount
		,sum(Kist) Kist
		,sum(Payment) Payment
		,sum(VapsiAmount) VapsiAmount
		,sum(ClosingBalance) ClosingBalance
		,max(MondayFinalFlag) MondayFinalFlag
		,sum(opening) opening
		
		from (select LedgerId,ParentLedgerId from ledger where ledger.OrganizationId = varOrganizationId) as ledger
		left join 
			(select 
				CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalSale,
				CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as DaraSale,
				CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as BaharKaAkharSale,
				CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as AnderKaAkharSale,
				CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TotalCommission,
				CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalProfit,
				CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as DaraOpenProfit,
				CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as BaharKaAkharOpenProfit,
				CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as AnderKaAkharOpenProfit,
				CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as DaraOpen,
				CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
				CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as AnderKaAkharOpen,
				CONVERT(SUM(IF(vd.VoucherType = 32, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TPC,
				CONVERT((SUM(IF(vd.VoucherType = 29 or vd.VoucherType = 30 or vd.VoucherType = 31, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Hissa
				,CONVERT((SUM(IF(vd.VoucherType = 5 , IF(vd.AmountType = 'Dr', vd.Amount,  -vd.Amount), 0))), DECIMAL(16,2)) as HPAmount
				,sum(IF(vd.VoucherType = 3,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) Kist
				,sum(IF(vd.VoucherType = 1,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) Payment
				,sum(IF(vd.VoucherType = 4,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) VapsiAmount
				,CONVERT(ifnull((SUM(IF(vd.VoucherType <> 2 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))),0), DECIMAL(16,2)) as ClosingBalance
				,vd.LedgerId 
				,max(case when MondayFinalFlag = 'True' then 0 else 1 end) AS MondayFinalFlag 
				from voucher_detail as vd

				where (vd.VoucherDate between FromDate and ToDate)
				and (vd.RecordStatus!='D') 
				and vd.OrganizationId = varOrganizationId
				group by vd.LedgerId 
								
			) as vd on ledger.LedgerId = vd.LedgerId
		left join 
			(Select aa.LedgerId 
				,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
				from voucher_detail aa

						Where 
						aa.VoucherDate < FromDate
						and aa.VoucherType != 2
						and aa.RecordStatus != 'D' 
						and aa.OrganizationId = varOrganizationId
				group by aa.LedgerId 
						
			) as OPBal on OPBal.LedgerId = ledger.LedgerId
		group by (case when ledger.LedgerId = varLedgerId then ledger.LedgerId 
						when ledger.ParentLedgerId = varLedgerId then ledger.LedgerId 
						else ledger.ParentLedgerId end)

	) as vd on vd.LedgerId = l.LedgerId
		
	left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
    left join ledger_limit on ledger_limit.LedgerId = l.LedgerId
	left join login on login.LedgerId = l.LedgerId
	left join (
			select max(FeedbackId) as FeedbackId,ledger_feedback.LedgerId from ledger_feedback 
			where ledger_feedback.FeedbackDate = ToDate
			group by ledger_feedback.LedgerId
			) as ledger_feedback on ledger_feedback.LedgerId = l.LedgerId
	left join ledger_asign on ledger_asign.LedgerId = l.LedgerId 
						and ledger_asign.RecordStatus != 'D' 
						and ledger_asign.StaffLoginId = 0
						and AsignDate = ToDate
	where
		ifnull(vd.TotalSale,0) <> 0
		or ifnull(vd.TotalCommission,0) <> 0
		or ifnull(vd.TotalProfit,0) <> 0
		or ifnull(vd.DaraOpen,0) <> 0
		or ifnull(vd.BaharKaAkharOpen,0) <> 0
		or ifnull(vd.AnderKaAkharOpen,0) <> 0
		or ifnull(vd.TPC,0) <> 0
		or ifnull(vd.Hissa,0) <> 0
		or ifnull(vd.HPAmount,0) <> 0
		or round(ifnull(vd.opening,0)) <> 0
		or ifnull(vd.Kist, 0) <> 0
		or ifnull(vd.Payment, 0) <> 0
		or ifnull(vd.VapsiAmount,0) <> 0
		or round(ifnull(vd.opening,0) + ifnull(vd.ClosingBalance,0)) <> 0

	Order By LedgerName
	;
	
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_cash_report`(
	IN `varOrganizationId` bigint
	, IN `varFromDate` DATE
	, IN `varToDate` DATE
)
    NO SQL
Select vd.LedgerId, l.LedgerName
	,round(sum(case when vd.VoucherDate < varFromDate then IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) else 0 end

)) as Opening 
	,round(sum(case when vd.VoucherDate between varFromDate and varToDate then IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) else 0 end)) as Amount 
	,round(sum(case when vd.VoucherDate <= varToDate then IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) else 0 end)) as Closing 
	from voucher_detail vd
		Join voucher on voucher.VoucherId = vd.VoucherId 
        Join ledger l on vd.LedgerId = l.LedgerId 
		Where ( vd.VoucherDate <= varToDate)
		and vd.OrganizationId = varOrganizationId
		and vd.RecordStatus != 'D'
		and voucher.RecordStatus != 'D'
     	and voucher.VoucherType != 2
		and l.GroupId = 6
		Group By vd.LedgerId, l.LedgerName

		having not(
		sum(case when vd.VoucherDate < varFromDate then IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) else 0 end) between -1 and 1  
		and sum(case when vd.VoucherDate between varFromDate and varToDate then IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) else 0 end) between -1 and 1  
		and sum(case when vd.VoucherDate <= varToDate then IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) else 0 end) between -1 and 1  
		)
		Order By l.LedgerName$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_cash_report_detail`(
	IN `varOrganizationId` bigint
	, IN `varFromDate` DATE
	, IN `varToDate` DATE
	, IN `varLedgerId` bigint
)
    NO SQL
Select vd.LedgerId, vd.LedgerName,vd.VoucherType,vd.VoucherId,vd.AmountType
    ,vd.RemarkVoucher,vd.RemarkVoucherDetail
	,vd.Amount  
	,vd.VoucherDate as VoucherDate 
	,vd.OppositeLedgerId,vd.OppositeLedgerName
	,vd.OrderFlag
	from 
	(
	Select vd.LedgerId, l.LedgerName,0 as VoucherType,0 as VoucherId,'Dr' as AmountType,'Opening' as RemarkVoucher,'Opening' as RemarkVoucherDetail 
	,sum(IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) ) as Amount 
	,varFromDate as VoucherDate 
	,0 as OppositeLedgerId,'' as OppositeLedgerName
	,0 as OrderFlag
	from voucher_detail vd
		Join voucher on voucher.VoucherId = vd.VoucherId 
        Join ledger l on vd.LedgerId = l.LedgerId 
		Where ( vd.VoucherDate < varFromDate)
		and vd.OrganizationId = varOrganizationId
		and vd.RecordStatus != 'D'
		and voucher.RecordStatus != 'D'
     	and voucher.VoucherType != 2
		and l.GroupId = 6
		and (varLedgerId = 0  or vd.LedgerId = varLedgerId)
		Group By vd.LedgerId, l.LedgerName
	union all
	Select vd.LedgerId, l.LedgerName,0 as VoucherType,vd.VoucherId,vd.AmountType,voucher.Remark as RemarkVoucher,vd.Remark as RemarkVoucherDetail
	,vd.Amount as Amount 
	,vd.VoucherDate as VoucherDate 
	,vd.OppositeLedgerId,o_l.LedgerName as OppositeLedgerName
	,1 as OrderFlag
	from voucher_detail vd
		Join voucher on voucher.VoucherId = vd.VoucherId 
        Join ledger l on vd.LedgerId = l.LedgerId 
		left Join ledger o_l on vd.OppositeLedgerId = o_l.LedgerId 
		Where vd.VoucherDate between varFromDate and varToDate
		and vd.OrganizationId = varOrganizationId
		and vd.RecordStatus != 'D'
		and voucher.RecordStatus != 'D'
     	and voucher.VoucherType != 2
		and l.GroupId = 6
		and (varLedgerId = 0  or vd.LedgerId = varLedgerId)
	) as vd
	order by vd.LedgerId, vd.LedgerName,vd.OrderFlag,vd.VoucherDate,vd.VoucherId$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_cashagent_by_parantagent`(
	IN `varOrganizationId` bigint
	, IN `varAgentId` bigint
)
    NO SQL
Select ledger.LedgerId, ledger.LedgerName,ledger.GroupId 
,ledger_group.GroupName
from comman_master 
/*
on agent.CommanMasterId = ledger.AgentLedgerId and comman_master.CommanMasterType = 1
*/
Join ledger on comman_master.LedgerId = ledger.LedgerId 
join ledger_group on ledger.GroupId = ledger_group.GroupId
	
Where comman_master.ParentAgentLedgerId = varAgentId 
and comman_master.OrganizationId = varOrganizationId
group by ledger.LedgerId, ledger.LedgerName,ledger.GroupId 
,ledger_group.GroupName
order by ledger.LedgerName$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_CommanMaster`(
IN `varOrganizationId` bigint(21)
, IN `varCommanMasterType` bigint(21)
, IN `varCommanMasterName` varchar(30)
)
SELECT ledger.LedgerName,comman_master.CommanMasterId,comman_master.CommanMasterName
,comman_master.OrganizationId,comman_master.CommanMasterType,comman_master.LedgerId
,comman_master.RecordStatus,comman_master.AddedBy,comman_master.AddedDate,comman_master.UpdatedBy
,comman_master.UpdatedDate
,comman_master.ParentAgentLedgerId
,ifnull(ParantLedger.LedgerName,'') as ParentAgentLedgerName 
FROM comman_master
left join ledger on ledger.LedgerId = comman_master.LedgerId 
left join ledger as ParantLedger on ParantLedger.LedgerId = comman_master.ParentAgentLedgerId 
where comman_master.CommanMasterType = varCommanMasterType
and (varCommanMasterName is null or comman_master.CommanMasterName LIKE CONCAT( varCommanMasterName , '%'))
and (ifnull(comman_master.OrganizationId,0) = varOrganizationId or ifnull(comman_master.OrganizationId,0) = 0 )
and comman_master.RecordStatus != 'D'
order by comman_master.CommanMasterName$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_custom_voucher_detail`(
		IN LedgerIds bigint(21),
        IN FromToDate DATE
	)
Select a.VoucherDetailId,a.VoucherId,a.LedgerId,l.LedgerName as OppositeLedgerName,
a.Remark,a.MondayFinalFlag,
a.VoucherDate,a.VoucherType,a.Amount,a.AmountType,
a.OppositeLedgerId,a.AddedBy,a.AddedDate,a.UpdatedBy,a.UpdatedDate 
From voucher_detail a
join ledger l on a.OppositeLedgerId = l.LedgerId
WHERE(a.RecordStatus != 'D')
and (LedgerIds is null or a.LedgerId = LedgerIds)
and (a.VoucherDate = FromToDate)
and (a.VoucherType in (1,3,4))
order by a.AddedDate DESC$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Daily_List`(
		IN VoucherDates DATE,
        IN ShiftIds BIGINT,
        IN varOrganizationId bigint,
        in varGroupAgentId bigint,
        in varLedgerId bigint,
	    in varLoginRoleId bigint,
        in varCashAgentId bigint
	)
select 0 as VoucherId,VoucherDates as VoucherDate,l.LedgerId,l.LedgerName,l.GroupId,l.AgentName as AgentName,l.TransactionCappingAmount
		,selfvd.Remark,selfvd.SelfHissa,0 OtherHissa ,
		ifnull(selfvd.TotalSale,0) TotalSale,
		ifnull(selfvd.DaraSale,0) DaraSale,
		ifnull(selfvd.BaharKaAkharSale,0) BaharKaAkharSale,
		ifnull(selfvd.AnderKaAkharSale,0) AnderKaAkharSale,
		ifnull(selfvd.TotalCommission,0) TotalCommission,
		ifnull(selfvd.TotalProfit,0) TotalProfit,
		ifnull(selfvd.DaraOpenProfit,0) DaraOpenProfit,
		ifnull(selfvd.BaharKaAkharOpenProfit,0) BaharKaAkharOpenProfit,
		ifnull(selfvd.AnderKaAkharOpenProfit,0) AnderKaAkharOpenProfit,
		ifnull(selfvd.DaraOpen,0) DaraOpen,
		ifnull(selfvd.BaharKaAkharOpen,0) BaharKaAkharOpen,
		ifnull(selfvd.AnderKaAkharOpen,0) AnderKaAkharOpen,
		ifnull(selfvd.TPC,0) TPC,
		ifnull(selfvd.Tax,0) Tax,
		ifnull(selfvd.Hissa,0) Hissa,
		ifnull(selfvd.Balance,0) Balance,
		(case when ifnull(selfvd.IsVerify,0) > 0 then 0 else 1 end

) IsVerify
from
	(
		SELECT ledger.LedgerId,ledger.LedgerName,ledger.AgentLedgerId ,ledger.GroupId, ifnull(agent.CommanMasterName,'NA') as AgentName
		,ledger.TransactionCappingAmount
        from ledger
		left join comman_master agent on agent.CommanMasterId = ledger.AgentLedgerId and agent.CommanMasterType = 1
		where (ledger.OrganizationId = varOrganizationId or ledger.LedgerId = 11)
		and ledger.LedgerId = ifnull(varLedgerId,0)
		and (case ifnull(varLoginRoleId,0) when 1 then ledger.GroupId in (2,3,4,5) when 2 then ledger.GroupId in (2,3,4,5) else ledger.GroupId in (3,4,5) end)
        and (ifnull(varGroupAgentId,0) = 0 or ledger.AgentLedgerId = varGroupAgentId)
		/*
		and (ifnull(varCashAgentId,0) = 0 or ledger.AgentLedgerId in (select CommanMasterId from comman_master where LedgerId = varCashAgentId))
		*/
		and (agent.LedgerId = varCashAgentId or ParentAgentLedgerId = varCashAgentId or ifnull(varCashAgentId,0) = 0 )
		
		and ledger.RecordStatus!='D'
	) as l	
	left join (

		SELECT vd.LedgerId,vd.Remark,vd.SelfHissa,
		CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalSale,
		CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as DaraSale,
		CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as BaharKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as AnderKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TotalCommission,
		CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalProfit,
		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as DaraOpenProfit,
		CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as BaharKaAkharOpenProfit,
		CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as AnderKaAkharOpenProfit,

		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as DaraOpen,
		CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
		CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as AnderKaAkharOpen,


		CONVERT(SUM(IF(vd.VoucherType = 32, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TPC,
		CONVERT(SUM(IF(vd.VoucherType = 35, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as Tax,

		CONVERT((SUM(IF(vd.VoucherType = 29 or vd.VoucherType = 30 or vd.VoucherType = 31, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Hissa,
		CONVERT((SUM(IF(vd.VoucherType in (22,23,24,25,26,27,28,29,30,31,32,35), IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Balance
		,sum(if(ifnull(vd.VerifyBy,'') = '',1,0)) as IsVerify
		from voucher_detail vd
		JOIN voucher v on vd.VoucherId = v.VoucherId
		
		WHERE (v.VoucherDate = VoucherDates)
		and (v.ShiftId = ShiftIds or ifnull(ShiftIds,0) = 0)
		and (vd.RecordStatus!='D')
		and (v.RecordStatus!='D')
		and vd.OrganizationId = varOrganizationId
		group by vd.LedgerId,vd.Remark,vd.SelfHissa
	) as selfvd on selfvd.LedgerId = l.LedgerId
	/*left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
	*/
	where ifnull(varLedgerId,0) != 0
	
union all
select 0 as VoucherId,VoucherDates as VoucherDate,l.LedgerId,l.LedgerName,l.GroupId,l.AgentName as AgentName ,l.TransactionCappingAmount
		,ifnull(selfvd.Remark,'') Remark,
		ifnull(selfvd.SelfHissa,0) SelfHissa,
		0 OtherHissa,
		ifnull(selfvd.TotalSale,0) + ifnull(sum(Childvd.TotalSale),0) TotalSale,
		ifnull(selfvd.DaraSale,0) + ifnull(sum(Childvd.DaraSale),0) DaraSale,
		ifnull(selfvd.BaharKaAkharSale,0) + ifnull(sum(Childvd.BaharKaAkharSale),0) BaharKaAkharSale,
		ifnull(selfvd.AnderKaAkharSale,0) + ifnull(sum(Childvd.AnderKaAkharSale),0) AnderKaAkharSale,
		ifnull(selfvd.TotalCommission,0) + ifnull(sum(Childvd.TotalCommission),0) TotalCommission,
		ifnull(selfvd.TotalProfit,0) + ifnull(sum(Childvd.TotalProfit),0) TotalProfit,
		ifnull(selfvd.DaraOpenProfit,0) + ifnull(sum(Childvd.DaraOpenProfit),0) DaraOpenProfit,
		ifnull(selfvd.BaharKaAkharOpenProfit,0) + ifnull(sum(Childvd.BaharKaAkharOpenProfit),0) BaharKaAkharOpenProfit,
		ifnull(selfvd.AnderKaAkharOpenProfit,0) + ifnull(sum(Childvd.AnderKaAkharOpenProfit),0) AnderKaAkharOpenProfit,
		ifnull(selfvd.DaraOpen,0) + ifnull(sum(Childvd.DaraOpen),0) DaraOpen,
		ifnull(selfvd.BaharKaAkharOpen,0) + ifnull(sum(Childvd.BaharKaAkharOpen),0) BaharKaAkharOpen,
		ifnull(selfvd.AnderKaAkharOpen,0) + ifnull(sum(Childvd.AnderKaAkharOpen),0) AnderKaAkharOpen,
		ifnull(selfvd.TPC,0) + ifnull(sum(Childvd.TPC),0) TPC,
		ifnull(selfvd.Tax,0) + ifnull(sum(Childvd.Tax),0) Tax,
		ifnull(selfvd.Hissa,0) + ifnull(sum(Childvd.Hissa),0) Hissa,
		ifnull(selfvd.Balance,0) + ifnull(sum(Childvd.Balance),0) Balance,
		(case when ifnull(selfvd.IsVerify,0) + ifnull(sum(Childvd.IsVerify),0) > 0 then 0 else 1 end) IsVerify
from
	(
		SELECT ledger.LedgerId,ledger.LedgerName,ledger.AgentLedgerId,ledger.GroupId,child.LedgerId as childLedgerId  , ifnull(agent.CommanMasterName,'NA') as AgentName
        ,ledger.TransactionCappingAmount
		from ledger
		left join ledger as child on ledger.LedgerId = child.ParentLedgerId
		left join comman_master agent on agent.CommanMasterId = ledger.AgentLedgerId and agent.CommanMasterType = 1
		where (ledger.OrganizationId = varOrganizationId or ledger.LedgerId = 11)
		and ledger.ParentLedgerId = ifnull(varLedgerId,0)
		and (case ifnull(varLoginRoleId,0) when 1 then ledger.GroupId in (2,3,4,5) when 2 then ledger.GroupId in (2,3,4,5) else ledger.GroupId in (3,4,5) end)
        and (ifnull(varGroupAgentId,0) = 0 or ledger.AgentLedgerId = varGroupAgentId)
		and (agent.LedgerId = varCashAgentId or ParentAgentLedgerId = varCashAgentId or ifnull(varCashAgentId,0) = 0 )
		/*and (ifnull(varCashAgentId,0) = 0 or ledger.AgentLedgerId in (select CommanMasterId from comman_master where LedgerId = varCashAgentId))
		*/
		and ledger.RecordStatus!='D'
	) as l	
	left join (

		SELECT vd.LedgerId,(case when ifnull(ledgerGroup.GroupId,0) = 5 then vd.Remark else '' end) Remark
		,(case when ifnull(ledgerGroup.GroupId,0) = 5 then vd.SelfHissa else 0 end) SelfHissa,
		CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalSale,
		CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as DaraSale,
		CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as BaharKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as AnderKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TotalCommission,
		CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalProfit,
		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as DaraOpenProfit,
		CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as BaharKaAkharOpenProfit,
		CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as AnderKaAkharOpenProfit,

		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as DaraOpen,
		CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
		CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as AnderKaAkharOpen,


		CONVERT(SUM(IF(vd.VoucherType = 32, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TPC,
		CONVERT(SUM(IF(vd.VoucherType = 35, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as Tax,

		CONVERT((SUM(IF(vd.VoucherType = 29 or vd.VoucherType = 30 or vd.VoucherType = 31, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Hissa,
		CONVERT((SUM(IF(vd.VoucherType in (22,23,24,25,26,27,28,29,30,31,32,35), IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Balance
		,sum(if(ifnull(vd.VerifyBy,'') = '',1,0)) as IsVerify
		from voucher_detail vd
		JOIN voucher v on vd.VoucherId = v.VoucherId
		join (SELECT ledger.GroupId,ledger.LedgerId 
		from ledger
		) as ledgerGroup on vd.LedgerId = ledgerGroup.LedgerId
		WHERE (v.VoucherDate = VoucherDates)
		and (v.ShiftId = ShiftIds or ifnull(ShiftIds,0) = 0)
		and (vd.RecordStatus!='D')
		and (v.RecordStatus!='D')
		and vd.OrganizationId = varOrganizationId
		group by vd.LedgerId,(case when ifnull(ledgerGroup.GroupId,0) = 5 then vd.Remark else '' end)
		,(case when ifnull(ledgerGroup.GroupId,0) = 5 then vd.SelfHissa else 0 end)
	) as selfvd on selfvd.LedgerId = l.LedgerId
	left join (
		SELECT vd.LedgerId,
		CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalSale,
		CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as DaraSale,
		CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as BaharKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as AnderKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TotalCommission,
		CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalProfit,
		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as DaraOpenProfit,
		CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as BaharKaAkharOpenProfit,
		CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as AnderKaAkharOpenProfit,

		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as DaraOpen,
		CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
		CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as AnderKaAkharOpen,


		CONVERT(SUM(IF(vd.VoucherType = 32, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TPC,
		CONVERT(SUM(IF(vd.VoucherType = 35, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as Tax,

		CONVERT((SUM(IF(vd.VoucherType = 29 or vd.VoucherType = 30 or vd.VoucherType = 31, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Hissa,
		CONVERT((SUM(IF(vd.VoucherType in (22,23,24,25,26,27,28,29,30,31,32,35), IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Balance
		,sum(if(ifnull(vd.VerifyBy,'') = '',1,0)) as IsVerify
		from voucher_detail vd
		JOIN voucher v on vd.VoucherId = v.VoucherId
		
		WHERE (v.VoucherDate = VoucherDates)
		and (v.ShiftId = ShiftIds or ifnull(ShiftIds,0) = 0)
		and (vd.RecordStatus!='D')
		and (v.RecordStatus!='D')
		and vd.OrganizationId = varOrganizationId
		group by vd.LedgerId
	) as Childvd on Childvd.LedgerId = l.childLedgerId

/*
left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
*/
GROUP BY
    l.LedgerId,
    l.LedgerName,
    ifnull(selfvd.Remark, ''),
    ifnull(selfvd.SelfHissa, 0),
    AgentName,
    l.TransactionCappingAmount,
    selfvd.TotalSale,
    selfvd.DaraSale,
    selfvd.BaharKaAkharSale,
    selfvd.AnderKaAkharSale,
    selfvd.TotalCommission,
    selfvd.TotalProfit,
    selfvd.DaraOpenProfit,
    selfvd.BaharKaAkharOpenProfit,
    selfvd.AnderKaAkharOpenProfit,
    selfvd.DaraOpen,
    selfvd.BaharKaAkharOpen,
    selfvd.AnderKaAkharOpen,
    selfvd.TPC,
    selfvd.Tax,
    selfvd.Hissa,
    selfvd.Balance
having
    ifnull(selfvd.TotalSale, 0) + ifnull(sum(Childvd.TotalSale), 0) <> 0
    or ifnull(selfvd.DaraSale, 0) + ifnull(sum(Childvd.DaraSale), 0) <> 0
    or ifnull(selfvd.BaharKaAkharSale, 0) + ifnull(
        sum(Childvd.BaharKaAkharSale),
        0
    ) <> 0
    or ifnull(selfvd.AnderKaAkharSale, 0) + ifnull(
        sum(Childvd.AnderKaAkharSale),
        0
    ) <> 0
    or ifnull(selfvd.TotalCommission, 0) + ifnull(
        sum(Childvd.TotalCommission),
        0
    ) <> 0
    or ifnull(selfvd.TotalProfit, 0) + ifnull(sum(Childvd.TotalProfit), 0) <> 0
    or ifnull(selfvd.DaraOpenProfit, 0) + ifnull(
        sum(Childvd.DaraOpenProfit),
        0
    ) <> 0
    or ifnull(
        selfvd.BaharKaAkharOpenProfit,
        0
    ) + ifnull(
        sum(
            Childvd.BaharKaAkharOpenProfit
        ),
        0
    ) <> 0
    or ifnull(
        selfvd.AnderKaAkharOpenProfit,
        0
    ) + ifnull(
        sum(
            Childvd.AnderKaAkharOpenProfit
        ),
        0
    ) <> 0
    or ifnull(selfvd.DaraOpen, 0) + ifnull(sum(Childvd.DaraOpen), 0) <> 0
    or ifnull(selfvd.BaharKaAkharOpen, 0) + ifnull(
        sum(Childvd.BaharKaAkharOpen),
        0
    ) <> 0
    or ifnull(selfvd.AnderKaAkharOpen, 0) + ifnull(
        sum(Childvd.AnderKaAkharOpen),
        0
    ) <> 0
    or ifnull(selfvd.TPC, 0) + ifnull(sum(Childvd.TPC), 0) <> 0
    or ifnull(selfvd.Tax, 0) + ifnull(sum(Childvd.Tax), 0) <> 0
    or ifnull(selfvd.Hissa, 0) + ifnull(sum(Childvd.Hissa), 0) <> 0
    or ifnull(selfvd.Balance, 0) + ifnull(sum(Childvd.Balance), 0) <> 0
Order By LedgerName$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Daily_List_Voucher_Verify_Process`(
		IN varOrganizationId bigint,
        IN varShiftIds BIGINT(21),
        IN varShiftDate DATE,
        in varLedgerId bigint,
		in varVarifyBy varchar(30),
		in varVerifyDate datetime ,
		in IsVerify int
	)
begin

	if IsVerify = 1 then
		update voucher_detail set
		VerifyBy = varVerifyDate 
		,VerifyDate = varVerifyDate
		WHERE (VoucherDate = varShiftDate)
		and (ShiftId = varShiftIds)
		and (LedgerId = varLedgerId 
		or LedgerId in (select ledger.LedgerId from ledger where ledger.ParentLedgerId = varLedgerId)
		)
		and (RecordStatus!='D')
		and OrganizationId = varOrganizationId
		;
	else
		update voucher_detail set
		VerifyBy = Null 
		,VerifyDate = Null
		WHERE (VoucherDate = varShiftDate)
		and (ShiftId = varShiftIds)
		and (LedgerId = varLedgerId 
		or LedgerId in (select ledger.LedgerId from ledger where ledger.ParentLedgerId = varLedgerId)
		)
		and (RecordStatus!='D')
		and OrganizationId = varOrganizationId
		;
	end if;
	
	select 1;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Feedback`(
		IN FromDate DATE,
		IN ToDate DATE,
        IN varOrganizationId bigint,
        in varGroupAgentId bigint,
        in varLedgerId bigint,
        in varCommanFeedbackId bigint,
        in varIsFeedback bigint
)
select l.LedgerId,l.LedgerName,l.GroupId,login.Mobile,ifnull(agent.CommanMasterName,'NA') as AgentName,
	ifnull(ledger_feedback.FeedbackId,0) as FeedbackId,
    ifnull(ledger_feedback.OrganizationId,0) as OrganizationId,
    ifnull(ledger_feedback.CommanFeedbackId,0) as CommanFeedbackId,
    ifnull(ledger_feedback.LedgerId,0) as LedgerId,
    ifnull(ledger_feedback.FeedbackDate,'01/01/2001') FeedbackDate,
    ifnull(ledger_feedback.Balance,0) as Balance,
    ifnull(ledger_feedback.Remark,'') as Remark,
    ifnull(ledger_feedback.RecordStatus,'') as RecordStatus,
    ifnull(ledger_feedback.AddedBy,'') as AddedBy,
    ifnull(ledger_feedback.AddedDate,'01/01/2001') AddedDate,
    ifnull(ledger_feedback.UpdatedBy,'') as UpdatedBy,
    ifnull(ledger_feedback.UpdatedDate,'01/01/2001') UpdatedDate,
	ifnull(feedback.CommanMasterName,'NA') as FeedbackName
	,ledger_limit.LedgerBalance as Closing
	from (
		SELECT ledger.LedgerId,ledger.LedgerName, ledger.GroupId,ledger.AgentLedgerId
		from ledger
		where ledger.OrganizationId = varOrganizationId
		and ledger.ParentLedgerId = 0
        and (ledger.LedgerId = ifnull(varLedgerId,0) or ifnull(varLedgerId,0) = 0)
		and ledger.RecordStatus!='D'
	) as l	 
	left join ( select 
		ledger_feedback.FeedbackId,
		ledger_feedback.OrganizationId,
		ledger_feedback.CommanFeedbackId,
		ledger_feedback.LedgerId,
		ledger_feedback.FeedbackDate,
		ledger_feedback.Balance,
		ledger_feedback.Remark,
		ledger_feedback.RecordStatus,
		ledger_feedback.AddedBy,
		ledger_feedback.AddedDate,
		ledger_feedback.UpdatedBy,
		ledger_feedback.UpdatedDate
		from ledger_feedback 
		where ledger_feedback.FeedbackDate between FromDate and ToDate
		and (ledger_feedback.CommanFeedbackId = varCommanFeedbackId or ifnull(varCommanFeedbackId,0) = 0)
		and (ifnull(varGroupAgentId,0) = 0 or ledger_feedback.AsignAgentLedgerId = varGroupAgentId)
		and ledger_feedback.RecordStatus!='D'
		)as ledger_feedback on ledger_feedback.LedgerId = l.LedgerId
	left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
	left join comman_master feedback on feedback.CommanMasterId = ledger_feedback.CommanFeedbackId 			
    left join ledger_limit on ledger_limit.LedgerId = l.LedgerId
	left join login on login.LedgerId = l.LedgerId
	where (case when varIsFeedback = 1 
		then ledger_feedback.FeedbackId is not null else ledger_feedback.FeedbackId is null end

) Order By FeedbackDate,LedgerName,FeedbackName$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Feedback_List_Count`(
		IN FromDate DATE,
		IN ToDate DATE,
        IN varOrganizationId bigint,
        in varGroupAgentId bigint,
        in varLedgerId bigint
)
select ledger_feedback.CommanFeedbackId,ifnull(feedback.CommanMasterName,'NA') as FeedbackName
	,sum(NoOfFeedBack) as NoOfFeedBack
	
	from (select 
		ledger_feedback.CommanFeedbackId
		,count(ledger_feedback.CommanFeedbackId) as NoOfFeedBack

		from ledger_feedback 
		where ledger_feedback.FeedbackDate between FromDate and ToDate
		and ledger_feedback.OrganizationId = varOrganizationId
		and (ifnull(varGroupAgentId,0) = 0 or ledger_feedback.AsignAgentLedgerId = varGroupAgentId)
		and ledger_feedback.RecordStatus!='D'
        and (ledger_feedback.LedgerId = ifnull(varLedgerId,0) or ifnull(varLedgerId,0) = 0)
		group by ledger_feedback.CommanFeedbackId
	) as ledger_feedback
	left join comman_master feedback on feedback.CommanMasterId = ledger_feedback.CommanFeedbackId 			
	group by ledger_feedback.CommanFeedbackId,feedback.CommanMasterName
	Order By FeedbackName$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_First_Limit`(
	IN varOrganizationId bigint,
	IN varLedgerId bigint
)
begin

select min(AA.VoucherDate) as VoucherDate,AA.LedgerId,AA.Amount 
,ledger.LedgerName
,ledger_limit.LedgerBalance
,ledger_limit.LedgerLimit
,ledger_limit.FinalLimit
from 
	(
		select voucher_detail.* from voucher_detail 
		join (
			select min(voucher_detail.VoucherId) as VoucherId ,voucher_detail.LedgerId	
			from voucher_detail
			join (
				select min(voucher_detail.VoucherDate)VoucherDate
				,voucher_detail.LedgerId from voucher_detail 
				where voucher_detail.OrganizationId = varOrganizationId
				and voucher_detail.VoucherType = 2
				and voucher_detail.RecordStatus != 'D'
				and voucher_detail.VoucherId <> -2
				group by voucher_detail.LedgerId
			)vddate
			on vddate.VoucherDate = voucher_detail.VoucherDate 
			and vddate.LedgerId = voucher_detail.LedgerId
			and voucher_detail.RecordStatus != 'D'
			and voucher_detail.VoucherId <> -2
			group by voucher_detail.LedgerId    
		)vddate on vddate.VoucherId = voucher_detail.VoucherId

		union all

		select voucher_detail_dump.* from voucher_detail_dump
		join (
			select min(voucher_detail_dump.VoucherId) as VoucherId ,voucher_detail_dump.LedgerId	
			from voucher_detail_dump
			join (
				select min(voucher_detail_dump.VoucherDate)VoucherDate
				,voucher_detail_dump.LedgerId from voucher_detail_dump 
				where voucher_detail_dump.OrganizationId = varOrganizationId
				and voucher_detail_dump.VoucherType = 2
				and voucher_detail_dump.RecordStatus != 'D'
				and voucher_detail_dump.VoucherId <> -2
				group by voucher_detail_dump.LedgerId
			)vddate
			on vddate.VoucherDate = voucher_detail_dump.VoucherDate 
			and vddate.LedgerId = voucher_detail_dump.LedgerId
			and voucher_detail_dump.RecordStatus != 'D'
			and voucher_detail_dump.VoucherId <> -2
			group by voucher_detail_dump.LedgerId    
		)vddate on vddate.VoucherId = voucher_detail_dump.VoucherId
	) as AA
	join ledger on ledger.LedgerId = AA.LedgerId
	join ledger_limit on ledger_limit.LedgerId = AA.LedgerId
group by LedgerId
;
     


	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_hawa_patti_linked_ledgers`(
 IN varOrganizationId bigint
 ,IN varLedgerId bigint
 ,IN varToDate date
 )
begin
			
		SELECT ledger.LedgerId,
			ledger.OrganizationId,
			ledger.ParentLedgerId,
			ledger.LedgerName,
			ledger.GroupId,
			ledger.RecordStatus
			,ledger.AddedBy
			,ifnull(login.Mobile,'NA') Mobile
			,ifnull(login.UserName,'NA') UserName
			,ledger_limit.LedgerBalance
			,voucher_detail.Closing as Amount
			,'Cr' as AmountType
			,0 OppositeLedgerId
			,'' Remark 
			,ledger.AddedBy
			,ledger.AddedDate
			,ledger.UpdatedBy
			,ledger.UpdatedDate
			,(case when ifnull(sett.SettLedgerId,0) then 1 else 0 end) IsSettDone
			from ledger 
            left join (select CONVERT(SUM(IF(voucher_detail.AmountType = 'Cr', voucher_detail.Amount, - voucher_detail.Amount)), DECIMAL(16,2)) as Closing,voucher_detail.LedgerId
				from voucher_detail 
					Where voucher_detail.OrganizationId = varOrganizationId
					and voucher_detail.RecordStatus != 'D'
					and voucher_detail.VoucherType != 2
					and voucher_detail.VoucherDate <= varToDate
					Group By voucher_detail.LedgerId) as voucher_detail on voucher_detail.LedgerId = ledger.LedgerId
			left join login on ledger.LedgerId = login.LedgerId
			join ledger_limit on ledger.LedgerId = ledger_limit.LedgerId
			left join (select hp_settelment.LedgerId as SettLedgerId from hp_settelment where hp_settelment.SettelmentToDate >= varToDate
			and hp_settelment.RecordStatus != 'D'
			group by hp_settelment.LedgerId)
					as sett on sett.SettLedgerId = ledger.LedgerId
			where ledger.OrganizationId = varOrganizationId
            and ledger.RecordStatus != 'D'
			and ledger.IsHide = '0'
			and ledger.HPLedgerId = varLedgerId
			order by ledger.LedgerName asc;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_hp_hissa_report`(
		IN varOrganizationId bigint,
		IN varFromDate DATE,
        IN varToDate DATE,
        IN LedgerIds bigint,
        IN varCashAgentId bigint
)
begin
SELECT DISTINCT l.LedgerId,l.LedgerName,hp_hissa.VoucherId,hp_hissa.HPFromDate,hp_hissa.HPToDate,hp_hissa.BaseAmount,hp_hissa.HPPercent,hp_hissa.HPAmount
	,login.Mobile,ifnull(agent.CommanMasterName,'NA') as AgentName
	,ledgerTo.LedgerName as HPLedgerName,
	hp_hissa.AddedBy,
	hp_hissa.AddedDate,
	hp_hissa.UpdatedBy,
	hp_hissa.UpdatedDate
	from (select OrganizationId,
		LedgerId,
		HPLedgerId,
		VoucherId,
		HPFromDate,
		HPToDate,
		BaseAmount,
		HPPercent,
		HPAmount ,
		AddedBy,
		AddedDate,
		UpdatedBy,
		UpdatedDate
		from hp_hissa where hp_hissa.HPToDate between varFromDate and varToDate and hp_hissa.OrganizationId = varOrganizationId
			and hp_hissa.RecordStatus!='D' 
			and (ifnull(LedgerIds,0)=0 or hp_hissa.HPLedgerId = LedgerIds)
			)  as hp_hissa
	join
		(select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.HPLedgerId,ledger.AgentLedgerId
		from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
		and ledger.OrganizationId = varOrganizationId
		and (ifnull(varCashAgentId,0) = 0 or ledger.AgentLedgerId in (select CommanMasterId from comman_master where LedgerId = varCashAgentId))
			) as l on hp_hissa.LedgerId = l.LedgerId 
	join ledger as ledgerTo on ledgerTo.LedgerId = hp_hissa.HPLedgerId  
	left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
	left join login on login.LedgerId = l.LedgerId
;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_hp_hissa_with_vapsi_report`(
		IN varOrganizationId bigint,
		IN varFromDate DATE,
        IN varToDate DATE,
        IN LedgerIds bigint
)
begin
SELECT DISTINCT l.LedgerId,l.LedgerName
	,round(ifnull(hp_hissa.BaseAmount,0), 0) HPBaseAmount
	,round(ifnull(hp_hissa.HPPercent,0), 0) HPPercent
	,round(ifnull(hp_hissa.HPAmount,0), 0) as HPAmount
	,round(ifnull(vapsi.BaseAmount,0), 0) VapsiBaseAmount
	,round(ifnull(vapsi.VapsiPercent,0), 0) VapsiPercent
	,round(ifnull(vapsi.VapsiAmount,0), 0) VapsiAmount
	,round(ifnull(vapsi.VapsiOn,0), 0) VapsiOn
	,round(ifnull(hp_settelment.SettelmentAmount,0)) SettelmentAmount
	,login.Mobile,ifnull(agent.CommanMasterName,'NA') as AgentName
	from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.HPLedgerId,ledger.AgentLedgerId
		from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
		and ledger.OrganizationId = varOrganizationId
	
			) as l 
	left join (select 
		LedgerId,
		sum(BaseAmount) BaseAmount,
		HPPercent,
		sum(HPAmount) HPAmount 
			from hp_hissa where hp_hissa.VoucherDate between varFromDate and varToDate and hp_hissa.OrganizationId = varOrganizationId
			and hp_hissa.RecordStatus!='D' 
			and (ifnull(LedgerIds,0)=0 or hp_hissa.HPLedgerId = LedgerIds)
			group by hp_hissa.LedgerId,hp_hissa.HPPercent
			)  as hp_hissa
		 on hp_hissa.LedgerId = l.LedgerId 
	left join (select 
		LedgerId,
		sum(BaseAmount)BaseAmount,
		VapsiPercent,
		sum(VapsiAmount) VapsiAmount,
		sum(VapsiOn) VapsiOn 
		from vapsi where vapsi.VoucherDate between varFromDate and varToDate and vapsi.OrganizationId = varOrganizationId
			and vapsi.RecordStatus!='D' and ParentsLedgerId = LedgerIds
			group by vapsi.LedgerId,vapsi.VapsiPercent)  as vapsi on vapsi.LedgerId = l.LedgerId 
	left join (select 
		LedgerId,
		sum(hp_settelment.SettelmentAmount)SettelmentAmount
		from hp_settelment where hp_settelment.VoucherDate between varFromDate and varToDate and hp_settelment.OrganizationId = varOrganizationId
			and hp_settelment.RecordStatus!='D' 
			and (ifnull(LedgerIds,0)=0 or hp_settelment.SettelmentLedgerId = LedgerIds)
			group by hp_settelment.LedgerId)  as hp_settelment on hp_settelment.LedgerId = l.LedgerId 

	left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
	left join login on login.LedgerId = l.LedgerId
	where ifnull(hp_hissa.HPAmount,0) != 0 or  ifnull(vapsi.VapsiAmount,0) != 0 or ifnull(hp_settelment.SettelmentAmount,0) != 0
	order by l.LedgerName
;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_ledger_asign_list_for_allshift_report`(
IN varOrganizationId int(20)
, IN varAsignDate DATE
, IN varStaffLoginId int(20)
)
begin

		SELECT ledger_asign.LedgerId
		,ledger.LedgerName
		,ledger_asign.LedgerAsignId
		,ledger_asign.OrganizationId
		,ledger_asign.AsignDate
		,ledger_asign.StaffLoginId
		,ledger_asign.RecordStatus
		,ledger_asign.AddedBy
		,ledger_asign.AddedDate
		,ledger_asign.UpdatedBy
		,ledger_asign.UpdatedDate
		
		from ledger_asign 
		left join ledger on ledger.LedgerId = ledger_asign.LedgerId
		where ledger_asign.AsignDate = varAsignDate
		and ledger_asign.StaffLoginId = varStaffLoginId
		and ledger_asign.RecordStatus != 'D'
		order by ledger.LedgerName
	;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_ledger_limit_transaction`(
		IN varOrganizationId bigint,
		IN FromDate DATE,
		IN ToDate DATE,
		in varLedgerId bigint
		,in varIsBackLimitPopup int
		)
select vd.LedgerId
	,vd.VoucherDate
	,vd.Payment
	,vd.LimitValue
	from (	
		select vd.LedgerId
		,vd.VoucherDate
		,sum(IF(vd.VoucherType = 1,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) Payment
		,sum(IF(vd.VoucherType = 2,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) LimitValue
		
		from voucher_detail as vd

		where (vd.VoucherDate between FromDate and ToDate)
		/*
		and voucher_detail.VoucherType in (1,2)
		*/
		and (vd.RecordStatus!='D') 
		and vd.OrganizationId = varOrganizationId
		and (vd.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0)
		and vd.LedgerId <> 6
		group by vd.LedgerId ,vd.VoucherDate
		) as vd
		join ledger on ledger.LedgerId = vd.LedgerId
		where (varIsBackLimitPopup = 1 or ledger.HPLedgerId = 0)
		and vd.LimitValue <> 0$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_ledger_limit_transaction_summary`(
		IN varOrganizationId bigint,
		IN FromDate DATE,
		IN ToDate DATE,
		in varLedgerId bigint
		, IN `varAgentId` bigint
		,in varIsBackLimitPopup int
		)
select 

ledger.LedgerId,ledger.LedgerName
,round(ledger_limit.LedgerBalance,0)LedgerBalance
,round(ledger_limit.LedgerLimit,0)LedgerLimit
,round(ledger_limit.TransConsum,0)TransConsum
,round(ledger_limit.FinalLimit,0)FinalLimit
,ledger.GroupId
,vd.Payment
,vd.LimitValue
,vd.VoucherDate

,main_agent.LedgerName as AgentName
,ifnull(agent.CommanMasterName,'') as AgentGroup
,ifnull(agent.CommanMasterId,'') as AgentGroupId
,login.Mobile
,login.AccountStatus LoginStatus
,agent.LedgerId as AgentLedgerId
    

from ledger 
join (
	select vd.LedgerId
	,vd.VoucherDate
	,sum(IF(vd.VoucherType = 1,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) Payment
	,sum(IF(vd.VoucherType = 2,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) LimitValue
	
	from voucher_detail as vd

	where (vd.VoucherDate between FromDate and ToDate)
	/*
	and voucher_detail.VoucherType in (1,2)
	*/
	and (vd.RecordStatus!='D') 
	and vd.OrganizationId = varOrganizationId
	and (vd.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0)
	and vd.LedgerId <> 6
	group by vd.LedgerId 
	,vd.VoucherDate
) as vd on ledger.LedgerId = vd.LedgerId
left join ledger_limit on ledger_limit.LedgerId = ledger.LedgerId 
left join comman_master as agent on agent.CommanMasterId = ledger.AgentLedgerId and agent.CommanMasterType = 1
left join ledger as main_agent on main_agent.LedgerId = agent.LedgerId
join ledger_group on ledger.GroupId = ledger_group.GroupId
left join login on ledger.LedgerId = login.LedgerId

where (ledger.LedgerId  = varLedgerId or ifnull(varLedgerId,0) = 0 )
and ifnull(ledger.ParentLedgerId ,9) = 0 
and (agent.LedgerId = varAgentId or ParentAgentLedgerId = varAgentId or ifnull(varAgentId,0) = 0 )
and (ledger.OrganizationId = varOrganizationId or ifnull(varOrganizationId,0) = 0)
and (varIsBackLimitPopup = 1 or ledger.HPLedgerId = 0)
and vd.LimitValue <> 0
order by ledger.LedgerName
		,vd.VoucherDate$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_ledger_summary`(
in varOrganizationId bigint(21)
,in varLedgerId bigint(21)
)
begin

	select sum(InVoucher) as InVoucher
		, sum(TotalDr) as TotalDr 
		, sum(TotalCr) as TotalCr 
		, sum(InHissa) as InHissa
		, sum(InTPC) as InTPC
		, sum(InTPV) as InTPV
		, sum(InHPLedger) as InHPLedger
	from
		(
		select 
			sum(1) as InVoucher
			, sum(case when AmountType = 'Dr' then Amount else 0 end) as TotalDr 
			, sum(case when AmountType = 'Cr' then Amount else 0 end) as TotalCr 
			,0 as InHissa
			,0 as InTPC
			,0 as InTPV
			,0 as InHPLedger
		
		from voucher_detail
		where OrganizationId = varOrganizationId
		and VoucherType != 2
		and LedgerId = varLedgerId
		and RecordStatus != 'D'
		union all
		select 
			0 as InVoucher
			, 0 as TotalDr 
			, 0 as TotalCr 
			,(select count(1) from hissa
			where OrganizationId = varOrganizationId
			and HissaLedgerId = varLedgerId
			and RecordStatus != 'D'
			) as InHissa
			,(select count(1) from third_party_commission
			where OrganizationId = varOrganizationId
			and CommissionLedgerId = varLedgerId
			and RecordStatus != 'D'
			) as InTPC
			,(select count(1) from third_party_vapsi
			where OrganizationId = varOrganizationId
			and VapsiLedgerId = varLedgerId
			and RecordStatus != 'D'
			) as InTPV
			,(select count(1) from ledger
			where OrganizationId = varOrganizationId
			and HPLedgerId = varLedgerId
			and RecordStatus != 'D'
			) as InHPLedger
		) as summary
	;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_ledger_summary_detail`(
in varOrganizationId bigint(21)
,in varLedgerId bigint(21)
)
begin	
		select summary.LedgerId,l.LedgerName,summary.LedgerStatus
		from
		(
			select LedgerId,'InHissa' as LedgerStatus from hissa 
			where OrganizationId = varOrganizationId
			and HissaLedgerId = varLedgerId
			and RecordStatus != 'D'
			union all
			select LedgerId,'InTPC' as LedgerStatus from third_party_commission
			where OrganizationId = varOrganizationId
			and CommissionLedgerId = varLedgerId
			and RecordStatus != 'D'
			union all
			select LedgerId,'InTPV' as LedgerStatus from third_party_vapsi
			where OrganizationId = varOrganizationId
			and VapsiLedgerId = varLedgerId
			and RecordStatus != 'D'
			union all
			select LedgerId,'InHPLedger' as LedgerStatus from ledger
			where OrganizationId = varOrganizationId
			and HPLedgerId = varLedgerId
			and RecordStatus != 'D'
		) as summary 
		join ledger l on l.LedgerId = summary.LedgerId
		
	;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_LedgerAttendance`(
		IN FromDate DATE,
		IN ToDate DATE,
        in varLedgerId bigint
)
BEGIN

		select
			vd.LedgerId 
			,vd.VoucherDate
			,max(case when ShiftId > 0 then 1 else 0 end) AS IsPresent 
			from voucher_detail as vd

			where (vd.VoucherDate between FromDate and ToDate)
			and (vd.RecordStatus!='D') 
			and (vd.LedgerId = ifnull(varLedgerId,0) or ifnull(varLedgerId,0) = 0)
			group by vd.VoucherDate, vd.LedgerId 
		
	;
	
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Limit_Balance`(
		IN varOrganizationId bigint,
		in varLedgerId bigint
		)
select ledger.LedgerName
,round(ledger_limit.LedgerBalance,0)LedgerBalance
,round(ledger_limit.LedgerLimit,0)LedgerLimit
,round(ledger_limit.TransConsum,0)TransConsum
,round(ledger_limit.FinalLimit,0)FinalLimit
,ledger.GroupId
from ledger 
left join ledger_limit on ledger_limit.LedgerId = ledger.LedgerId 
where (ledger.LedgerId  = varLedgerId or (ifnull(varLedgerId,0) = 0  and ledger.GroupId not in (3,4,5)))
and (ledger.OrganizationId = varOrganizationId or ifnull(varOrganizationId,0) = 0)
and ledger.GroupId <> 7
union
select Child.LedgerName
,round(ifnull(ledger_limit.LedgerBalance,0) + ifnull((ChildsChild_Limit.LedgerBalance),0) + ifnull((ChildsChildsChild_Limit.LedgerBalance),0) ,0) as LedgerBalance
,round(ifnull(ledger_limit.LedgerLimit,0) + ifnull((ChildsChild_Limit.LedgerLimit),0) + ifnull((ChildsChildsChild_Limit.LedgerLimit),0) ,0) as LedgerLimit
,round(ifnull(ledger_limit.TransConsum,0) + ifnull((ChildsChild_Limit.TransConsum),0) + ifnull((ChildsChildsChild_Limit.TransConsum),0) ,0) as TransConsum
,round(ifnull(ledger_limit.FinalLimit,0) + ifnull((ChildsChild_Limit.FinalLimit),0) + ifnull((ChildsChildsChild_Limit.FinalLimit),0) ,0) as FinalLimit
,Child.GroupId
from ledger as Child 
left join ledger as ChildsChild on ChildsChild.ParentLedgerId = Child.LedgerId
left join ledger as ChildsChildsChild on ChildsChildsChild.ParentLedgerId = ChildsChild.LedgerId
left join ledger_limit on Child.LedgerId = ledger_limit.LedgerId 
left join (select sum(LedgerBalance)LedgerBalance,sum(LedgerLimit)LedgerLimit,sum(TransConsum)TransConsum,sum(FinalLimit)FinalLimit,LedgerId
			from ledger_limit group by LedgerId) as ChildsChild_Limit on ChildsChild_Limit.LedgerId = ChildsChild.LedgerId 
left join (select sum(LedgerBalance)LedgerBalance,sum(LedgerLimit)LedgerLimit,sum(TransConsum)TransConsum,sum(FinalLimit)FinalLimit,LedgerId
			from ledger_limit group by LedgerId) as ChildsChildsChild_Limit on ChildsChildsChild_Limit.LedgerId = ChildsChildsChild.LedgerId 
where (Child.ParentLedgerId = varLedgerId )
and (Child.OrganizationId = varOrganizationId or ifnull(varOrganizationId,0) = 0)
and Child.GroupId in (3,4,5)
group by Child.LedgerName$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_new_ledger_list_for_deshboard`(
	IN varOrganizationId int(20)
	,IN varNoOfRecords int(20)
	,IN varLoginId int(20)
	,IN varRoleId int(20)
	
	)
BEGIN
	SELECT 
	ledger.LedgerId
    ,ledger.LedgerName
    ,ledger.AddedBy
    ,ledger.AddedDate
    ,ledger.UpdatedBy
    ,ledger.UpdatedDate
    ,ledger.GroupId

/*    ledger.OrganizationId,
    ledger.ParentLedgerId,
    ledger.RealName,
    ledger.AgentLedgerId,
    ledger.LimitType,
    ledger.DaraRate,
    ledger.DaraCommission,
    ledger.AkharRate,
    ledger.AkharCommission,
    ledger.Vapsi,
    ledger.TPVapsi,
    ledger.TPCommission,
    ledger.IsHissa,
    ledger.IsDibba,
    ledger.DibbaAmount,
    ledger.RefLedgerId,
    ledger.HPLedgerId,
    ledger.Grantor,
    ledger.DealingType,
    ledger.IsReport,
    ledger.TransactionMode,
    ledger.AccountStatus,
    ledger.IsHide,
    ledger.ChatGroupId,
    ledger.TransactionCappingAmount,
    ledger.RecordStatus,
*/
	
	,login.UserName
	,login.Mobile
	,login.LoginType

/*    ,login.Address
    ,login.AccountStatus LoginStatus
	,login.LoginName
*/
	,ledger_group.GroupName

/*
    ,(select agent.CommanMasterName from comman_master as agent 
		where agent.CommanMasterId = ledger.AgentLedgerId and CommanMasterType = 1) 
        as AgentLedgerName 
    ,(select RefLedger.LedgerName from ledger as RefLedger where RefLedger.LedgerId = ledger.RefLedgerId) as RefLedgerName 
    ,ifnull((select Ret.LedgerName from ledger as Ret where Ret.GroupId = 4 and Ret.LedgerId = ledger.ParentLedgerId),'Self') as RetailerName
	,ifnull((select Distrib.LedgerName from ledger as Distrib where Distrib.GroupId = 3 and Distrib.LedgerId = ledger.ParentLedgerId
		union
	select (select Distrib.LedgerName from ledger as Distrib where Distrib.GroupId = 3 and Distrib.LedgerId = Ret.ParentLedgerId) 
	from ledger as Ret where Ret.GroupId = 4 and Ret.LedgerId = ledger.ParentLedgerId),'Self') as DistributorName
    ,ifnull((select sum(Hissa) from 
	hissa 
	where hissa.RecordStatus!='D' 
    and hissa.LedgerId = ledger.LedgerId 
    and hissa.LedgerId = hissa.HissaLedgerId),0) as SelfHissa
    ,ifnull((select sum(Hissa) from 
	hissa 
	where hissa.RecordStatus!='D' 
    and hissa.LedgerId = ledger.LedgerId 
    and hissa.LedgerId != hissa.HissaLedgerId),0) as OtherHissa
*/
                        
    FROM ledger 
	left join login on ledger.LedgerId = login.LedgerId
	join ledger_group on ledger.GroupId = ledger_group.GroupId
	
    where (ledger.OrganizationId = varOrganizationId or ifnull(varOrganizationId,0) = 0 )
	and ledger.RecordStatus != 'D'
	and ledger_group.GroupId != 7
	and exists (
				select role_permission.RolePermissionId from role_permission
				where role_permission.Page = 'ledgers'
				and role_permission.RoleId = varRoleId
				and role_permission.IsPageAllow = '1'
				and role_permission.RecordStatus != 'D'
                and role_permission.OrganizationId = varOrganizationId
			)
	and not exists (
				select role_permission_denied.RolePermissionDeniedId from role_permission_denied
				join role_permission on role_permission.RolePermissionId = role_permission_denied.RolePermissionId and role_permission.RecordStatus != 'D'
				where role_permission.Page = 'ledgers'
				and role_permission_denied.RecordStatus != 'D'
				and role_permission.RoleId = varRoleId
				and role_permission_denied.LoginId = varLoginId
                and role_permission_denied.OrganizationId = varOrganizationId
			)
    order by ledger.AddedDate desc limit varNoOfRecords;


END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_outstanding_agent_group_detail`(
	IN `varOrganizationId` bigint
	, IN `varOnDate` DATE
	, IN `varAgentId` bigint
	, IN `varAgentGroupId` bigint
)
    NO SQL
Select 
ledger.LedgerId, ledger.LedgerName,ledger_limit.LedgerLimit as CreditLimit
,voucher_detail.Remark
,voucher_detail.Credit
,voucher_detail.Debit
, 
case when voucher_detail.Credit > voucher_detail.Debit then 'Cr' else case when voucher_detail.Debit > voucher_detail.Credit then 'Dr' else 'Dr' end end

as AmountType,
case
    when voucher_detail.Credit > voucher_detail.Debit then voucher_detail.Credit - voucher_detail.Debit
    else case
        when voucher_detail.Debit > voucher_detail.Credit then voucher_detail.Debit - voucher_detail.Credit
        else 0
    end
end as Amount,
ledger_group.GroupName,
ifnull(agent.CommanMasterName, '') as AgentName,
login.Mobile,
login.AccountStatus as LoginStatus,
ledger.Vapsi,
ledger.AccountStatus,
ifnull(agent.LedgerId, '') as AgentLedgerId,
ifnull(agent.CommanMasterId, '') as AgentGroupId
from (
        select (
                case
                    when ledger.ParentLedgerId = 0 then voucher_detail.LedgerId
                    WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
                    else ledgerBaap.ParentLedgerId
                end
            ) as LedgerId,
            Max(voucher_detail.Remark) as Remark,
            sum(Credit) as Credit,
            sum(Debit) as Debit,
            2 as z
        from (
                Select
                    voucher_detail.LedgerId,
                    Max(voucher_detail.Remark) as Remark,
                    sum(
                        case
                            when voucher_detail.AmountType = 'Cr' then voucher_detail.Amount
                            else 0
                        end
                    ) as Credit,
                    sum(
                        case
                            when voucher_detail.AmountType = 'Dr' then voucher_detail.Amount
                            else 0
                        end
                    ) as Debit,
                    2 as z
                from voucher_detail
                    Join voucher on voucher.VoucherId = voucher_detail.VoucherId
                Where (
                        voucher_detail.VoucherDate <= varOnDate
                    )
                    and voucher_detail.OrganizationId = varOrganizationId
                    and voucher_detail.RecordStatus != 'D'
                    and voucher.VoucherType != 2
                Group By
                    voucher_detail.LedgerId
            ) as voucher_detail
            left join (
                select ledger.LedgerId, ledger.ParentLedgerId
                from ledger
                WHERE (ledger.RecordStatus != 'D')
                    and ledger.OrganizationId = varOrganizationId
                    and ledger.GroupId in (3, 4, 5)
            ) as ledger on voucher_detail.LedgerId = ledger.LedgerId
            left join (
                select ledger.LedgerId, ledger.ParentLedgerId
                from ledger
                WHERE (ledger.RecordStatus != 'D')
                    and ledger.OrganizationId = varOrganizationId
                    and ledger.GroupId in (3, 4, 5)
            ) as ledgerBaap on ledger.ParentLedgerId = ledgerBaap.LedgerId
        group by (
                case
                    when ledger.ParentLedgerId = 0 then voucher_detail.LedgerId
                    WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
                    else ledgerBaap.ParentLedgerId
                end
            )
    ) voucher_detail
    Join ledger on voucher_detail.LedgerId = ledger.LedgerId
    and ifnull(ledger.ParentLedgerId, 0) = 0
    join ledger_limit on ledger.LedgerId = ledger_limit.LedgerId
    left join comman_master agent on agent.CommanMasterId = ledger.AgentLedgerId
    and agent.CommanMasterType = 1
    join ledger_group on ledger.GroupId = ledger_group.GroupId
    join login on login.LedgerId = ledger.LedgerId
Where (
        agent.LedgerId = varAgentId
        or ParentAgentLedgerId = varAgentId
        or ifnull(varAgentId, 0) = 0
    )
    and (
        agent.CommanMasterId = varAgentGroupId
        or ifnull(varAgentGroupId, 0) = 0
    )
    and not(
        (
            voucher_detail.Debit - voucher_detail.Credit
        ) BETWEEN -1 and 1
    )
order by ledger.LedgerName$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_outstanding_agent_group_summary`(
	IN `varOrganizationId` bigint
	, IN `varOnDate` DATE
	, IN `varAgentId` bigint
)
    NO SQL
Select 
/*
ledger.LedgerId, ledger.LedgerName,ledger_limit.LedgerLimit as CreditLimit
,
*/
max(voucher_detail.Remark) as Remark 
,ifnull(sum(voucher_detail.Credit),0) as Credit
,ifnull(sum(voucher_detail.Debit),0) as Debit

,case when ifnull(sum(voucher_detail.Credit),0) > ifnull(sum(voucher_detail.Debit),0) then 'Cr' 
	else case when ifnull(sum(voucher_detail.Debit),0) > ifnull(sum(voucher_detail.Credit),0) then 'Dr' 
			else 'Dr' end end

as AmountType,
case
    when ifnull(sum(voucher_detail.Credit), 0) > ifnull(sum(voucher_detail.Debit), 0) then ifnull(sum(voucher_detail.Credit), 0) - ifnull(sum(voucher_detail.Debit), 0)
    else case
        when ifnull(sum(voucher_detail.Debit), 0) > ifnull(sum(voucher_detail.Credit), 0) then ifnull(sum(voucher_detail.Debit), 0) - ifnull(sum(voucher_detail.Credit), 0)
        else 0
    end
end as Amount,
main_agent.LedgerName as AgentName
/*
,ledger_group.GroupName
,login.Mobile, login.AccountStatus as LoginStatus
,ledger.Vapsi, ledger.AccountStatus
,ifnull(agent.LedgerId,'') as AgentLedgerId
*/
,
ifnull(agent.CommanMasterName, '') as AgentGroup,
ifnull(agent.CommanMasterId, '') as AgentGroupId
from (
        select (
                case
                    when ledger.ParentLedgerId = 0 then voucher_detail.LedgerId
                    WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
                    else ledgerBaap.ParentLedgerId
                end
            ) as LedgerId,
            Max(voucher_detail.Remark) as Remark,
            sum(Credit) as Credit,
            sum(Debit) as Debit,
            2 as z
        from (
                Select
                    voucher_detail.LedgerId,
                    Max(voucher_detail.Remark) as Remark,
                    sum(
                        case
                            when voucher_detail.AmountType = 'Cr' then voucher_detail.Amount
                            else 0
                        end
                    ) as Credit,
                    sum(
                        case
                            when voucher_detail.AmountType = 'Dr' then voucher_detail.Amount
                            else 0
                        end
                    ) as Debit,
                    2 as z
                from voucher_detail
                    Join voucher on voucher.VoucherId = voucher_detail.VoucherId
                Where (
                        voucher_detail.VoucherDate <= varOnDate
                    )
                    and voucher_detail.OrganizationId = varOrganizationId
                    and voucher_detail.RecordStatus != 'D'
                    and voucher.VoucherType != 2
                Group By
                    voucher_detail.LedgerId
            ) as voucher_detail
            left join (
                select ledger.LedgerId, ledger.ParentLedgerId
                from ledger
                WHERE (ledger.RecordStatus != 'D')
                    and ledger.OrganizationId = varOrganizationId
                    and ledger.GroupId in (3, 4, 5)
            ) as ledger on voucher_detail.LedgerId = ledger.LedgerId
            left join (
                select ledger.LedgerId, ledger.ParentLedgerId
                from ledger
                WHERE (ledger.RecordStatus != 'D')
                    and ledger.OrganizationId = varOrganizationId
                    and ledger.GroupId in (3, 4, 5)
            ) as ledgerBaap on ledger.ParentLedgerId = ledgerBaap.LedgerId
        group by (
                case
                    when ledger.ParentLedgerId = 0 then voucher_detail.LedgerId
                    WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
                    else ledgerBaap.ParentLedgerId
                end
            )
    ) voucher_detail
    Join ledger on voucher_detail.LedgerId = ledger.LedgerId
    and ifnull(ledger.ParentLedgerId, 0) = 0
    join ledger_limit on ledger.LedgerId = ledger_limit.LedgerId
    left join comman_master as agent on agent.CommanMasterId = ledger.AgentLedgerId
    and agent.CommanMasterType = 1
    left join ledger as main_agent on main_agent.LedgerId = agent.LedgerId
    join ledger_group on ledger.GroupId = ledger_group.GroupId
    join login on login.LedgerId = ledger.LedgerId
Where (
        agent.LedgerId = varAgentId
        or ParentAgentLedgerId = varAgentId
        or ifnull(varAgentId, 0) = 0
    )
group by
    ifnull(agent.CommanMasterName, ''),
    ifnull(agent.CommanMasterId, '')
having
    not(
        (
            ifnull(sum(voucher_detail.Debit), 0) - ifnull(sum(voucher_detail.Credit), 0)
        ) BETWEEN -1 and 1
    )
order by main_agent.LedgerName$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_outstanding_agent_wise`(
	IN `varOrganizationId` bigint
	, IN `varOnDate` DATE
	, IN `varAgentId` bigint
)
    NO SQL
Select ledger.LedgerId, ledger.LedgerName,ledger_limit.LedgerLimit as CreditLimit
,voucher_detail.Remark, voucher_detail.Credit, voucher_detail.Debit, 
case when voucher_detail.Credit > voucher_detail.Debit then 'Cr' else case when voucher_detail.Debit > voucher_detail.Credit then 'Dr' else 'Dr' end end

as AmountType,
case
    when voucher_detail.Credit > voucher_detail.Debit then voucher_detail.Credit - voucher_detail.Debit
    else case
        when voucher_detail.Debit > voucher_detail.Credit then voucher_detail.Debit - voucher_detail.Credit
        else 0
    end
end as Amount,
ledger_group.GroupName,
ifnull(agent.CommanMasterName, '') as AgentName,
login.Mobile,
login.AccountStatus as LoginStatus,
ledger.Vapsi,
ledger.AccountStatus,
ifnull(agent.LedgerId, '') as AgentLedgerId,
ifnull(agent.CommanMasterId, '') as AgentGroupId
from (
        select (
                case
                    when ledger.ParentLedgerId = 0 then voucher_detail.LedgerId
                    WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
                    else ledgerBaap.ParentLedgerId
                end
            ) as LedgerId,
            Max(voucher_detail.Remark) as Remark,
            sum(Credit) as Credit,
            sum(Debit) as Debit,
            2 as z
        from (
                Select
                    voucher_detail.LedgerId,
                    Max(voucher_detail.Remark) as Remark,
                    sum(
                        case
                            when voucher_detail.AmountType = 'Cr' then voucher_detail.Amount
                            else 0
                        end
                    ) as Credit,
                    sum(
                        case
                            when voucher_detail.AmountType = 'Dr' then voucher_detail.Amount
                            else 0
                        end
                    ) as Debit,
                    2 as z
                from voucher_detail
                    Join voucher on voucher.VoucherId = voucher_detail.VoucherId
                Where (
                        voucher_detail.VoucherDate <= varOnDate
                    )
                    and voucher_detail.OrganizationId = varOrganizationId
                    and voucher_detail.RecordStatus != 'D'
                    and voucher.VoucherType != 2
                Group By
                    voucher_detail.LedgerId
            ) as voucher_detail
            left join (
                select ledger.LedgerId, ledger.ParentLedgerId
                from ledger
                WHERE (ledger.RecordStatus != 'D')
                    and ledger.OrganizationId = varOrganizationId
                    and ledger.GroupId in (3, 4, 5)
            ) as ledger on voucher_detail.LedgerId = ledger.LedgerId
            left join (
                select ledger.LedgerId, ledger.ParentLedgerId
                from ledger
                WHERE (ledger.RecordStatus != 'D')
                    and ledger.OrganizationId = varOrganizationId
                    and ledger.GroupId in (3, 4, 5)
            ) as ledgerBaap on ledger.ParentLedgerId = ledgerBaap.LedgerId
        group by (
                case
                    when ledger.ParentLedgerId = 0 then voucher_detail.LedgerId
                    WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
                    else ledgerBaap.ParentLedgerId
                end
            )
    ) voucher_detail
    Join ledger on voucher_detail.LedgerId = ledger.LedgerId
    and ifnull(ledger.ParentLedgerId, 0) = 0
    join ledger_limit on ledger.LedgerId = ledger_limit.LedgerId
    left join comman_master agent on agent.CommanMasterId = ledger.AgentLedgerId
    and agent.CommanMasterType = 1
    join ledger_group on ledger.GroupId = ledger_group.GroupId
    join login on login.LedgerId = ledger.LedgerId
Where (
        agent.LedgerId = varAgentId
        or ParentAgentLedgerId = varAgentId
        or ifnull(varAgentId, 0) = 0
    )
    and not(
        (
            voucher_detail.Debit - voucher_detail.Credit
        ) BETWEEN -1 and 1
    )
order by ledger.LedgerName$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_party_wise_allshift`(
        IN varOrganizationId bigint(21),
		IN FromDate DATE,
		IN ToDate DATE,
		IN varPartyId bigint(21)
	)
SELECT DISTINCT v.ShiftId

	,concat(shift.ShiftName,ifnull((select concat(' { K-',max(declare_result.DeclareNumber),' }') from declare_result where declare_result.ShiftId = v.ShiftId and declare_result.DeclareDate = FromDate and declare_result.DeclareDate = ToDate),''))
	as ShiftName
	,CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalSale,
	CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as DaraSale,
	CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as BaharKaAkharSale,
	CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as AnderKaAkharSale,
	CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TotalCommission,
	CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalProfit,
	CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as DaraOpenProfit,
	CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as BaharKaAkharOpenProfit,
	CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as AnderKaAkharOpenProfit,

	CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as DaraOpen,
	CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
	CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as AnderKaAkharOpen,



	CONVERT(SUM(IF(vd.VoucherType = 32, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TPC,

	CONVERT((SUM(IF(vd.VoucherType = 29 or vd.VoucherType = 30 or vd.VoucherType = 31, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Hissa
	,
	CONVERT((SUM(IF(vd.VoucherType in (22,23,24,25,26,27,28,29,30,31,32), IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Balance
	,vd.Remark,vd.SelfHissa
	from voucher_detail vd
	join voucher v on v.VoucherId = vd.VoucherId
	join shift on shift.ShiftId = v.ShiftId
	WHERE vd.VoucherDate between FromDate and ToDate
	and vd.OrganizationId = varOrganizationId
	and (vd.RecordStatus!='D')
	and (vd.LedgerId = varPartyId or ifnull(varPartyId,0) = 0)
	GROUP BY v.ShiftId,shift.ShiftName,vd.Remark
	Order By shift.ShiftOrder,shift.ShiftName$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_prediction_number_result_open_in_previous_date`(
IN `varOrganizationId` BIGINT(8),
IN `varShiftId` BIGINT(8),
IN `varFromDate` DATE, 
IN `varToDate` DATE, 
IN `varDeclareNumber` smallint(6) 
)
begin

	select DeclareDate 
	from declare_result
	where ShiftId = varShiftId
	and DeclareDate between varFromDate and varToDate
	and RecordStatus!='D'
	and DeclareNumber = varDeclareNumber
	;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_profit_loss`(
		IN varOrganizationId bigint,
		IN varFromDate DATE,
		IN varToDate DATE,
		in varParentId bigint
	)
SELECT DISTINCT v.ShiftId

	,concat(shift.ShiftName,ifnull((select concat(' { K-',max(declare_result.DeclareNumber),' }') from declare_result where declare_result.ShiftId = v.ShiftId and declare_result.DeclareDate = varFromDate and declare_result.DeclareDate = varToDate),''))
	as ShiftTypeName
	,CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as TotalSale,
	CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0)), DECIMAL(16,2)) as DaraSale,
	CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0)), DECIMAL(16,2)) as BaharKaAkharSale,
	CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0)), DECIMAL(16,2)) as AnderKaAkharSale,
	CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0)), DECIMAL(16,2)) as TotalCommission,
	CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as TotalProfit,
	CONVERT((SUM(IF(vd.VoucherType = 26 ,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as DaraOpenProfit,
	CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as BaharKaAkharOpenProfit,
	CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as AnderKaAkharOpenProfit,

	CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount) , 0))), DECIMAL(16,2)) as DaraOpen,
	CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount) , 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
	CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount) , 0))), DECIMAL(16,2)) as AnderKaAkharOpen,

	CONVERT(SUM(IF(vd.VoucherType = 32, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0)), DECIMAL(16,2)) as TPC,

	CONVERT((SUM(IF(vd.VoucherType = 29 or vd.VoucherType = 30 or vd.VoucherType = 31, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as Hissa
	,
	CONVERT((SUM(IF(vd.VoucherType in (22,23,24,25,26,27,28,29,30,31,32,35), IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as Balance

	from voucher_detail vd
	JOIN voucher v on vd.VoucherId = v.VoucherId
	join shift on shift.ShiftId = v.ShiftId
	join ledger l on vd.LedgerId = l.LedgerId
	WHERE vd.VoucherDate between varFromDate and varToDate
	and vd.OrganizationId = varOrganizationId
	and (l.OrganizationId = varOrganizationId or ifnull(l.OrganizationId,0) = 0)
	and (vd.RecordStatus!='D')
	and l.GroupId in (2,3,4,5)
	and (ifnull(varParentId,0) = 0 or l.LedgerId = varParentId or l.ParentLedgerId = varParentId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varParentId))		
	GROUP BY v.ShiftId,shift.ShiftName
	Order By shift.ShiftOrder$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_profit_loss_date_wise`(
		IN varOrganizationId bigint,
		in varFromDate DATE,
		in varToDate DATE,
        in varShiftIds BIGINT(21),
		in varParentId bigint
	)
SELECT DISTINCT vd.VoucherDate
	,concat(ifnull((select concat(' { K-',max(declare_result.DeclareNumber),' }') from declare_result where declare_result.ShiftId = varShiftIds and declare_result.DeclareDate = vd.VoucherDate ),''))
	as Khabar
	,CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as TotalSale,
	CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0)), DECIMAL(16,2)) as DaraSale,
	CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0)), DECIMAL(16,2)) as BaharKaAkharSale,
	CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount)  , 0)), DECIMAL(16,2)) as AnderKaAkharSale,
	CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0)), DECIMAL(16,2)) as TotalCommission,
	CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as TotalProfit,
	CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as DaraOpenProfit,
	CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as BaharKaAkharOpenProfit,
	CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as AnderKaAkharOpenProfit,

	CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount) , 0))), DECIMAL(16,2)) as DaraOpen,
	CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount) , 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
	CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount) , 0))), DECIMAL(16,2)) as AnderKaAkharOpen,

	CONVERT(SUM(IF(vd.VoucherType = 32, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0)), DECIMAL(16,2)) as TPC,

	CONVERT((SUM(IF(vd.VoucherType = 29 or vd.VoucherType = 30 or vd.VoucherType = 31, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as Hissa
	,
	CONVERT((SUM(IF(vd.VoucherType in (22,23,24,25,26,27,28,29,30,31,32,35), IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount) , 0))), DECIMAL(16,2)) as Balance

	from voucher_detail vd
	JOIN voucher v on vd.VoucherId = v.VoucherId
	join ledger l on vd.LedgerId = l.LedgerId
	WHERE vd.VoucherDate between varFromDate and varToDate
	and vd.OrganizationId = varOrganizationId
	and (l.OrganizationId = varOrganizationId or ifnull(l.OrganizationId,0) = 0)
	and v.ShiftId = varShiftIds
	and (vd.RecordStatus!='D')
	and (ifnull(varParentId,0) = 0 or l.LedgerId = varParentId or l.ParentLedgerId = varParentId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varParentId))		
	and l.GroupId in (2,3,4,5)
	GROUP BY vd.VoucherDate
	Order By vd.VoucherDate$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_profit_of_ledger_for_last_five_days`(IN `varOrganizationId` BIGINT(8),IN varLedgerId bigint,IN varFromDate Date,IN varToDate Date ,IN varShiftId bigint)
BEGIN

		select vd.VoucherDate
			,
			round(ifnull(vd.TotalSale,0) 
			+ifnull(vd.TotalCommission,0)
			+ifnull(vd.TotalProfit,0)
			+ifnull(vd.Hissa,0)
			+ifnull(vd.TPC,0),0)
			as TodayProfit
		from
			(select vd.VoucherDate,
				CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalSale,
				CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TotalCommission,
				CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalProfit,
				CONVERT(SUM(IF(vd.VoucherType = 32, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TPC,
				CONVERT((SUM(IF(vd.VoucherType = 29 or vd.VoucherType = 30 or vd.VoucherType = 31, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Hissa
				
				from voucher_detail as vd
				join (select ledger.LedgerId,ledger.ParentLedgerId from ledger 
				WHERE ledger.LedgerId = varLedgerId
				)as ledger on vd.LedgerId = ledger.LedgerId or vd.LedgerId = ledger.ParentLedgerId
				
				where (vd.VoucherDate between varFromDate and varToDate)
				and (vd.RecordStatus!='D') 
				and vd.ShiftId = varShiftId
				and (vd.LedgerId = varLedgerId or ledger.ParentLedgerId = varLedgerId)
				group by vd.VoucherDate
			) as vd 
		where ifnull(vd.TotalSale,0) 
			+ifnull(vd.TotalCommission,0)
			+ifnull(vd.TotalProfit,0)
			+ifnull(vd.Hissa,0)
			+ifnull(vd.TPC,0) < 0 
		;
		
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_redeclare_prediction`(
IN `varOrganizationId` BIGINT(8),
IN `varShiftId` BIGINT(8),
IN `varTransactionDate` DATE, 
IN `varNumber` int
)
begin

		
		select	transaction_declare.LedgerId
		,ledger.LedgerName
		
		,-round(ifnull(ProfitTable.OldProfit,0),0) as FirstProfit
		,round(sum(Amount),0) as LastSale

		,round(ifnull(ProfitTable.OldSale,0),0) as FirstSale 
		
		,round(sum(Amount) 
		 - (ifnull(ProfitTable.OldSale,0)),0)  as DiffrenceSale
			
		, round(sum((ifnull((if((Number = varNumber or Number = right(lpad ((varNumber mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((varNumber/10)) mod 10) * 1111 ,4,"0"),4)) and transaction_declare.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction_declare.TransactionMode = 1 ,transaction_detail_declare.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))
		),0)as LastProfit
		
		,varNumber as DeclareNumber

		,round( 
		sum((ifnull((if((Number = varNumber or Number = right(lpad ((varNumber mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((varNumber/10)) mod 10) * 1111 ,4,"0"),4)) and transaction_declare.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction_declare.TransactionMode = 1 ,transaction_detail_declare.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))
		)
		+ ifnull(ProfitTable.OldProfit,0)
		,0) as DiffrenceProfit
		
		,declare_result.ReDeclareNos as RedelareCount
		
		from transaction_declare 
		inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
		left join ledger on ledger.LedgerId = transaction_declare.LedgerId
		left join 
			(
				select vd.VoucherDate,
					
					CONVERT((SUM(IF(vd.VoucherType in (22,23,24,25,26,27,28,29,30,31,32), IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2))
					as OldProfit
					,CONVERT((SUM(IF(vd.VoucherType in (22,23,24), IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2))
					as OldSale
					,vd.LedgerId
					
					from voucher_detail_first as vd
					
					where (vd.VoucherDate = varTransactionDate )
					and (vd.RecordStatus!='D') 
					and (vd.ShiftId = varShiftId )
					group by vd.VoucherDate,vd.LedgerId
			
			) as ProfitTable on ProfitTable.LedgerId = transaction_declare.LedgerId
		inner join (select ReDeclareNos from declare_result where declare_result.DeclareDate = varTransactionDate and declare_result.ShiftId = varShiftId) as declare_result on 1 = 1

		where transaction_declare.TransactionDate = varTransactionDate
		and  transaction_declare.ShiftId = varShiftId
		and  transaction_declare.OrganizationId = varOrganizationId
		and transaction_declare.TransactionMode = 1 
		and transaction_declare.RecordStatus!='D'
		and transaction_detail_declare.RecordStatus!='D'
		group by transaction_declare.LedgerId,ledger.LedgerName,ProfitTable.OldProfit,ProfitTable.OldSale
		having 
		
		not (round(ifnull(ProfitTable.OldProfit,0) 
		+sum((ifnull((if((Number = varNumber or Number = right(lpad ((varNumber mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((varNumber/10)) mod 10) * 1111 ,4,"0"),4)) and transaction_declare.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction_declare.TransactionMode = 1 ,transaction_detail_declare.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))
		),0)
		between -1 and +1)
 		
		order by ledger.LedgerName
    	;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_redeclare_prediction_summary`(
IN `varOrganizationId` BIGINT(8),
IN `varShiftId` BIGINT(8),
IN `varTransactionDate` DATE, 
IN `varNumber` int
)
begin

		
		select round(ifnull(ProfitTable.OldProfit,0),0) as FirstProfit
		,round(ifnull(ProfitTable.OldSale,0),0) as FirstSale
		,round(sum(Amount),0) as LastSale
		
		,round(sum(Amount) 
		 - (ifnull(ProfitTable.OldSale,0)),0)  as DiffrenceSale
			
		,-round(sum((ifnull((if((Number = varNumber or Number = right(lpad ((varNumber mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((varNumber/10)) mod 10) * 1111 ,4,"0"),4)) and transaction_declare.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction_declare.TransactionMode = 1 ,transaction_detail_declare.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))
		),0) as LastProfit
		
		,round((ifnull(ProfitTable.OldProfit,0) 
		+sum((ifnull((if((Number = varNumber or Number = right(lpad ((varNumber mod 10) * 111 ,3,"0"),3)  or Number = right(lpad ((floor((varNumber/10)) mod 10) * 1111 ,4,"0"),4)) and transaction_declare.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction_declare.TransactionMode = 1 ,transaction_detail_declare.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(transaction_declare.SelfHissa,0))/100))*(((100-ifnull(transaction_declare.OtherHissa,0))/100))
		)),0)as DiffrenceProfit
		
		,varNumber as DeclareNumber
		,declare_result.ReDeclareNos as RedelareCount
		
		from transaction_declare 
		inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
		left join ledger on ledger.LedgerId = transaction_declare.LedgerId
		left join 
			(
				select 
					
					CONVERT((SUM(IF(vd.VoucherType in (22,23,24,25,26,27,28,29,30,31,32), IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2))
					as OldProfit
					,CONVERT((SUM(IF(vd.VoucherType in (22,23,24), IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2))
					as OldSale
					
					from voucher_detail_first as vd
					join ledger l on vd.LedgerId = l.LedgerId
					
					where (vd.VoucherDate = varTransactionDate )
					and l.GroupId in (3,4,5)
					and (vd.RecordStatus!='D') 
					and (vd.ShiftId = varShiftId )
			
			) as ProfitTable on 1=1
		inner join (select ReDeclareNos from declare_result where declare_result.DeclareDate = varTransactionDate and declare_result.ShiftId = varShiftId) as declare_result on 1 = 1
		
		
		where transaction_declare.TransactionDate = varTransactionDate
		and  transaction_declare.ShiftId = varShiftId
		and  transaction_declare.OrganizationId = varOrganizationId
		and transaction_declare.TransactionMode = 1 
		and transaction_declare.RecordStatus!='D'
		and transaction_detail_declare.RecordStatus!='D'
		group by ProfitTable.OldProfit,ProfitTable.OldSale
    	;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_search_settling`(
			IN varOrganizationId bigint,
			IN FromDate DATE,
			IN ToDate DATE,
			IN varLedgerId BIGINT(21)
	)
SELECT IFNULL(vd.VoucherDate,FromDate) as VoucherDate
	,ifnull(SUM(TotalSale),0) as TotalSale
	,ifnull(SUM(DaraSale),0) as DaraSale
	,ifnull(SUM(BaharKaAkharSale),0) as BaharKaAkharSale
	,ifnull(SUM(AnderKaAkharSale),0) as AnderKaAkharSale
	,ifnull(SUM(TotalCommission),0) as TotalCommission

	,ifnull(SUM(TotalProfit),0) as TotalProfit

	,ifnull(SUM(DaraOpen),0) as DaraOpen
	,ifnull(SUM(BaharKaAkharOpen),0) as BaharKaAkharOpen
	,ifnull(SUM(AnderKaAkharOpen),0) as AnderKaAkharOpen
	
	,ifnull(SUM(DaraOpenProfit),0) as DaraOpenProfit
	,ifnull(SUM(BaharKaAkharOpenProfit),0) as BaharKaAkharOpenProfit
	,ifnull(SUM(AnderKaAkharOpenProfit),0) as AnderKaAkharOpenProfit
	,ifnull(SUM(TPC),0) as TPC
	,ifnull(SUM(Hissa),0) as Hissa
	,ifnull(OPBal.opening,0) as OpeningBalance
	,ifnull(sum(Kist),0) AS Kist
	,ifnull(sum(Payment),0) Payment
	,ifnull(sum(VapsiAmount),0) VapsiAmount
	,ifnull(sum(HPAmount),0) as  HPAmount
    ,ifnull(max(MondayFinal),2) AS MondayFinal
	,ifnull(TotalSale,0) 
	+ifnull(TotalCommission,0)
	+ifnull(TotalProfit,0)
	+ifnull(Hissa,0)
	+ifnull(TPC,0)
	 as TodayProfit

	from (select LedgerId from ledger where ledger.LedgerId = varLedgerId ) as l 
	left JOIN 
		(select 
		CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalSale,
		CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as DaraSale,
		CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as BaharKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as AnderKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TotalCommission,
		CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalProfit,	
		
		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as DaraOpenProfit,
		CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as BaharKaAkharOpenProfit,
		CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as AnderKaAkharOpenProfit,

		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', - vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as DaraOpen,
		CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', - vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
		CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', - vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as AnderKaAkharOpen,


		CONVERT(SUM(IF(vd.VoucherType = 32, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TPC,

		CONVERT((SUM(IF(vd.VoucherType = 29 or vd.VoucherType = 30 or vd.VoucherType = 31, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as Hissa

		,sum(IF(vd.VoucherType = 3,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) Kist
		,sum(IF(vd.VoucherType = 1,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) Payment

		,sum(IF(vd.VoucherType = 4,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) VapsiAmount
		,sum(IF(vd.VoucherType = 5,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) HPAmount
		
        ,vd.VoucherDate,vd.LedgerId,max(case when MondayFinalFlag = 'True' then 0 else 1 end

) AS MondayFinal 
		from voucher_detail vd 
		where vd.LedgerId = varLedgerId 
        and vd.VoucherType != 2
		and vd.OrganizationId = varOrganizationId
		and (vd.VoucherDate between FromDate and ToDate)
		and (vd.RecordStatus!='D') 
		group by vd.VoucherDate,vd.LedgerId
		) as vd on vd.LedgerId = l.LedgerId 
	left join (Select LedgerId
		,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
		from voucher_detail aa
		Where 
		aa.VoucherDate < FromDate
		and aa.OrganizationId  = varOrganizationId
		and aa.VoucherType != 2
		and aa.RecordStatus != 'D' 
		group by aa.LedgerId ) as OPBal on OPBal.LedgerId = l.LedgerId

/*
and l.LedgerId = varLedgerId
and l.GroupId in (1,2)
*/
GROUP BY vd.VoucherDate, OPBal.opening Order By vd.VoucherDate$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_staff_attendance_detail`(
	IN varOrganizationId int(20), 
	IN varFromDate DATE,
	IN varToDate DATE,
    IN varUserName varchar(50), 
    IN varLedgerId int(20)
    )
BEGIN
	select ledger.LedgerId,ledger.LedgerName,login.UserName,day_transaction.AddedDate
	,ifnull(EntryCount,0) as EntryCount
	,login.Mobile
	,login.Address 
        from (select ledger.LedgerId,ledger.LedgerName from ledger 
		where ledger.OrganizationId = varOrganizationId
		and (ifnull(ledger.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
		and ledger.GroupId = 7
		and ledger.RecordStatus = 'A') as ledger
	inner join login on login.LedgerId = ledger.LedgerId and LoginType not in (2,7) and (ifnull(login.UserName,0) = varUserName or ifnull(varUserName,'') = '' )
	left join (
		select transaction_declare.OrganizationId, DATE(transaction_declare.AddedDate) as AddedDate 
		,transaction_declare.AddedBy,count(1) as EntryCount from transaction_declare  
		where transaction_declare.OrganizationId = varOrganizationId
		and transaction_declare.RecordStatus != 'D'
		and DATE(transaction_declare.AddedDate) between varFromDate and varToDate 
		and (ifnull(transaction_declare.AddedBy,0) = varUserName or ifnull(varUserName,'') = '' )
		group by DATE(transaction_declare.AddedDate),transaction_declare.AddedBy
	) as day_transaction on login.UserName = day_transaction.AddedBy
	order by ledger.LedgerName,day_transaction.AddedDate
	;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_staff_attendance_summary`(
	IN varOrganizationId int(20), 
	IN varFromDate DATE,
	IN varToDate DATE,
    IN varUserName varchar(50), 
    IN varLedgerId int(20)
    )
BEGIN
	select Atten.UserName,Atten.LedgerName
    ,sum(case when Atten.AddedDate is null then 0 else 1 end) + ifnull(payroll_leave.PaidLeave,0) as Attendance
	,datediff(varToDate,varFromDate) + 1 - sum(case when Atten.AddedDate is null then 0 else 1 end) - ifnull(payroll_leave.PaidLeave,0) as Absent
	,datediff(varToDate,varFromDate) + 1 as TotalDays
	,ifnull(sum(Atten.EntryCount),0) EntryCount,Atten.LedgerId
	,Atten.Mobile
	,Atten.Address 
	,payroll_leave.PaidLeave
	,payroll_leave.UnPaidLeave
	from (
		select ledger.LedgerId,ledger.LedgerName,login.UserName,day_transaction.AddedDate,EntryCount
		,login.Mobile
		,login.Address 

		from (select ledger.LedgerId,ledger.LedgerName from ledger 
			where ledger.OrganizationId = varOrganizationId
			and (ifnull(ledger.LedgerId,0) = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and ledger.GroupId = 7
			and ledger.RecordStatus = 'A') as ledger
		inner join login on login.LedgerId = ledger.LedgerId and LoginType not in (2,7) and (ifnull(login.UserName,0) = varUserName or ifnull(varUserName,'') = '' )
		left join (
			select transaction_declare.OrganizationId, DATE(transaction_declare.AddedDate) as AddedDate 
			,transaction_declare.AddedBy,count(1) as EntryCount from transaction_declare  
			where transaction_declare.OrganizationId = varOrganizationId
			and DATE(transaction_declare.AddedDate) between varFromDate and varToDate 
			and (ifnull(transaction_declare.AddedBy,0) = varUserName or ifnull(varUserName,'') = '' )
			group by DATE(transaction_declare.AddedDate),transaction_declare.AddedBy
		) as day_transaction on login.UserName = day_transaction.AddedBy
		order by ledger.LedgerName,day_transaction.AddedDate
	) as Atten
	left join (select sum(case when ifnull(IsPaid,0) = 1 then 1 else 0 end) as PaidLeave
				,sum(case when ifnull(IsPaid,0) = 1 then 0 else 1 end) as UnPaidLeave
				,payroll_leave.LedgerId
			from payroll_leave where payroll_leave.RecordStatus != 'D' 
			and LeaveDate between varFromDate and varToDate 
			group by payroll_leave.LedgerId 
	) as payroll_leave on payroll_leave.LedgerId = Atten.LedgerId
	group by Atten.LedgerId,Atten.LedgerName,Atten.UserName
	,Atten.Mobile
	,Atten.Address 
	,payroll_leave.PaidLeave
	,payroll_leave.UnPaidLeave
	order by Atten.LedgerName,Atten.UserName
	;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_tpc_main_party_detail`(IN FromDate DATE,IN ToDate DATE,IN TPCLedgerId bigint)
Select a.FromLedgerId ,lm.LedgerName
,sum(Amount) as Amount
,ifnull(agent.LedgerName,'NA') as AgentName
from voucher_detail a
join ledger lm on a.FromLedgerId = lm.LedgerId
left join ledger agent on agent.LedgerId = lm.AgentLedgerId
Where(a.RecordStatus != 'D')
and VoucherType = 32
and a.LedgerId = TPCLedgerId
and a.VoucherDate between FromDate and ToDate
Group by lm.LedgerName$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_tpc_Summary`(
In varOrganizationId bigint, IN FromDate DATE,IN ToDate DATE
,In varParentId bigint
)
Select a.LedgerId,lm.LedgerName,sum(Amount) as Amount
,ifnull(agent.CommanMasterName,'NA') as AgentName
from voucher_detail a
join ledger lm on a.LedgerId = lm.LedgerId
left join comman_master agent on agent.CommanMasterId = lm.AgentLedgerId and CommanMasterType = 1
Where(a.RecordStatus != 'D')
and a.OrganizationId = varOrganizationId
and VoucherType = 32
and (lm.LedgerId = varParentId or lm.ParentLedgerId = varParentId or ifnull(varParentId,0) = 0 )
and lm.GroupId in (3,4,5)
and a.VoucherDate between FromDate and ToDate
Group by lm.LedgerName$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Trail_Balance`(
	IN `varOrganizationId` bigint
	, IN `varOnDate` DATE
)
    NO SQL
Select LedgerId, LedgerName,CreditLimit,Remark, Credit, Debit, 
case when Credit > Debit then 'Cr' else case when Debit > Credit then 'Dr' else 'Dr' end end

as AmountType,
case
    when Credit > Debit then Credit - Debit
    else case
        when Debit > Credit then Debit - Credit
        else 0
    end
end as Amount
from (
        Select
            LedgerId, LedgerName, Max(CreditLimit) as CreditLimit, Max(Remark) as Remark, Sum(Credit) as Credit, Sum(Debit) as Debit, 1 as z
        from (
                Select
                    a.LedgerId, b.LedgerName, Max(ledger_limit.LedgerLimit) as CreditLimit, Max(a.Remark) as Remark, a.AmountType, sum(a.Amount) as Credit, 0 as Debit, 2 as z
                from
                    voucher_detail a
                    Join voucher on voucher.VoucherId = a.VoucherId
                    Join ledger b on a.LedgerId = b.LedgerId
                    join ledger_limit on b.LedgerId = ledger_limit.LedgerId
                Where (a.VoucherDate <= varOnDate)
                    and a.OrganizationId = varOrganizationId
                    and a.RecordStatus != 'D'
                    and voucher.RecordStatus != 'D'
                    and a.AmountType = 'Cr'
                    and voucher.VoucherType != 2
                Group By
                    a.LedgerId, b.LedgerName, a.Remark, AmountType
                Union ALL
                Select
                    a.LedgerId, b.LedgerName, Max(ledger_limit.LedgerLimit) as CreditLimit, Max(a.Remark) as Remark, a.AmountType, 0 as Credit, sum(a.Amount) as Debit, 3 as z
                from
                    voucher_detail a
                    Join voucher on voucher.VoucherId = a.VoucherId
                    Join ledger b on a.LedgerId = b.LedgerId
                    join ledger_limit on b.LedgerId = ledger_limit.LedgerId
                Where (a.VoucherDate <= varOnDate)
                    and a.OrganizationId = varOrganizationId
                    and a.RecordStatus != 'D'
                    and voucher.RecordStatus != 'D'
                    and a.AmountType = 'Dr'
                    and voucher.VoucherType != 2
                Group By
                    a.LedgerId, b.LedgerName, a.Remark, AmountType
            ) a
        Group By
            LedgerName, LedgerId
    ) a
Where
    Debit - Credit <> 0
order by LedgerName$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_trans_audit_productivity`(
	IN varOrganizationId bigint
	, IN `varFromDate` DATE 
	, IN `varToDate` DATE 
	, IN `varShiftId` INT)
    NO SQL
SELECT sum(NumberCount) as NumberCount ,sum(TotalAmount) as TotalAmount
	, AddedBy 
	,Mobile,Address,LoginStatus,LoginName
	,LoginType,RoleId,RoleName
	,sum(ValidTrans) as ValidTrans
	,sum(MistakeTrans) as MistakeTrans
	,sum(ModifyTrans) as ModifyTrans
	,count(1) as TotalParty
	from(
		SELECT t.NumberCount ,t.TotalAmount, t.AddedBy 
		,lm.Mobile,lm.Address,lm.AccountStatus LoginStatus,lm.LoginName
		,lm.LoginType,role.RoleId,role.RoleName
		, MistakeTrans
				, ValidTrans
				, ModifyTrans
				
			from (select COUNT(1) as NumberCount ,sum(t.Amount) as TotalAmount, t.AddedBy ,t.LedgerId
				,sum(case when ifnull(t.Remark,'') = '' then 0 else 1 end

) MistakeTrans
				,sum(case when ifnull(t.Remark,'') != '' then 0 else 1 end) ValidTrans
				,sum(case when ifnull(t.ModifyStatus,0) = 0 then 0 else 1 end) ModifyTrans
				from transaction_audit t 
				where (t.RecordStatus != 'D')
				and (t.ShiftDate between varFromDate and varToDate)
				and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
				and t.OrganizationId = varOrganizationId
				group by t.AddedBy,t.LedgerId
			) as t
		Join login lm on lm.UserName = t.AddedBy and lm.RecordStatus != 'D'
		left join role on role.RoleId = lm.LoginType and role.RecordStatus != 'D' and role.OrganizationId = varOrganizationId
		and lm.LoginType not in (3,4,5)
		
		) as AA
	group by  AddedBy 
	,Mobile,Address,LoginStatus,LoginName
	,LoginType,RoleId,RoleName
	order by NumberCount ASC$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_trans_audit_productivity_withtime`(
	IN varOrganizationId bigint
	,IN `varFromDate` DATE 
	, IN `varToDate` DATE 
	, IN `varShiftId` INT
	, IN `varAddedBy` varchar(200))
    NO SQL
begin
declare varEndDate Date;
    set @varEndDate = varFromDate;

select AA.*,shift.ShiftName,@varEndDate ,ifnull( date_format(timediff(AA.AddedDate,@varEndDate),'%H:%i:%s'),'START') as StartDiffrence 
/*,TIMESTAMPDIFF(minute,AA.TransactionStartTime,AA.AddedDate) as TimeTakenInMin
,TIMESTAMPDIFF(minute,@varEndDate,AA.TransactionStartTime) as StartDiffrenceInMin
*/
,@varEndDate:=AA.AddedDate 
from (    
SELECT t.TransactionId,
    t.ShiftDate,
    t.ShiftId,
    t.LedgerId,
    t.Amount,
    t.AddedDate,
    t.RecordStatus,
    t.AddedBy,
    t.UpdatedBy,
    t.UpdatedDate,
    timediff(t.AddedDate,t.AddedDate) as Timetaken
	,ledger.LedgerName
    ,count(t.TransactionId) NoofTrans
    ,(case when ifnull(t.MistakeStatus,0) = 0 or ifnull(t.MistakeStatus,0) = 2 then 0 else 1 end) MistakeStatus
	,t.Remark
	
FROM transaction_audit as t
join ledger on ledger.LedgerId = t.LedgerId
where (t.RecordStatus != 'D')
and (t.ShiftDate between varFromDate and varToDate)
and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
and t.OrganizationId = varOrganizationId
and t.AddedBy = varAddedBy
group by t.TransactionId,
    t.ShiftDate,
    t.ShiftId,
    t.LedgerId,
    t.Amount,
    t.RecordStatus,
    t.AddedBy,
    t.AddedDate,
    t.UpdatedBy,
    t.UpdatedDate
	,ledger.LedgerName
	,t.MistakeStatus
	,t.Remark
order by AddedDate ASC
) as AA
join shift on shift.ShiftId = AA.ShiftId
order by AA.AddedDate ASC

;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Trans_Productivity`(
	IN varOrganizationId bigint
	, IN `varFromDate` DATE 
	, IN `varToDate` DATE 
	, IN `varShiftId` INT
	, IN `varDiffInMin` int
	)
begin
	declare varEndDate Date;
	declare varCheckShiftId int;
	declare varCheckAddedBy int;

    set @varEndDate = varFromDate;
	set @varCheckShiftId = 0 ;
	set @varCheckAddedBy = '' ;
	
	select sum(NumberCount) as NumberCount ,sum(TotalAmount) as TotalAmount
	, AA.AddedBy 
	,Mobile,Address,LoginStatus,LoginName
	,LoginType,RoleId,RoleName

	,round(sum(FreeTimeInSec)/60) FreeTime
	,sum(FreeTimeInSec) FreeTimeInSec
	
	,(sum(  (case when FreeTimeInSec/60 >= varDiffInMin then 1 else 0 end)   )) NoOfFreeTime
	
	/*,AA.TransactionDate
	*/
	,round(sum(TimetakenInSec)/3600) + ((sum(TimetakenInSec)/60 mod 60)/100) Timetaken
	,(sum(TimetakenInSec)) TimetakenInSec
	,min(AA.TransactionStartTime) StartTime
	,max(AA.AddedDate) EndTime
	,round(TIMESTAMPDIFF(second,min(AA.TransactionStartTime),max(AA.AddedDate))/3600)  
	+ (((TIMESTAMPDIFF(second,min(AA.TransactionStartTime),max(AA.AddedDate))/60) mod 60)/100) TotalTime

	from (
		SELECT (NumberCount) as NumberCount ,(TotalAmount) as TotalAmount
		, AA.AddedBy 
		,Mobile,Address,LoginStatus,LoginName
		,LoginType,RoleId,RoleName

		,((   (TIMESTAMPDIFF(second,(case when @varCheckShiftId = 0 or @varCheckAddedBy <> AA.AddedBy then AA.TransactionStartTime else @varEndDate end)
									,AA.TransactionStartTime)
					)
					)) FreeTimeInSec
		,((TIMESTAMPDIFF(second,AA.TransactionStartTime,AA.AddedDate))) TimetakenInSec
		,(AA.TransactionStartTime) TransactionStartTime
		,(AA.AddedDate) AddedDate
		
		,@varEndDate = AA.AddedDate 
		,@varCheckShiftId = AA.ShiftId
		,@varCheckAddedBy = AA.AddedBy
		from(
			SELECT COUNT(1) as NumberCount ,sum(td.Amount) as TotalAmount, t.AddedBy 
			,lm.Mobile,lm.Address,lm.AccountStatus LoginStatus,lm.LoginName
			,lm.LoginType,role.RoleId,role.RoleName
			,t.TransactionStartTime,t.AddedDate
			,t.TransactionId
			,t.TransactionDate,t.ShiftId,t.OrganizationId
			
			FROM transaction_detail td
			Join transaction t on td.TransactionId = t.TransactionId
			Join login lm on lm.UserName = t.AddedBy and lm.RecordStatus != 'D'
			left join role on role.RoleId = lm.LoginType and role.RecordStatus != 'D' and role.OrganizationId = varOrganizationId
			where (td.RecordStatus != 'D')
			and(t.RecordStatus != 'D')
			and (t.TransactionDate between varFromDate and varToDate)
			and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
			and t.OrganizationId = varOrganizationId
			and lm.LoginType not in (3,4,5)
			group by t.AddedBy,lm.Mobile,lm.Address,lm.AccountStatus ,lm.LoginName
			,t.TransactionStartTime,t.AddedDate
			,t.TransactionId
			,t.TransactionDate,t.ShiftId,t.OrganizationId
			
			union all
			
			SELECT COUNT(1) as NumberCount ,sum(td.Amount) as TotalAmount, t.AddedBy 
			,lm.Mobile,lm.Address,lm.AccountStatus LoginStatus,lm.LoginName
			,lm.LoginType,role.RoleId,role.RoleName
			,t.TransactionStartTime,t.AddedDate
			,t.TransactionId
			,t.TransactionDate,t.ShiftId,t.OrganizationId

			FROM transaction_detail_declare td
			Join transaction_declare t on td.TransactionId = t.TransactionId
			Join login lm on lm.UserName = t.AddedBy and lm.RecordStatus != 'D'
			left join role on role.RoleId = lm.LoginType and role.RecordStatus != 'D' and role.OrganizationId = varOrganizationId
			where (td.RecordStatus != 'D')
			and(t.RecordStatus != 'D')
			and (t.TransactionDate between varFromDate and varToDate)
			and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
			and t.OrganizationId = varOrganizationId
			and lm.LoginType not in (3,4,5)
			group by t.AddedBy,lm.Mobile,lm.Address,lm.AccountStatus ,lm.LoginName
			,t.TransactionStartTime,t.AddedDate
			,t.TransactionId
			,t.TransactionDate,t.ShiftId,t.OrganizationId
			
			
		) as AA
/*		join declare_result on declare_result.DeclareDate = AA.TransactionDate and declare_result.ShiftId = AA.ShiftId and declare_result.OrganizationId = AA.OrganizationId 

		where declare_result.AddedDate >= AA.AddedDate
*/
/*		
		group by  AddedBy 
		,Mobile,Address,LoginStatus,LoginName
		,LoginType,RoleId,RoleName
*/
		order by  AddedBy 
		,TransactionStartTime
		
	) as AA
	group by  AddedBy 
	,Mobile,Address,LoginStatus,LoginName
	,LoginType,RoleId,RoleName
	order by NumberCount ASC
	;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_trans_productivity_datewise`(
	IN varOrganizationId bigint
	, IN `varFromDate` DATE 
	, IN `varToDate` DATE 
	, IN `varLoginName` varchar(100)
	
	)
begin

	declare intRow smallint default 0;
	declare intTotalRow smallint default 0;
	
	set intTotalRow = datediff(varToDate,varFromDate) ;
	
	set @sTemp1 = '';
	set @sTemp2 = '';
	set @sTemp3 = '';
	set @sTemp4 = 'SELECT 0 as DataFlag ';
	while intRow <= intTotalRow Do
		set @sTemp1 = CONCAT(@sTemp1,',convert(sum(NumberCount',convert(intRow,char),'),char) as NumberCount',convert(intRow,char),' ');
		set @sTemp2 = CONCAT(@sTemp2,',sum(case when t.TransactionDate = ''',convert(DATE_ADD(varFromDate,INTERVAL intRow DAY),char),''' 
						then 1 else 0 end) as NumberCount',convert(intRow,char),' ');
		set @sTemp3 = CONCAT(@sTemp3,',sum(case when t.ShiftDate = ''',convert(DATE_ADD(varFromDate,INTERVAL intRow DAY),char),''' 
						then 1 else 0 end) as NumberCount',convert(intRow,char),' ');

		set @sTemp4 = CONCAT(@sTemp4,',date_format(''',convert(DATE_ADD(varFromDate,INTERVAL intRow DAY),char),''' ,''%d-%m-%Y'') 
						as NumberCount',convert(intRow,char),' ');

		set intRow = intRow + 1;
	end while;
		
		
		
	set @s = CONCAT('
	SELECT 1 as DataFlag ',@sTemp1,'
	from(

		SELECT 1 as DataFlag 
		',@sTemp2,'
		FROM transaction_detail td
		Join transaction t on td.TransactionId = t.TransactionId 
		where (td.RecordStatus != ''D'')
		and(t.RecordStatus != ''D'')
		and (t.TransactionDate between ''',convert(varFromDate,char),''' and ''',convert(varToDate,char),''')
		and t.OrganizationId = ',convert(varOrganizationId,char),'
		and t.AddedBy = ''',convert(varLoginName,char),'''		

		union all

		SELECT 1 as DataFlag 
		',@sTemp2,'
		FROM transaction_detail_declare td
		Join transaction_declare t on td.TransactionId = t.TransactionId
		where (td.RecordStatus != ''D'')
		and(t.RecordStatus != ''D'')
		and (t.TransactionDate between ''',convert(varFromDate,char),''' and ''',convert(varToDate,char),''')
		and t.OrganizationId = ',convert(varOrganizationId,char),'
		and t.AddedBy = ''',convert(varLoginName,char),'''		
		
		union all

		SELECT 1 as DataFlag
		',@sTemp3,'
		from transaction_audit t 
		where (t.RecordStatus != ''D'')
		and (t.ShiftDate between ''',convert(varFromDate,char),''' and ''',convert(varToDate,char),''')
		and t.OrganizationId = ',convert(varOrganizationId,char),'
		and t.AddedBy = ''',convert(varLoginName,char),'''		

		) as AA

	')
	;
	set @s = CONCAT(@sTemp4,'
	union all 
	'
	,@s,'
	order by DataFlag');
	

	/*
	select @s;
	*/
	
	PREPARE stmt FROM @s;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_trans_productivity_datewise_dynamic`(
	IN varOrganizationId bigint
	, IN `varFromDate` DATE 
	, IN `varToDate` DATE 
	, IN `varLoginName` varchar(100)
)
    NO SQL
begin
	
	DECLARE intRow int;
	declare intTotalRow smallint default 0;

	set intRow = 0;
	set intTotalRow = datediff(varToDate,varFromDate) ;
	
	SET @s = CONCAT('		
					SELECT 1 as DataFlag,AA.AddedBy 	
					,lm.Mobile,lm.Address,lm.AccountStatus LoginStatus,lm.LoginName
					,lm.LoginType,role.RoleId,role.RoleName
					,sum(AA.NumberCount) as NumberCount
					' );

	SET @sTemp = CONCAT('		
					SELECT 0 as DataFlag,'''' as AddedBy 	
					,'''' as Mobile,'''' as Address,'''' as LoginStatus,'''' as LoginName
					,'''' as LoginType,0 as RoleId,'''' as RoleName
					,0 as NumberCount
					' );

	while intRow <= intTotalRow Do
		
		SET @s = CONCAT(@s,'
		,convert(sum(case when AA.TransactionDate = ''',convert(DATE_ADD(varFromDate,INTERVAL intRow DAY),char),''' then 
						NumberCount else 0 end),char) as NumberCount',convert(intRow,char),' 
		');
		SET @s = CONCAT(@s,'
		,convert(round(sum(case when AA.TransactionDate = ''',convert(DATE_ADD(varFromDate,INTERVAL intRow DAY),char),''' then 
						NumberCount else 0 end) / (case when lm.LoginType = 12 then 0.6 else 58 end)) ,char) as NumberPercent',convert(intRow,char),' 
		');


		set @sTemp = CONCAT(@sTemp,',date_format(''',convert(DATE_ADD(varFromDate,INTERVAL intRow DAY),char),''' ,''%d-%m-%Y'') 
						as NumberCount',convert(intRow,char),' ');

		set @sTemp = CONCAT(@sTemp,',0 as NumberPercent',convert(intRow,char),' ');

			
		set intRow = intRow + 1;
		
	end while;

	SET @s = CONCAT(@s,'
	from(
		SELECT COUNT(1) as NumberCount , t.AddedBy 
		,t.TransactionDate
		FROM transaction_detail td
		Join transaction t on td.TransactionId = t.TransactionId
		where (td.RecordStatus != ''D'')
		and(t.RecordStatus != ''D'')
		and (t.TransactionDate between ''',convert(varFromDate,char),''' and ''',convert(varToDate,char),''')
		and t.OrganizationId = ',convert(varOrganizationId,char),'
		and (t.AddedBy = ''',convert(ifnull(varLoginName,''),char),'''  or ''',convert(ifnull(varLoginName,''),char),''' = '''')		
		group by t.AddedBy,t.TransactionDate
		union all

		SELECT COUNT(1) as NumberCount , t.AddedBy 
		,t.TransactionDate
		FROM transaction_detail_declare td
		Join transaction_declare t on td.TransactionId = t.TransactionId
		where (td.RecordStatus != ''D'')
		and(t.RecordStatus != ''D'')
		and (t.TransactionDate between ''',convert(varFromDate,char),''' and ''',convert(varToDate,char),''')
		and t.OrganizationId = ',convert(varOrganizationId,char),'
		and (t.AddedBy = ''',convert(ifnull(varLoginName,''),char),'''  or ''',convert(ifnull(varLoginName,''),char),''' = '''')		
		group by t.AddedBy,t.TransactionDate
		union all

		SELECT COUNT(1) as NumberCount , t.AddedBy 
		,t.ShiftDate as TransactionDate
		from transaction_audit t 
		where (t.RecordStatus != ''D'')
		and (t.ShiftDate between ''',convert(varFromDate,char),''' and ''',convert(varToDate,char),''')
		and t.OrganizationId = ',convert(varOrganizationId,char),'
		and (t.AddedBy = ''',convert(ifnull(varLoginName,''),char),'''  or ''',convert(ifnull(varLoginName,''),char),''' = '''')		
		group by t.AddedBy,t.ShiftDate

		) as AA
	Join login lm on lm.UserName = AA.AddedBy and lm.RecordStatus != ''D''
	left join role on role.RoleId = lm.LoginType and role.RecordStatus != ''D'' and role.OrganizationId = ',convert(varOrganizationId,char),'
	where lm.LoginType not in (1,3,4,5)

	group by  AA.AddedBy 
	,lm.Mobile,lm.Address,lm.AccountStatus ,lm.LoginName
	,lm.LoginType,role.RoleId,role.RoleName
	order by NumberCount ASC
	')
	
	;

	SET @s = CONCAT(@sTemp,'
			union all
			'
			,@s)
	;
	PREPARE stmt FROM @s;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
/*
	select @s;
*/
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_trans_productivity_shiftwise`(
	IN varOrganizationId bigint
	, IN `varFromDate` DATE 
	, IN `varToDate` DATE 
)
    NO SQL
begin
	
	DECLARE varShiftId bigint;
	DECLARE intRow int;
	DECLARE varShiftName varchar(100);
	
	DECLARE finished INTEGER DEFAULT 0;
	DEClARE curLedger 
		CURSOR FOR 
		select shift.ShiftId,shift.ShiftName from shift
		where RecordStatus != 'D'
		and shift.OrganizationId = varOrganizationId
        order by ShiftOrder        
	;
	
	DECLARE CONTINUE HANDLER 
	FOR NOT FOUND SET finished = 1;
				
	set varShiftId = 0;
	set intRow = 1;
	
	SET @s = CONCAT('		
					SELECT 1 as DataFlag,AA.AddedBy 	
					,lm.Mobile,lm.Address,lm.AccountStatus LoginStatus,lm.LoginName
					,lm.LoginType,role.RoleId,role.RoleName
					,sum(AA.NumberCount) as NumberCount
					' );

	SET @sTemp = CONCAT('		
					SELECT 0 as DataFlag,'''' as AddedBy 	
					,'''' as Mobile,'''' as Address,'''' as LoginStatus,'''' as LoginName
					,'''' as LoginType,0 as RoleId,'''' as RoleName
					,0 as NumberCount
					' );

	OPEN curLedger;
			
getLedger: LOOP

		FETCH curLedger INTO varShiftId,varShiftName;
		IF finished = 1 THEN 
			LEAVE getLedger;
		END IF;

		
		SET @s = CONCAT(@s,'
		,''',varShiftName,''' as Shift',convert(intRow,char),' 
		,sum(case when AA.ShiftId = ',convert(varShiftId,char),' then AA.NumberCount else 0 end) as NumberCount',convert(intRow,char),' 
		,sum(case when AA.ShiftId = ',convert(varShiftId,char),' then AA.TotalAmount else 0 end) as TotalAmount',convert(intRow,char),'
		');

			SET @sTemp = CONCAT(@sTemp,'
			,''',varShiftName,''' as Shift',convert(intRow,char),' 
			,0 as NumberCount',convert(intRow,char),' 
			,',convert(varShiftId,char),' as TotalAmount',convert(intRow,char),'
			');
			
		set intRow = intRow + 1;
		
	END LOOP getLedger;
	CLOSE curLedger;

	SET @s = CONCAT(@s,'
	from(
		SELECT COUNT(*) as NumberCount ,sum(td.Amount) as TotalAmount, t.AddedBy 
		,t.ShiftId
		FROM transaction_detail td
		Join transaction t on td.TransactionId = t.TransactionId
		where (td.RecordStatus != ''D'')
		and(t.RecordStatus != ''D'')
		and (t.TransactionDate between ''',convert(varFromDate,char),''' and ''',convert(varToDate,char),''')
		and t.OrganizationId = ',convert(varOrganizationId,char),'
		group by t.AddedBy,t.ShiftId
		union all
		SELECT COUNT(*) as NumberCount ,sum(td.Amount) as TotalAmount, t.AddedBy 
		,t.ShiftId
		FROM transaction_detail_declare td
		Join transaction_declare t on td.TransactionId = t.TransactionId
		where (td.RecordStatus != ''D'')
		and(t.RecordStatus != ''D'')
		and (t.TransactionDate between ''',convert(varFromDate,char),''' and ''',convert(varToDate,char),''')
		and t.OrganizationId = ',convert(varOrganizationId,char),'
		group by t.AddedBy,t.ShiftId
		) as AA
	Join login lm on lm.UserName = AA.AddedBy and lm.RecordStatus != ''D''
	left join role on role.RoleId = lm.LoginType and role.RecordStatus != ''D'' and role.OrganizationId = ',convert(varOrganizationId,char),'
	where lm.LoginType not in (1,3,4,5)

	group by  AA.AddedBy 
	,lm.Mobile,lm.Address,lm.AccountStatus ,lm.LoginName
	,lm.LoginType,role.RoleId,role.RoleName
	order by NumberCount ASC
	')
	
	;

	SET @s = CONCAT(@sTemp,'
			union all
			'
			,@s)
	;
	PREPARE stmt FROM @s;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
/*
	select @s;
*/
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Trans_Productivity_Topper_Looser`(
	IN varOrganizationId bigint
	,IN varOnDate DATE
	)
    NO SQL
begin

SELECT NumberCount ,TotalAmount
	, AddedBy 
	,Mobile,Address,LoginStatus,LoginName
	,LoginType,RoleId,RoleName,TopFlag
 from toppers_losser
where OrganizationId = varOrganizationId
order by NumberCountOrder asc 
;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Trans_Productivity_Topper_Looser_insert`(
	IN varOnDate DATE
	)
    NO SQL
begin
	
	DECLARE varOrganizationId bigint;
	
	DECLARE finished INTEGER DEFAULT 0;
	DEClARE curLedger 
		CURSOR FOR 
		select organization.OrganizationId from organization
		where RecordStatus != 'D'
		and IsOrganizationAllow = 1
	;
	
	DECLARE CONTINUE HANDLER 
	FOR NOT FOUND SET finished = 1;
				
		set varOrganizationId = 0;

	OPEN curLedger;
			
getLedger: LOOP

	FETCH curLedger INTO varOrganizationId;
	IF finished = 1 THEN 
		LEAVE getLedger;
	END IF;

	delete from toppers_losser
	where OrganizationId = varOrganizationId
	;

		insert into toppers_losser(NumberCount,TotalAmount,AddedBy,Mobile,Address,LoginStatus,LoginName,LoginType,RoleId,RoleName,TopFlag,NumberCountOrder,OrganizationId)
		SELECT sum(NumberCount) as NumberCount ,sum(TotalAmount) as TotalAmount
			, AddedBy 
			,Mobile,Address,LoginStatus,LoginName
			,LoginType,RoleId,RoleName,1 AS TopFlag
			,sum(NumberCount) as NumberCountOrder
			,varOrganizationId
			from(
				SELECT COUNT(*) as NumberCount ,sum(td.Amount) as TotalAmount, t.AddedBy 
				,lm.Mobile,lm.Address,lm.AccountStatus LoginStatus,lm.LoginName
				,lm.LoginType,role.RoleId,role.RoleName
				FROM transaction_detail td
				Join transaction t on td.TransactionId = t.TransactionId
				Join login lm on lm.UserName = t.AddedBy and lm.RecordStatus != 'D'
				left join role on role.RoleId = lm.LoginType and role.RecordStatus != 'D' and role.OrganizationId = varOrganizationId
				where (td.RecordStatus != 'D')
				and(t.RecordStatus != 'D')
				and t.TransactionDate = DATE_ADD(varOnDate,INTERVAL -1 DAY)
		/*		and (t.TransactionDate between varFromDate and varToDate)
				and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
		*/		and t.OrganizationId = varOrganizationId
				and lm.LoginType not in (3,4,5)
				and lm.StaffWorkMode in (1,2)
				group by t.AddedBy,lm.Mobile,lm.Address,lm.AccountStatus ,lm.LoginName
				union all
				SELECT COUNT(*) as NumberCount ,sum(td.Amount) as TotalAmount, t.AddedBy 
				,lm.Mobile,lm.Address,lm.AccountStatus LoginStatus,lm.LoginName
				,lm.LoginType,role.RoleId,role.RoleName
				FROM transaction_detail_declare td
				Join transaction_declare t on td.TransactionId = t.TransactionId
				Join login lm on lm.UserName = t.AddedBy and lm.RecordStatus != 'D'
				left join role on role.RoleId = lm.LoginType and role.RecordStatus != 'D' and role.OrganizationId = varOrganizationId
				where (td.RecordStatus != 'D')
				and(t.RecordStatus != 'D')
				and t.TransactionDate = DATE_ADD(varOnDate,INTERVAL -1 DAY)
		/*		and (t.TransactionDate between varFromDate and varToDate)
				and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
		*/		and t.OrganizationId = varOrganizationId
				and lm.LoginType not in (3,4,5)
				and lm.StaffWorkMode in (1,2)
				group by t.AddedBy,lm.Mobile,lm.Address,lm.AccountStatus ,lm.LoginName
				) as AA
			group by  AddedBy 
			,Mobile,Address,LoginStatus,LoginName
			,LoginType,RoleId,RoleName
			order by NumberCount asc LIMIT 5
		;	


		insert into toppers_losser(NumberCount,TotalAmount,AddedBy,Mobile,Address,LoginStatus,LoginName,LoginType,RoleId,RoleName,TopFlag,NumberCountOrder,OrganizationId)
		SELECT sum(NumberCount) as NumberCount ,sum(TotalAmount) as TotalAmount
			, AddedBy 
			,Mobile,Address,LoginStatus,LoginName
			,LoginType,RoleId,RoleName,0 AS TopFlag
			,-sum(NumberCount) as NumberCountOrder
			,varOrganizationId
			from(
				SELECT COUNT(*) as NumberCount ,sum(td.Amount) as TotalAmount, t.AddedBy 
				,lm.Mobile,lm.Address,lm.AccountStatus LoginStatus,lm.LoginName
				,lm.LoginType,role.RoleId,role.RoleName
				FROM transaction_detail td
				Join transaction t on td.TransactionId = t.TransactionId
				Join login lm on lm.UserName = t.AddedBy and lm.RecordStatus != 'D'
				left join role on role.RoleId = lm.LoginType and role.RecordStatus != 'D' and role.OrganizationId = varOrganizationId
				where (td.RecordStatus != 'D')
				and(t.RecordStatus != 'D')
				and t.TransactionDate = DATE_ADD(varOnDate,INTERVAL -1 DAY)
		/*		and (t.TransactionDate between varFromDate and varToDate)
				and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
		*/		and t.OrganizationId = varOrganizationId
				and lm.LoginType not in (3,4,5)
				and lm.StaffWorkMode in (1,2)
				group by t.AddedBy,lm.Mobile,lm.Address,lm.AccountStatus ,lm.LoginName
				union all
				SELECT COUNT(*) as NumberCount ,sum(td.Amount) as TotalAmount, t.AddedBy 
				,lm.Mobile,lm.Address,lm.AccountStatus LoginStatus,lm.LoginName
				,lm.LoginType,role.RoleId,role.RoleName
				FROM transaction_detail_declare td
				Join transaction_declare t on td.TransactionId = t.TransactionId
				Join login lm on lm.UserName = t.AddedBy and lm.RecordStatus != 'D'
				left join role on role.RoleId = lm.LoginType and role.RecordStatus != 'D' and role.OrganizationId = varOrganizationId
				where (td.RecordStatus != 'D')
				and(t.RecordStatus != 'D')
				and t.TransactionDate = DATE_ADD(varOnDate,INTERVAL -1 DAY)
		/*		and (t.TransactionDate between varFromDate and varToDate)
				and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
		*/		and t.OrganizationId = varOrganizationId
				and lm.LoginType not in (3,4,5)
				and lm.StaffWorkMode in (1,2)
				group by t.AddedBy,lm.Mobile,lm.Address,lm.AccountStatus ,lm.LoginName
				) as AA
			group by  AddedBy 
			,Mobile,Address,LoginStatus,LoginName
			,LoginType,RoleId,RoleName
			order by NumberCount desc LIMIT 5
		;
		/*
		SELECT NumberCount ,TotalAmount
			, AddedBy 
			,Mobile,Address,LoginStatus,LoginName
			,LoginType,RoleId,RoleName,TopFlag
		 from toppers_losser
		where OrganizationId = varOrganizationId
		order by NumberCountOrder asc 
		;
		*/
	END LOOP getLedger;
	CLOSE curLedger;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Trans_Productivity_WithTime`(
	IN varOrganizationId bigint
	,IN `varFromDate` DATE 
	, IN `varToDate` DATE 
	, IN `varShiftId` INT
	, IN `varAddedBy` varchar(200)
	, IN `varDiffInMin` int)
    NO SQL
begin
declare varEndDate Date;
	declare varCheckShiftId int;
	declare varCheckAddedBy int;

    set @varEndDate = varFromDate;
	set @varCheckShiftId = 0 ;
	set @varCheckAddedBy = '' ;



select * from 
(
	select @varEndDate
	,AA.TransactionStartTime
	,AA.AddedDate
	
	,ifnull( date_format(timediff(AA.TransactionStartTime,(case when @varCheckShiftId = 0 or @varCheckAddedBy <> AA.AddedBy then AA.TransactionStartTime else @varEndDate end))
	,'%H:%i:%s'),'START') as StartDiffrence 
	/*,TIMESTAMPDIFF(minute,AA.TransactionStartTime,AA.AddedDate) as TimeTakenInMin
	,TIMESTAMPDIFF(minute,@varEndDate,AA.TransactionStartTime) as StartDiffrenceInMin
	*/
	,(TIMESTAMPDIFF(second,(case when @varCheckShiftId = 0 or @varCheckAddedBy <> AA.AddedBy then AA.TransactionStartTime else @varEndDate end),AA.TransactionStartTime)
				) FreeTime
	,(TIMESTAMPDIFF(second,(case when @varCheckShiftId = 0 or @varCheckAddedBy <> AA.AddedBy then AA.TransactionStartTime else @varEndDate end),AA.TransactionStartTime)
				)/60 FreeTimeInMin
	,varDiffInMin as Diff
	,AA.TransactionId,
		AA.TransactionDate,
		AA.ShiftId,
		AA.LedgerId,
		AA.KFlag,
		AA.ClientRemarks,
		AA.IsHissa,
		AA.DaraRate,
		AA.DaraCommission,
		AA.AkharRate,
		AA.AkharCommission,
		AA.TotalAmount,
		AA.RecordStatus,
		AA.AddedBy,
		AA.UpdatedBy,
		AA.UpdatedDate,
		AA.Timetaken
		,AA.LedgerName
		,AA.NoofTrans
		,AA.ShiftName


	,@varEndDate:=AA.AddedDate 
	,@varCheckShiftId:=AA.ShiftId 
	,@varCheckAddedBy:= AA.AddedBy
	from (    
	SELECT t.TransactionId,
		t.TransactionDate,
		t.ShiftId,
		t.LedgerId,
		t.KFlag,
		t.ClientRemarks,
		t.IsHissa,
		t.DaraRate,
		t.DaraCommission,
		t.AkharRate,
		t.AkharCommission,
		t.TotalAmount,
		t.TransactionStartTime,
		t.RecordStatus,
		t.AddedBy,
		t.AddedDate,
		t.UpdatedBy,
		t.UpdatedDate,
		timediff(t.AddedDate,t.TransactionStartTime) as Timetaken
		,ledger.LedgerName
		,count(td.TransactionId) NoofTrans
		,shift.ShiftName
		
		
	FROM transaction as t
	Join transaction_detail td on td.TransactionId = t.TransactionId
	left join ledger on ledger.LedgerId = t.LedgerId
	left join shift on shift.ShiftId = t.ShiftId

	where (t.RecordStatus != 'D')
	and (t.TransactionDate between varFromDate and varToDate)
	and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
	and t.OrganizationId = varOrganizationId
	and t.AddedBy = varAddedBy
	group by t.TransactionId,
		t.TransactionDate,
		t.ShiftId,
		t.LedgerId,
		t.KFlag,
		t.ClientRemarks,
		t.IsHissa,
		t.DaraRate,
		t.DaraCommission,
		t.AkharRate,
		t.AkharCommission,
		t.TotalAmount,
		t.RecordStatus,
		t.AddedBy,
		t.AddedDate,
		t.UpdatedBy,
		t.UpdatedDate
		,ledger.LedgerName
		,shift.ShiftName
	union all

	SELECT tmp.TransactionId,
		tmp.TransactionDate,
		tmp.ShiftId,
		tmp.LedgerId,
		tmp.KFlag,
		tmp.ClientRemarks,
		tmp.IsHissa,
		tmp.DaraRate,
		tmp.DaraCommission,
		tmp.AkharRate,
		tmp.AkharCommission,
		tmp.TotalAmount,
		tmp.TransactionStartTime,
		tmp.RecordStatus,
		tmp.AddedBy,
		tmp.AddedDate,
		tmp.UpdatedBy,
		tmp.UpdatedDate,
		timediff(tmp.AddedDate,tmp.TransactionStartTime) as Timetaken
		,ledger.LedgerName
		,count(tdtmp.TransactionId) NoofTrans
		,shift.ShiftName
		
	FROM transaction_declare as tmp
	Join transaction_detail_declare tdtmp on tdtmp.TransactionId = tmp.TransactionId
	left join ledger on ledger.LedgerId = tmp.LedgerId
	left join shift on shift.ShiftId = tmp.ShiftId


	where (tmp.RecordStatus != 'D')
	and (tmp.TransactionDate between varFromDate and varToDate)
	and (ifnull(varShiftId,0) = 0 or tmp.ShiftId = varShiftId)
	and tmp.OrganizationId = varOrganizationId

	and tmp.AddedBy = varAddedBy
	group by tmp.TransactionId,
		tmp.TransactionDate,
		tmp.ShiftId,
		tmp.LedgerId,
		tmp.KFlag,
		tmp.ClientRemarks,
		tmp.IsHissa,
		tmp.DaraRate,
		tmp.DaraCommission,
		tmp.AkharRate,
		tmp.AkharCommission,
		tmp.TotalAmount,
		tmp.RecordStatus,
		tmp.AddedBy,
		tmp.AddedDate,
		tmp.UpdatedBy,
		tmp.UpdatedDate
		,ledger.LedgerName
		,shift.ShiftName
	order by TransactionStartTime ASC
	) as AA
	order by AA.TransactionStartTime ASC
) as AA
where FreeTimeInMin >=  varDiffInMin
order by AA.TransactionStartTime ASC
;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_transaction_ASC`(
IN `varOrganizationId` BIGINT(8),
IN `varTransactionDate` DATE, 
IN `varShiftId` BIGINT(8),
IN `varAmountFrom` smallint(6) 
)
begin

	SELECT t.LedgerId,l.LedgerName
	,td.Number
	,sum(td.Amount) AS SaleAmount
	,ifnull( CONVERT(ProfitTable.PLAmount,DECIMAL(16,0)) ,0) as ProfitLossAmount
	,td.Rate
	,t.SelfHissa
	,t.OtherHissa
	,td.Commission
	
	 FROM transaction_detail td
	Left JOIN transaction t on td.TransactionId = t.TransactionId
	JOIN ledger l on t.LedgerId = l.LedgerId
	left join (

		select sum((ifnull((if((Number = mainjantrinumbers.Num or Number = right(lpad ((mainjantrinumbers.Num mod 10) * 111 ,3,"0"),3)  
		or Number = right(lpad ((floor((mainjantrinumbers.Num/10)) mod 10) * 1111 ,4,"0"),4)) 
		and transaction.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction.TransactionMode = 1 ,transaction_detail.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(Hissa,0))/100))
		)as PLAmount ,mainjantrinumbers.Num as OpenNumber ,transaction.LedgerId

		from transaction 
		inner join transaction_detail on transaction.TransactionId = transaction_detail.TransactionId
		left join (select sum(hissa.Hissa) as Hissa,hissa.LedgerId from hissa where hissa.RecordStatus!='D'  and hissa.HissaLedgerId = hissa.LedgerId group by hissa.LedgerId)
			as LH on  LH.LedgerId = transaction.LedgerId  
		join mainjantrinumbers on 1 = 1
		where transaction.TransactionDate = varTransactionDate
		and transaction.ShiftId = varShiftId
		and transaction.OrganizationId = varOrganizationId
		and transaction.TransactionMode = 1 
		and transaction.RecordStatus!='D'
		and transaction_detail.RecordStatus!='D'
		group by mainjantrinumbers.Num,transaction.LedgerId
	) as ProfitTable
	on td.Number = ProfitTable.OpenNumber and ProfitTable.LedgerId = l.LedgerId

	WHERE t.TransactionMode = 1 
	and td.RecordStatus != 'D'
	and t.RecordStatus != 'D'
	and t.ShiftId = varShiftId
	and t.TransactionDate = varTransactionDate
    and t.OrganizationId = varOrganizationId
	group by t.LedgerId,td.Number,l.LedgerName
	having sum(td.Amount) >= varAmountFrom 
	#ORDER by PLAmount DESC
    ORDER by SaleAmount DESC
;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_transaction_ASC_declare`(
IN `varOrganizationId` BIGINT(8),
IN `varTransactionDate` DATE, 
IN `varShiftId` BIGINT(8),
IN `varAmountFrom` smallint(6) 
)
begin

	SELECT t.LedgerId,l.LedgerName
	,td.Number
	,sum(td.Amount) AS SaleAmount
	,ifnull( CONVERT(ProfitTable.PLAmount,DECIMAL(16,0)) ,0) as ProfitLossAmount
	,td.Rate
	,t.SelfHissa
	,t.OtherHissa
	,td.Commission

	 FROM transaction_detail_declare td
	Left JOIN transaction_declare t on td.TransactionId = t.TransactionId
	JOIN ledger l on t.LedgerId = l.LedgerId
	left join (

		select sum((ifnull((if((Number = mainjantrinumbers.Num or Number = right(lpad ((mainjantrinumbers.Num mod 10) * 111 ,3,"0"),3)  
		or Number = right(lpad ((floor((mainjantrinumbers.Num/10)) mod 10) * 1111 ,4,"0"),4)) 
		and transaction_declare.TransactionMode = 1 ,Amount * Rate ,0 )),0)
		- ifnull((if(transaction_declare.TransactionMode = 1 ,transaction_detail_declare.FinalAmount ,0 )),0)
		)
		*(((100-ifnull(Hissa,0))/100))
		)as PLAmount ,mainjantrinumbers.Num as OpenNumber ,transaction_declare.LedgerId

		from transaction_declare 
		inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
		left join (select sum(hissa.Hissa) as Hissa,hissa.LedgerId from hissa where hissa.RecordStatus!='D'  and hissa.HissaLedgerId = hissa.LedgerId group by hissa.LedgerId)
			as LH on  LH.LedgerId = transaction_declare.LedgerId  
		join mainjantrinumbers on 1 = 1
		where transaction_declare.TransactionDate = varTransactionDate
		and transaction_declare.ShiftId = varShiftId
		and transaction_declare.OrganizationId = varOrganizationId
		and transaction_declare.TransactionMode = 1 
		and transaction_declare.RecordStatus!='D'
		and transaction_detail_declare.RecordStatus!='D'
		group by mainjantrinumbers.Num,transaction_declare.LedgerId
	) as ProfitTable
	on td.Number = ProfitTable.OpenNumber and ProfitTable.LedgerId = l.LedgerId

	WHERE t.TransactionMode = 1 
	and td.RecordStatus != 'D'
	and t.RecordStatus != 'D'
	and t.ShiftId = varShiftId
	and t.TransactionDate = varTransactionDate
    and t.OrganizationId = varOrganizationId
	group by t.LedgerId,td.Number,l.LedgerName
	having sum(td.Amount) >= varAmountFrom 
	#ORDER by PLAmount DESC
    ORDER by SaleAmount DESC
;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_transaction_duplicate`(
	IN varOrganizationId bigint
	, IN varShiftId bigint
	, IN varShiftDate DATE
)
    NO SQL
SELECT 
    t.TransactionId,
    t.OrganizationId,
    t.ShiftId,
    t.LedgerId,
    convert(t.TransactionDate,char) as TransactionDate,
    t.TransactionMode,
    t.TransactionType,
    t.TotalAmount,
    t.FinalAmount,
    t.TransactionStartTime,
	shift.ShiftName,
	ledger.LedgerName,
	0 currentTrans,
	count(1) as NoofTrans
	
	FROM transaction_declare as t
	join shift on shift.ShiftId = t.ShiftId
	join ledger on ledger.LedgerId = t.LedgerId
	where t.TransactionDate = varShiftDate
	and t.RecordStatus != 'D'
	and (t.ShiftId = varShiftId or ifnull(varShiftId,0) = 0)
	and t.OrganizationId = varOrganizationId
	group by 
    t.OrganizationId,
    t.ShiftId,
    t.LedgerId,
    t.TransactionDate,
    t.TransactionMode,
    t.TransactionType,
    t.TotalAmount,
    t.FinalAmount,
    t.TransactionStartTime,
	shift.ShiftName,
	ledger.LedgerName
    ,t.AddedBy
	having count(1) > 1
union all	
SELECT 
    t.TransactionId,
    t.OrganizationId,
    t.ShiftId,
    t.LedgerId,
    convert(t.TransactionDate,char) as TransactionDate,
    t.TransactionMode,
    t.TransactionType,
    t.TotalAmount,
    t.FinalAmount,
    t.TransactionStartTime,
	shift.ShiftName,
	ledger.LedgerName,
	1 currentTrans,
	count(1) as NoofTrans
	
	FROM transaction as t
	join shift on shift.ShiftId = t.ShiftId
	join ledger on ledger.LedgerId = t.LedgerId
	where t.TransactionDate = varShiftDate
	and t.RecordStatus != 'D'
	and (t.ShiftId = varShiftId or ifnull(varShiftId,0) = 0)
	and t.OrganizationId = varOrganizationId
	group by 
    t.OrganizationId,
    t.ShiftId,
    t.LedgerId,
    t.TransactionDate,
    t.TransactionMode,
    t.TransactionType,
    t.TotalAmount,
    t.FinalAmount,
    t.TransactionStartTime,
	shift.ShiftName,
	ledger.LedgerName
    ,t.AddedBy
	having count(1) > 1$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_transactions_after_timing`(
	IN `varOrganizationId` bigint
	, IN `varFromDate` DATE 
	, IN `varToDate` DATE 
	
)
    NO SQL
select t.*,shift_timing.EndTime,shift.ShiftName,LoginName 
,(case when shift.ShiftNextDay = 'Yes' then 
	convert(date_add(concat(t.TransactionDate,' ' ,shift_timing.EndTime),INTERVAL 1 DAY),char)
else
	concat(t.TransactionDate,' ' ,shift_timing.EndTime)
end

) as AllowTime

from transaction_declare as t
inner join login on t.UpdatedBy = login.UserName and login.LoginType = 5
inner join shift_timing on shift_timing.ShiftId = t.ShiftId and shift_timing.RoleId = 5
inner join shift on t.ShiftId = shift.ShiftId
where t.TransactionDate between varFromDate and varToDate
and t.OrganizationId = varOrganizationId
and (case when shift.ShiftNextDay = 'Yes' then 
	t.UpdatedDate > date_add(concat(t.TransactionDate,' ' ,shift_timing.EndTime),INTERVAL 1 DAY)
else
	t.UpdatedDate > concat(t.TransactionDate,' ' ,shift_timing.EndTime)
end)

union all

select t.*,shift_timing.EndTime,shift.ShiftName,LoginName 
,(case when shift.ShiftNextDay = 'Yes' then 
	convert(date_add(concat(t.TransactionDate,' ' ,shift_timing.EndTime),INTERVAL 1 DAY),char)
else
	concat(t.TransactionDate,' ' ,shift_timing.EndTime)
end) as AllowTime
from transaction as t
inner join login on t.UpdatedBy = login.UserName and login.LoginType = 5
inner join shift_timing on shift_timing.ShiftId = t.ShiftId and shift_timing.RoleId = 5
inner join shift on t.ShiftId = shift.ShiftId
where t.TransactionDate between varFromDate and varToDate
and t.OrganizationId = varOrganizationId
and (case when shift.ShiftNextDay = 'Yes' then 
	t.UpdatedDate > date_add(concat(t.TransactionDate,' ' ,shift_timing.EndTime),INTERVAL 1 DAY)
else
	t.UpdatedDate > concat(t.TransactionDate,' ' ,shift_timing.EndTime)
end)$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_vapsi_from_to_report`(
		IN varOrganizationId bigint,
		IN varFromDate DATE,
        IN varToDate DATE,
        IN LedgerIds bigint,
        IN varCashAgentId bigint
)
begin
SELECT DISTINCT l.LedgerId,l.LedgerName,vapsi.VoucherId,vapsi.VapsiFromDate,vapsi.VapsiToDate,vapsi.BaseAmount,vapsi.VapsiPercent,vapsi.VapsiAmount
	,login.Mobile,ifnull(agent.CommanMasterName,'NA') as AgentName,
	vapsi.AddedBy,
	vapsi.AddedDate,
	vapsi.UpdatedBy,
	vapsi.UpdatedDate
	
	from (select 
		OrganizationId,
		LedgerId,
		ParentsLedgerId,
		VoucherId,
		VapsiFromDate,
		VapsiToDate,
		BaseAmount,
		VapsiPercent,
		VapsiAmount,
		VapsiOn ,
		AddedBy,
		AddedDate,
		UpdatedBy,
		UpdatedDate
		from vapsi 
		where vapsi.VapsiToDate between varFromDate and varToDate 
		#and vapsi.VoucherDate between varFromDate and varToDate 
		and vapsi.OrganizationId = varOrganizationId
			and vapsi.RecordStatus!='D' )  as vapsi
	join
		(select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.HPLedgerId,ledger.AgentLedgerId
		from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
		and ledger.OrganizationId = varOrganizationId
		and (ifnull(LedgerIds,0)=0 or ledger.LedgerId = LedgerIds) 
		and (ifnull(varCashAgentId,0) = 0 or ledger.AgentLedgerId in (select CommanMasterId from comman_master where LedgerId = varCashAgentId))
			) as l on vapsi.LedgerId = l.LedgerId 
	left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
	left join login on login.LedgerId = l.LedgerId
;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_voucher_duplicate`(
	IN varOrganizationId bigint
	, IN varFromDate DATE 
	, IN varToDate DATE 
	, IN varVoucherType int
)
    NO SQL
select 
		voucher_detail.VoucherId,
		voucher_detail.LedgerId,
		l.LedgerName,
		opposite.LedgerName as OppositeLedgerName,
		voucher_detail.OppositeLedgerId,
		voucher_detail.VoucherType,
		voucher_detail.VoucherDate,
		voucher_detail.Amount,
		voucher_detail.AmountType,
		DuplicateCount as DuplicateCount
		
	from 
		(SELECT 
		voucher_detail.VoucherId,
		voucher_detail.LedgerId,
		voucher_detail.OppositeLedgerId,
		voucher_detail.VoucherType,
		voucher_detail.VoucherDate,
		voucher_detail.Amount,
		voucher_detail.AmountType,
		count(1) as DuplicateCount
		
		FROM voucher_detail
			where voucher_detail.VoucherDate between varFromDate and varToDate
			and voucher_detail.RecordStatus != 'D'
			and (voucher_detail.VoucherType = varVoucherType or ifnull(varVoucherType,0) = 0)
			and voucher_detail.OrganizationId = varOrganizationId
			group by 
			voucher_detail.LedgerId,
			voucher_detail.OppositeLedgerId,
			voucher_detail.VoucherType,
			voucher_detail.VoucherDate,
			voucher_detail.Amount,
			voucher_detail.AmountType
			having count(1) > 1
		) as voucher_detail
	left join ledger l on voucher_detail.LedgerId = l.LedgerId
	left join ledger opposite on voucher_detail.OppositeLedgerId = opposite.LedgerId
	group by
		voucher_detail.VoucherId,
		voucher_detail.VoucherType,
		voucher_detail.VoucherDate,
		voucher_detail.Amount$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_voucher_hp_process`(
		IN varOrganizationId bigint,
		IN FromDate DATE,
        IN ToDate DATE,
        IN LedgerIds bigint,
		IN varGroupAgentId bigint
)
SELECT DISTINCT l.LedgerId,FromDate as FromDate,l.LedgerName,hissa.Hissa
	,login.Mobile,ifnull(agent.CommanMasterName,'NA') as AgentName
	,ifnull(l.HPLedgerId,0) as HPLedgerId 
	,ifnull(hpHissaTo.LedgerName,'Not Avilable') as HPToName
	,ifnull(SUM(TotalSale),0) as TotalSale,
	ifnull(SUM(DaraSale),0) as DaraSale,
	ifnull(SUM(BaharKaAkharSale),0) as BaharKaAkharSale,
	ifnull(SUM(AnderKaAkharSale),0) as AnderKaAkharSale,
	ifnull(SUM(TotalCommission),0) as TotalCommission,
	ifnull(SUM(DaraProfit),0) as DaraProfit,
	ifnull(SUM(AkharProfit),0) as AkharProfit,
	ifnull(SUM(TotalProfit),0) as TotalProfit,
	ifnull(SUM(DaraOpen),0) as DaraOpen,
	ifnull(SUM(BaharKaAkharOpen),0) as BaharKaAkharOpen,
	ifnull(SUM(AnderKaAkharOpen),0) as AnderKaAkharOpen,
	ifnull(sum(Payment), 0) Payment,
	ifnull(sum(ProfitAndLoss),0) ProfitAndLoss
	,(ifnull(sum(ProfitAndLoss) ,0) * (100 - ifnull(l.vapsi,0)) )/100 ProfitAndLossAfterVapsi
	
	,(case when ifnull(sum(ProfitAndLoss) ,0) > 0 then  
		(ifnull(sum(ProfitAndLoss) ,0) * (100 - ifnull(l.vapsi,0)) * ifnull(hissa.Hissa,0) )/10000 
	else
		(ifnull(sum(ProfitAndLoss) ,0) * ifnull(hissa.Hissa,0) )/100 
	end

) as HPAmountAfterVapsi
	,(ifnull(sum(ProfitAndLoss) ,0) * ifnull(hissa.Hissa,0) )/100 as HPAmount 
	,(ifnull(sum(Payment),0) * ifnull(hissa.Hissa,0) )/100 as HPAmountOnPayment 
	,ifnull((vdWorking.WorkingDays),0) WorkingDays

	from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.HPLedgerId,ledger.AgentLedgerId,ifnull(ledger.vapsi,0) vapsi
		from ledger where ledger.GroupId = 5 and ledger.RecordStatus!='D' 
		and ledger.OrganizationId = varOrganizationId
		and (ifnull(LedgerIds,0)=0 or ledger.LedgerId = LedgerIds) 
		and (ifnull(varGroupAgentId,0)=0 or ledger.AgentLedgerId = varGroupAgentId)
		) as l 
	join hissa on hissa.LedgerId = l.LedgerId and hissa.HissaLedgerId = 11	and hissa.RecordStatus != 'D' and ifnull(hissa.Hissa,0) != 0
	left join ledger as hpHissaTo on hpHissaTo.ledgerId = l.HPLedgerId
	
	left JOIN (select
		CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalSale,
		CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as DaraSale,
		CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as BaharKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as AnderKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TotalCommission,
		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as DaraProfit,
		CONVERT((SUM(IF(vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as AkharProfit,
		CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalProfit,
		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as DaraOpen,
		CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
		CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as AnderKaAkharOpen,
		sum(IF(vd.VoucherType = 1,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) Payment,
		vd.LedgerId,FromDate as FromDate,
		sum(IF(vd.ShiftId != 0,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) ProfitAndLoss
		from voucher_detail as vd

/*		left join (select hp_hissa.LedgerId,max(DATE_ADD(hp_hissa.HPToDate, INTERVAL 1 DAY)) as FromDate from hp_hissa where hp_hissa.RecordStatus != 'D'
group by LedgerId) as hp_hissa on hp_hissa.LedgerId = vd.LedgerId 
*/
where vd.VoucherDate between FromDate and ToDate
/*		and FromDate not in (select HPFromDate from hp_hissa where hp_hissa.RecordStatus != 'D' and hp_hissa.LedgerId = vd.LedgerId)
*/
		and vd.LedgerId not in (select hp_hissa.LedgerId from hp_hissa where hp_hissa.RecordStatus != 'D' and HPFromDate = FromDate )
		and (vd.RecordStatus!='D') 
		group by vd.LedgerId 
		) as vd on vd.LedgerId = l.LedgerId   
	left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
    left join ledger_limit on ledger_limit.LedgerId = l.LedgerId
	left join login on login.LedgerId = l.LedgerId
	left join (
		select LedgerId,count(WorkingDays) as WorkingDays
			from
			(
			select		
			vd.LedgerId,count(1) WorkingDays
			from voucher_detail as vd
			where vd.VoucherDate between FromDate and ToDate
			and (vd.RecordStatus!='D') 
			and vd.VoucherType in (22,23,24)
			group by vd.LedgerId,vd.VoucherDate
			) as vd 
			group by LedgerId
		) as vdWorking on vdWorking.LedgerId = l.LedgerId   
    
	GROUP BY l.LedgerId,l.LedgerName,hissa.Hissa,l.vapsi
	,vd.FromDate,l.AddedDate
	,ifnull(l.HPLedgerId,0)  
	,ifnull(hpHissaTo.LedgerName,'') 
	having ifnull(sum(ProfitAndLoss),0) != 0
    Order By l.LedgerName$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_voucher_is_exists`(
	IN varOrganizationId bigint
	, IN varLedgerId bigint
	, IN varOppositeLedgerId bigint
	, IN varAmount float
	, IN varAmountType varchar(10)
	, IN varVoucherDate DATE 
	, IN varVoucherType int
	, IN varFlag int
)
begin
	case varFlag 
	when  0 then
		select (case when 
			(SELECT 
				count(1) as NoofTrans
			FROM voucher_detail
				where voucher_detail.VoucherDate = varVoucherDate
				and voucher_detail.RecordStatus != 'D'
				and voucher_detail.VoucherType = varVoucherType 
				and voucher_detail.OrganizationId = varOrganizationId
				and voucher_detail.LedgerId = varLedgerId
				and voucher_detail.OppositeLedgerId = varOppositeLedgerId
				and voucher_detail.Amount = varAmount
				and voucher_detail.AmountType = varAmountType
			) > 0 then 
			1
		else
			0
		end ) as IsExists
		;
	else
		SELECT 
			voucher_detail.VoucherId
			,voucher_detail.AddedBy
			,voucher_detail.AddedDate
			,voucher_detail.UpdatedBy
			,voucher_detail.UpdatedDate
			
		FROM voucher_detail
			where voucher_detail.VoucherDate = varVoucherDate
			and voucher_detail.RecordStatus != 'D'
			and voucher_detail.VoucherType = varVoucherType 
			and voucher_detail.OrganizationId = varOrganizationId
			and voucher_detail.LedgerId = varLedgerId
			and voucher_detail.OppositeLedgerId = varOppositeLedgerId
			and voucher_detail.Amount = varAmount
			and voucher_detail.AmountType = varAmountType
		;
	end case;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_Voucher_Unverify_List`(
		IN varOrganizationId bigint
	)
begin
	select vd.ShiftId,shift.ShiftName,vd.VoucherDate,vd.UpdatedBy,vd.UpdatedDate
	from (
		select ShiftId,VoucherDate ,UpdatedBy,UpdatedDate
		from voucher_detail
		where OrganizationId = varOrganizationId
		and LedgerId > 100
		and ifnull(VerifyBy,'') = ''
		group by ShiftId,VoucherDate,UpdatedBy,convert(UpdatedDate,date)
	) as vd
	join shift on shift.ShiftId = vd.ShiftId
	order by vd.VoucherDate,shift.ShiftName
	;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_voucher_vapsi_process`(
		IN varOrganizationId bigint,
		IN FromDate DATE,
        IN ToDate DATE,
        IN LedgerIds bigint,
		IN varGroupAgentId bigint,
		IN varIsHPAdded int
)
begin
declare varVapsiWorkingDays INT default 0;

SELECT VapsiWorkingDays into varVapsiWorkingDays FROM organization
			where organization.OrganizationId = varOrganizationId
			;

SELECT DISTINCT l.LedgerId,FromDate as FromDate,l.LedgerName,l.vapsi
	,login.Mobile,ifnull(agent.CommanMasterName,'NA') as AgentName
	,ifnull(ledger_telegram.TelegramId,0) TelegramId 
	,ifnull(ledger_telegram.LedgerTelegramId,0) LedgerTelegramId
	,ifnull(ledger_telegram.AccessHash,'') AccessHash
	,ifnull(SUM(TotalSale),0) as TotalSale,
	ifnull(SUM(DaraSale),0) as DaraSale,
	ifnull(SUM(BaharKaAkharSale),0) as BaharKaAkharSale,
	ifnull(SUM(AnderKaAkharSale),0) as AnderKaAkharSale,
	ifnull(SUM(TotalCommission),0) as TotalCommission,
	ifnull(SUM(DaraProfit),0) as DaraProfit,
	ifnull(SUM(AkharProfit),0) as AkharProfit,
	ifnull(SUM(TotalProfit),0) as TotalProfit,
	ifnull(SUM(DaraOpen),0) as DaraOpen,
	ifnull(SUM(BaharKaAkharOpen),0) as BaharKaAkharOpen,
	ifnull(SUM(AnderKaAkharOpen),0) as AnderKaAkharOpen,
	ifnull(SUM(HPAmount),0) as HPAmount,
	ifnull(Hissa,0) as OtherHissa,
	(ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) * ifnull(Hissa,0)) /100 as OtherHissaAmount,
	-ifnull((case when sum(Payment) < 0 then sum(Payment) else 0 end), 0) Payment,
	ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) ProfitAndLoss,
	(ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) * (100 - ifnull(Hissa,0))) /100 
	FinalProfitAndLoss,
	((ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) * (100 - ifnull(Hissa,0))) /100  
		* ifnull(l.vapsi,0) )/100 as vapsiAmount
	,
	((ifnull((case when sum(ProfitAndLoss) > 0 then sum(ProfitAndLoss) else 0 end),0) )   
		* ifnull(l.vapsi,0) )/100 as vapsiAmountOnProfit
				
	,-(ifnull((case when sum(Payment) < 0 then sum(Payment) else 0 end),0) * ifnull(l.vapsi,0) )/100 as vapsiAmountOnPayment 
	,ifnull((vdWorking.WorkingDays),0) WorkingDays
	,(case when ifnull((select sum(Vapsi) from third_party_vapsi where third_party_vapsi.LedgerId = l.LedgerId and RecordStatus != 'D'),0) > 0 then 'Yes' else 'No' end) as IsTPV
	from (select ledger.LedgerId,ledger.LedgerName,ledger.AddedDate,ledger.vapsi,ledger.AgentLedgerId 
		from ledger 
		where ledger.GroupId in (3,4,5)
		and ifnull(ledger.Vapsi,0) != 0 and ledger.RecordStatus!='D' 
		and ifnull(ledger.ParentLedgerId,0) = 0 
		and ledger.OrganizationId = varOrganizationId
		and (ifnull(LedgerIds,0)=0 or ledger.LedgerId = LedgerIds) 
		and (ifnull(varGroupAgentId,0)=0 or ledger.AgentLedgerId = varGroupAgentId)
		and (ifnull(varIsHPAdded,0)=0 or ifnull(ledger.HPLedgerId,0) = 0)
		/*
		and (ifnull(varVapsiWorkingDays,0) = 0 
			or ledger.LedgerId in (
					(select transaction_declare.LedgerId
						from (
						select transaction_declare.LedgerId,transaction_declare.TransactionDate from transaction_declare 
						where transaction_declare.TransactionDate between FromDate and ToDate
						and  transaction_declare.RecordStatus!='D'
						and (ifnull(varOrganizationId,0) = 0 or transaction_declare.OrganizationId = varOrganizationId)
						group by transaction_declare.LedgerId,transaction_declare.TransactionDate
						) as transaction_declare
					group by transaction_declare.LedgerId
					having count(1) >= varVapsiWorkingDays
					)
				)
			) 
		*/
		) as l  
	left JOIN (select
		CONVERT((SUM(IF(vd.VoucherType = 22 or vd.VoucherType = 23 or vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalSale,
		CONVERT(SUM(IF(vd.VoucherType = 22, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as DaraSale,
		CONVERT(SUM(IF(vd.VoucherType = 23, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as BaharKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 24, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as AnderKaAkharSale,
		CONVERT(SUM(IF(vd.VoucherType = 25, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)), DECIMAL(16,2)) as TotalCommission,
		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as DaraProfit,
		CONVERT((SUM(IF(vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as AkharProfit,
		CONVERT((SUM(IF(vd.VoucherType = 26 or vd.VoucherType = 27 or vd.VoucherType = 28, IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0))), DECIMAL(16,2)) as TotalProfit,
		CONVERT((SUM(IF(vd.VoucherType = 26 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as DaraOpen,
		CONVERT((SUM(IF(vd.VoucherType = 27 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as BaharKaAkharOpen,
		CONVERT((SUM(IF(vd.VoucherType = 28 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as AnderKaAkharOpen,
		CONVERT((SUM(IF(vd.VoucherType = 5 , IF(vd.AmountType = 'Dr', -vd.OpenAmount,  vd.OpenAmount), 0))), DECIMAL(16,2)) as HPAmount,

		sum(IF(vd.VoucherType = 1,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) Payment,
		(case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
															else ledgerBaap.ParentLedgerId end) LedgerId,FromDate as FromDate,
		sum(IF(vd.ShiftId != 0 ,IF(vd.AmountType = 'Dr', vd.Amount, - vd.Amount), 0)) ProfitAndLoss
		
		from voucher_detail as vd
		inner join shift on vd.ShiftId = shift.ShiftId and ifnull(shift.IsCreateVapsi,1) = 1
		left join (select ledger.LedgerId,ledger.ParentLedgerId from ledger 
		WHERE (ledger.RecordStatus!='D') 
		and ledger.OrganizationId = varOrganizationId
		and ledger.GroupId in (3,4,5)
		)as ledger on vd.LedgerId = ledger.LedgerId
		left join (select ledger.LedgerId,ledger.ParentLedgerId from ledger 
		WHERE (ledger.RecordStatus!='D') 
		and ledger.OrganizationId = varOrganizationId
		and ledger.GroupId in (3,4,5)
		)as ledgerBaap on ledger.ParentLedgerId = ledgerBaap.LedgerId
/*		left join (select vapsi.LedgerId,max(DATE_ADD(vapsi.vapsiToDate, INTERVAL 1 DAY)) as FromDate from vapsi where vapsi.RecordStatus != 'D'
		group by LedgerId) as vapsi on vapsi.LedgerId = (case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 then ledger.ParentLedgerId
															else ledgerBaap.ParentLedgerId end)
*/
		where vd.VoucherDate between FromDate and ToDate
		and (vd.RecordStatus!='D') 
			and FromDate not in (select vapsi.VapsiFromDate from vapsi where vapsi.RecordStatus != 'D' and vapsi.LedgerId = (case when ledger.ParentLedgerId = 0 then vd.LedgerId 
																WHEN ledgerBaap.ParentLedgerId = 0 then ledger.ParentLedgerId
																else ledgerBaap.ParentLedgerId end))

		group by (case when ledger.ParentLedgerId = 0 then vd.LedgerId WHEN ledgerBaap.ParentLedgerId = 0 THEN ledger.ParentLedgerId
															else ledgerBaap.ParentLedgerId end)
		) as vd on vd.LedgerId = l.LedgerId   
	left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
    left join ledger_limit on ledger_limit.LedgerId = l.LedgerId
	left join login on login.LedgerId = l.LedgerId
	left join ledger_telegram on l.LedgerId = ledger_telegram.LedgerId and ledger_telegram.RecordStatus <> 'D'
	left join (select sum(Hissa) Hissa,LedgerId from hissa where LedgerId != HissaLedgerId and hissa.RecordStatus != 'D' group by LedgerId ) 
			as hissa  on hissa.LedgerId = l.LedgerId 
	left join (
		select LedgerId,count(WorkingDays) as WorkingDays
			from
			(
			select		
			vd.LedgerId,count(1) WorkingDays
			from voucher_detail as vd
			where vd.VoucherDate between FromDate and ToDate
			and (vd.RecordStatus!='D') 
			and vd.VoucherType in (22,23,24)
			group by vd.LedgerId,vd.VoucherDate
			) as vd 
			group by LedgerId
		) as vdWorking on vdWorking.LedgerId = l.LedgerId   
	where (ifnull(varVapsiWorkingDays,0) = 0 or vdWorking.WorkingDays >= ifnull(varVapsiWorkingDays,0))
		
	GROUP BY l.LedgerId,l.LedgerName,l.Vapsi
	,FromDate
	,login.Mobile,agent.CommanMasterName
	,ledger_telegram.TelegramId
	,ledger_telegram.LedgerTelegramId
	,ledger_telegram.AccessHash
	,vd.FromDate,l.AddedDate,ifnull(Hissa,0)
	having (ifnull(sum(ProfitAndLoss),0) > 0 or ifnull(sum(Payment), 0) < 0)
	Order By l.LedgerName;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `rpt_VoucherAudit`(
in varOrganizationId bigint(21)
, IN `varFromDate` DATE
, IN `varToDate` DATE
/*, in varLedgerId bigint(21)*/
, in varAuditStatus int
)
begin

	SELECT vd.VoucherDetailId,
    vd.OrganizationId,
    vd.VoucherId,
    vd.ShiftId,
    vd.LedgerId,
    vd.OppositeLedgerId,
    vd.FromLedgerId,
    vd.VoucherType,
    vd.VoucherDetailType,
    vd.VoucherDate,
    vd.Amount,
    vd.AmountType,
    vd.OpenAmount,
    vd.SelfHissa,
    vd.OtherHissa,
    vd.Flag1,
    vd.Remark,
    vd.MondayFinalFlag,
    vd.VoucherMode,
    vd.RecordStatus,
    vd.AddedBy,
    vd.AddedDate,
    vd.UpdatedBy,
    vd.UpdatedDate
	
	,ifnull(l.LedgerName,'') as LedgerName, ifnull(ol.LedgerName,'') as OppositLedgerName
    
	,voucher_audit.VoucherAuditId VoucherAuditId_voucher_audit ,
    voucher_audit.OrganizationId OrganizationId_voucher_audit,
    voucher_audit.VoucherId VoucherId_voucher_audit,
    voucher_audit.LedgerId LedgerId_voucher_audit,
    voucher_audit.OppositeLedgerId OppositeLedgerId_voucher_audit,
    voucher_audit.VoucherDate VoucherDate_voucher_audit,
    voucher_audit.VoucherType VoucherType_voucher_audit,
    voucher_audit.Amount Amount_voucher_audit,
    voucher_audit.AmountType AmountType_voucher_audit,
    voucher_audit.Remark Remark_voucher_audit,
    voucher_audit.AuditType AuditType_voucher_audit,
    voucher_audit.AuditStatus AuditStatus_voucher_audit,
    voucher_audit.RecordStatus RecordStatus_voucher_audit,
    voucher_audit.AddedBy AddedBy_voucher_audit,
    voucher_audit.AddedDate AddedDate_voucher_audit,
    voucher_audit.UpdatedBy UpdatedBy_voucher_audit,
    voucher_audit.UpdatedDate UpdatedDate_voucher_audit
	
    ,ifnull(l_audit.LedgerName,'') as LedgerName_voucher_audit, ifnull(ol_audit.LedgerName,'') as OppositLedgerName_voucher_audit

	FROM 
	(select * from voucher_audit 
	where (Date_Format(voucher_audit.AddedDate,'%Y-%m-%d') between varFromDate and varToDate or varAuditStatus = 1)
	and (voucher_audit.OrganizationId = varOrganizationId)
	and (voucher_audit.AuditStatus = varAuditStatus or varAuditStatus = 0)
	and voucher_audit.RecordStatus != 'D'
	and voucher_audit.VoucherId != 0
	) as voucher_audit
	
	JOIN voucher_detail vd ON voucher_audit.VoucherId = vd.VoucherId AND (case when voucher_audit.AuditType in (2,3) then true else vd.RecordStatus != 'D' end)
	left JOIN voucher_detail MinVoucher ON voucher_audit.VoucherId = MinVoucher.VoucherId 
											AND (case when voucher_audit.AuditType in (2,3) then true else MinVoucher.RecordStatus != 'D' end)
											and vd.VoucherDetailId > MinVoucher.VoucherDetailId

/*
    join (select min(VoucherDetailId)VoucherDetailId 
	,min(case when voucher_detail.RecordStatus != 'D' then 9223372036854000000 else VoucherDetailId end)VoucherDetailIdWithoutDeleted 
	from voucher_detail 
	group by voucher_detail.VoucherId) as MinVoucher on (case when voucher_audit.AuditType in (2,3) then 
											MinVoucher.VoucherDetailId = vd.VoucherDetailId 
										else 
											MinVoucher.VoucherDetailIdWithoutDeleted = vd.VoucherDetailId 
										end)	
*/
	JOIN ledger l ON vd.LedgerId = l.LedgerId
	JOIN ledger ol ON vd.OppositeLedgerId = ol.LedgerId
	
	left JOIN ledger l_audit ON voucher_audit.LedgerId = l_audit.LedgerId
	left JOIN ledger ol_audit ON voucher_audit.OppositeLedgerId = ol_audit.LedgerId
	where MinVoucher.VoucherId is null
	
	union all
	
	SELECT 0 VoucherDetailId,
    varOrganizationId OrganizationId,
    0 VoucherId,
    0 ShiftId,
    0 LedgerId,
    0 OppositeLedgerId,
    0 FromLedgerId,
    0 VoucherType,
    0 VoucherDetailType,
    varFromDate VoucherDate,
    0 Amount,
    'Dr' AmountType,
    0 OpenAmount,
    0 SelfHissa,
    0 OtherHissa,
    0 Flag1,
    '' Remark,
    0 MondayFinalFlag,
    0 VoucherMode,
    '' RecordStatus,
    '' AddedBy,
    varFromDate AddedDate,
    '' UpdatedBy,
    varFromDate UpdatedDate
	,'' as LedgerName, '' as OppositLedgerName
    
	,voucher_audit.VoucherAuditId VoucherAuditId_voucher_audit ,
    voucher_audit.OrganizationId OrganizationId_voucher_audit,
    voucher_audit.VoucherId VoucherId_voucher_audit,
    voucher_audit.LedgerId LedgerId_voucher_audit,
    voucher_audit.OppositeLedgerId OppositeLedgerId_voucher_audit,
    voucher_audit.VoucherDate VoucherDate_voucher_audit,
    voucher_audit.VoucherType VoucherType_voucher_audit,
    voucher_audit.Amount Amount_voucher_audit,
    voucher_audit.AmountType AmountType_voucher_audit,
    voucher_audit.Remark Remark_voucher_audit,
    voucher_audit.AuditType AuditType_voucher_audit,
    voucher_audit.AuditStatus AuditStatus_voucher_audit,
    voucher_audit.RecordStatus RecordStatus_voucher_audit,
    voucher_audit.AddedBy AddedBy_voucher_audit,
    voucher_audit.AddedDate AddedDate_voucher_audit,
    voucher_audit.UpdatedBy UpdatedBy_voucher_audit,
    voucher_audit.UpdatedDate UpdatedDate_voucher_audit
	
    ,ifnull(l_audit.LedgerName,'') as LedgerName_voucher_audit, ifnull(ol_audit.LedgerName,'') as OppositLedgerName_voucher_audit

	FROM 
	(select * from voucher_audit 
	where (Date_Format(voucher_audit.AddedDate,'%Y-%m-%d') between varFromDate and varToDate or varAuditStatus = 1)
	and (voucher_audit.OrganizationId = varOrganizationId)
	and (voucher_audit.AuditStatus = varAuditStatus or varAuditStatus = 0)
	and voucher_audit.RecordStatus != 'D'
	and voucher_audit.VoucherId = 0
	) as voucher_audit
	
	
	left JOIN ledger l_audit ON voucher_audit.LedgerId = l_audit.LedgerId
	left JOIN ledger ol_audit ON voucher_audit.OppositeLedgerId = ol_audit.LedgerId


	order by VoucherAuditId_voucher_audit 
	
	
	/*
	and (voucher_detail.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0 )
	*/
	
	;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `Shift_all_of_organization`(IN varOrganizationId int(20), IN varShiftName varchar(50))
BEGIN
	SELECT s.ShiftId, s.ShiftName, s.ShiftFor, s.ShiftNextDay, s.UpdatedBy,
    s.ShiftDate as ShiftDateDB, s.IsActive,
    s.DaraRate,s.DaraCommission,s.AkharRate,s.AkharCommission,s.Tax,
	date_format(s.ShiftDate,'%d-%m-%Y') as ShiftDate, 
	date_format(s.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
	date_format(s.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
	,s.IsTransToCompany
	,s.CompanyApiUrl 
	,s.CompanyUserName 
	,s.CompanyPassword 
	,s.CompanyShiftId
	,s.ApiTimeRebateForTransaction
	,s.MainJantriTime
	,s.IsTransactionCapping
	,s.RoundOffOnCollection
	,s.IsLagaiTransactionExist
	,s.IsCreateVapsi
	,s.IsApplyShiftConfigOnTransaction
    ,s.ResultWebShiftId
	
	FROM shift s
	where s.OrganizationId = varOrganizationId
	and (varShiftName is null or s.ShiftName LIKE CONCAT('%', varShiftName , '%'))
	and s.RecordStatus != 'D'
    order by s.ShiftOrder, s.AddedDate Asc;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `Shift_timing_all_of_organization`(IN varOrganizationId int(20), IN varShiftId int(20))
BEGIN
	SELECT s.*, r.RoleName
	FROM shift_timing s
	join role r on s.RoleId = r.RoleId
	where s.OrganizationId = varOrganizationId
	and s.ShiftId = varShiftId
	and s.RecordStatus != 'D'
    group by s.RoleId
    order by s.RoleId asc;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `staff_all_of_organization`(IN varOrganizationId int(20)
, IN varLedgerName varchar(50)
, IN varLedgerId int(20)
, IN varUserName varchar(100)
, IN varRoleId int(20)
, IN varRoleType varchar(20)
)
begin
# RoleId = 2 super admin, 3 distributer,4 ressaler ,5 panter
case varRoleId 
	when 3 then
			SELECT 

			lg.LoginId,
			lg.OrganizationId,
			lg.LedgerId,
			lg.LoginName,
			lg.UserName,
			lg.LoginType,
			lg.Mobile,
			lg.Address,
			lg.StaffWorkMode,
			lg.AccountStatus,
			lg.RecordStatus,
			lg.AddedBy,
			lg.AddedDate,
			lg.UpdatedBy,
			lg.UpdatedDate,

			date_format(lg.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
			date_format(lg.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate, 
			r.RoleName, l.GroupId
			,l.AgentLedgerId,Agent.LedgerName as AgentLedgerName 
			
			FROM login lg
			join role r on lg.LoginType = r.RoleId
			join ledger l on lg.LedgerId = l.LedgerId and l.GroupId = 7 and l.IsHide = '0'
			left join ledger as Agent on Agent.LedgerId = l.AgentLedgerId
		
			where l.OrganizationId = varOrganizationId
			and lg.RecordStatus != 'D'
			and (varLedgerName is null or l.LedgerName LIKE CONCAT('%', varLedgerName , '%'))
			and (l.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
			and (varRoleType = 'ALL' 
				or l.UpdatedBy  = varUserName
				)
			group by lg.LoginId
			order by lg.AddedDate asc;
	when 4 then
		SELECT lg.LoginId,
			lg.OrganizationId,
			lg.LedgerId,
			lg.LoginName,
			lg.UserName,
			lg.LoginType,
			lg.Mobile,
			lg.Address,
			lg.StaffWorkMode,
			lg.AccountStatus,
			lg.RecordStatus,
			lg.AddedBy,
			lg.AddedDate,
			lg.UpdatedBy,
			lg.UpdatedDate,
			date_format(lg.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
			date_format(lg.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate, 
			r.RoleName, l.GroupId
			,l.AgentLedgerId,Agent.LedgerName as AgentLedgerName 
			
			FROM login lg
			join role r on lg.LoginType = r.RoleId
			join ledger l on lg.LedgerId = l.LedgerId and l.GroupId = 7 and l.IsHide = '0'
			left join ledger as Agent on Agent.LedgerId = l.AgentLedgerId
			
			where l.OrganizationId = varOrganizationId
			and lg.RecordStatus != 'D'
			and (varLedgerName is null or l.LedgerName LIKE CONCAT('%', varLedgerName , '%'))
			and (l.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId)
			and (varRoleType = 'ALL' 
				or l.UpdatedBy  = varUserName
				)
			group by lg.LoginId
			order by lg.AddedDate asc;

	when 5 then
		SELECT lg.LoginId,
			lg.OrganizationId,
			lg.LedgerId,
			lg.LoginName,
			lg.UserName,
			lg.LoginType,
			lg.Mobile,
			lg.Address,
			lg.StaffWorkMode,
			lg.AccountStatus,
			lg.RecordStatus,
			lg.AddedBy,
			lg.AddedDate,
			lg.UpdatedBy,
			lg.UpdatedDate,
			date_format(lg.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
			date_format(lg.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate, 
			r.RoleName, l.GroupId
			,l.AgentLedgerId,Agent.LedgerName as AgentLedgerName 
			
			FROM login lg
			join role r on lg.LoginType = r.RoleId
			join ledger l on lg.LedgerId = l.LedgerId and l.GroupId = 7 and l.IsHide = '0'
			left join ledger as Agent on Agent.LedgerId = l.AgentLedgerId

			where l.OrganizationId = varOrganizationId
			and lg.RecordStatus != 'D'
			and (varLedgerName is null or l.LedgerName LIKE CONCAT('%', varLedgerName , '%'))
			and (l.LedgerId = varLedgerId )
			and (varRoleType = 'ALL' 
				or l.UpdatedBy  = varUserName
				)
			group by lg.LoginId
			order by lg.AddedDate asc;

	else
		SELECT lg.LoginId,
			lg.OrganizationId,
			lg.LedgerId,
			lg.LoginName,
			lg.UserName,
			lg.LoginType,
			lg.Mobile,
			lg.Address,
			lg.StaffWorkMode,
			lg.AccountStatus,
			lg.RecordStatus,
			lg.AddedBy,
			lg.AddedDate,
			lg.UpdatedBy,
			lg.UpdatedDate,
			date_format(lg.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
			date_format(lg.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate, 
			r.RoleName, l.GroupId
			,l.AgentLedgerId,Agent.LedgerName as AgentLedgerName 
			
			FROM login lg
			join role r on lg.LoginType = r.RoleId
			join ledger l on lg.LedgerId = l.LedgerId and l.GroupId = 7 and l.IsHide = '0'
			left join ledger as Agent on Agent.LedgerId = l.AgentLedgerId
			
			where l.OrganizationId = varOrganizationId
			and lg.RecordStatus != 'D'
			and (varLedgerName is null or l.LedgerName LIKE CONCAT('%', varLedgerName , '%'))
			and (varRoleType = 'ALL' 
				or l.UpdatedBy  = varUserName
				)
			group by lg.LoginId
			order by lg.AddedDate desc;

	end case;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `staff_transaction_permission`(IN varOrganizationId int(20)
, IN varLedgerName varchar(50)
, IN varLedgerId int(20)
, IN varRoleId int(20)
, IN varLoginId int(20)
)
begin
		SELECT lg.LoginId,
			lg.OrganizationId,
			lg.LedgerId,
			lg.LoginName,
			lg.UserName,
			lg.LoginType,
			lg.AccountStatus,
			r.RoleName,
			l.GroupId,
			ifnull(role_permission_transaction.ShiftCount,0) as ShiftCount
			,(case when CURRENT_TIMESTAMP() >= ifnull(role_permission_transaction.ExpiryDateTime,CURRENT_TIMESTAMP()) then 1 else 0 end) as IsExpiry
			

			,
				convert(substr(lg.UserName
				,LEAST(
				if(Locate('0',lg.UserName)=0,100,Locate('0',lg.UserName)),
				if(Locate('1',lg.UserName)=0,100,Locate('1',lg.UserName)),
				if(Locate('2',lg.UserName)=0,100,Locate('2',lg.UserName)),
				if(Locate('3',lg.UserName)=0,100,Locate('3',lg.UserName)),
				if(Locate('4',lg.UserName)=0,100,Locate('4',lg.UserName)),
				if(Locate('5',lg.UserName)=0,100,Locate('5',lg.UserName)),
				if(Locate('6',lg.UserName)=0,100,Locate('6',lg.UserName)),
				if(Locate('7',lg.UserName)=0,100,Locate('7',lg.UserName)),
				if(Locate('8',lg.UserName)=0,100,Locate('8',lg.UserName)),
				if(Locate('9',lg.UserName)=0,100,Locate('9',lg.UserName))
				)
				),signed) as sub2
			,
				substr(lg.UserName,1
				,LEAST(
				if(Locate('0',lg.UserName)=0,100,Locate('0',lg.UserName)),
				if(Locate('1',lg.UserName)=0,100,Locate('1',lg.UserName)),
				if(Locate('2',lg.UserName)=0,100,Locate('2',lg.UserName)),
				if(Locate('3',lg.UserName)=0,100,Locate('3',lg.UserName)),
				if(Locate('4',lg.UserName)=0,100,Locate('4',lg.UserName)),
				if(Locate('5',lg.UserName)=0,100,Locate('5',lg.UserName)),
				if(Locate('6',lg.UserName)=0,100,Locate('6',lg.UserName)),
				if(Locate('7',lg.UserName)=0,100,Locate('7',lg.UserName)),
				if(Locate('8',lg.UserName)=0,100,Locate('8',lg.UserName)),
				if(Locate('9',lg.UserName)=0,100,Locate('9',lg.UserName))
				)-1
				) as sub1

			FROM login lg
			join role r on lg.LoginType = r.RoleId and r.RecordStatus != 'D' and r.OrganizationId = varOrganizationId
			join ledger l on lg.LedgerId = l.LedgerId and l.GroupId = 7 and l.IsHide = '0'
			left join (select count(1) as ShiftCount,role_permission_transaction.LoginId,max(role_permission_transaction.ExpiryDateTime) ExpiryDateTime  
						from role_permission_transaction 
						where role_permission_transaction.RecordStatus != 'D' and ifnull(role_permission_transaction.IsPageAllow,0) = 1
						group by role_permission_transaction.LoginId 
						) as role_permission_transaction on lg.LoginId = role_permission_transaction.LoginId  
			where l.OrganizationId = varOrganizationId
			and lg.RecordStatus != 'D'
			and ((varLedgerName is null or upper(l.LedgerName) LIKE CONCAT(upper(varLedgerName) , '%'))
			or (varLedgerName is null or upper(lg.UserName) LIKE CONCAT(upper(varLedgerName) , '%')))
			and (lg.LoginType = varRoleId or ifnull(varRoleId,0) = 0 )
			and (lg.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0 )
			and (lg.LoginId = varLoginId or ifnull(varLoginId,0) = 0 )
			#order by lg.LoginId asc
			order by sub1,sub2 asc
		;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `sys_default_ledger_asign`(IN varOrganization int(20))
BEGIN
	INSERT INTO `ledger`(`OrganizationId`,`ParentLedgerId`,`LedgerName`,`GroupId`,`AgentLedgerId`,`LimitType`,`DaraRate`,`DaraCommission`,`AkharRate`,`AkharCommission`,`Vapsi`,`TPVapsi`,`TPCommission`,`IsHissa`,`IsDibba`,`DibbaAmount`,`RefLedgerId`,`IsReport`,`TransactionMode`,`AccountStatus`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	VALUES(varOrganization,0,UPPER('Mandi Sale A/c'),11,0,'No','0','0','0','0','0','No','No','No','No',0,0,'0',0,1,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
	INSERT INTO `ledger`(`OrganizationId`,`ParentLedgerId`,`LedgerName`,`GroupId`,`AgentLedgerId`,`LimitType`,`DaraRate`,`DaraCommission`,`AkharRate`,`AkharCommission`,`Vapsi`,`TPVapsi`,`TPCommission`,`IsHissa`,`IsDibba`,`DibbaAmount`,`RefLedgerId`,`IsReport`,`TransactionMode`,`AccountStatus`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	VALUES(varOrganization,0,UPPER('Mandi Purchase A/c'),12,0,'No','0','0','0','0','0','No','No','No','No',0,0,'0',0,1,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
	INSERT INTO `ledger`(`OrganizationId`,`ParentLedgerId`,`LedgerName`,`GroupId`,`AgentLedgerId`,`LimitType`,`DaraRate`,`DaraCommission`,`AkharRate`,`AkharCommission`,`Vapsi`,`TPVapsi`,`TPCommission`,`IsHissa`,`IsDibba`,`DibbaAmount`,`RefLedgerId`,`IsReport`,`TransactionMode`,`AccountStatus`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	VALUES(varOrganization,0,UPPER('Mandi P&L A/c'),10,0,'No','0','0','0','0','0','No','No','No','No',0,0,'0',0,1,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
	INSERT INTO `ledger`(`OrganizationId`,`ParentLedgerId`,`LedgerName`,`GroupId`,`AgentLedgerId`,`LimitType`,`DaraRate`,`DaraCommission`,`AkharRate`,`AkharCommission`,`Vapsi`,`TPVapsi`,`TPCommission`,`IsHissa`,`IsDibba`,`DibbaAmount`,`RefLedgerId`,`IsReport`,`TransactionMode`,`AccountStatus`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	VALUES(varOrganization,0,UPPER('Mandi Commission A/c'),8,0,'No','0','0','0','0','0','No','No','No','No',0,0,'0',0,1,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
	INSERT INTO `ledger`(`OrganizationId`,`ParentLedgerId`,`LedgerName`,`GroupId`,`AgentLedgerId`,`LimitType`,`DaraRate`,`DaraCommission`,`AkharRate`,`AkharCommission`,`Vapsi`,`TPVapsi`,`TPCommission`,`IsHissa`,`IsDibba`,`DibbaAmount`,`RefLedgerId`,`IsReport`,`TransactionMode`,`AccountStatus`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	VALUES(varOrganization,0,UPPER('Vapsi A/c'),9,0,'No','0','0','0','0','0','No','No','No','No',0,0,'0',0,1,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
	INSERT INTO `ledger`(`OrganizationId`,`ParentLedgerId`,`LedgerName`,`GroupId`,`AgentLedgerId`,`LimitType`,`DaraRate`,`DaraCommission`,`AkharRate`,`AkharCommission`,`Vapsi`,`TPVapsi`,`TPCommission`,`IsHissa`,`IsDibba`,`DibbaAmount`,`RefLedgerId`,`IsReport`,`TransactionMode`,`AccountStatus`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	VALUES(varOrganization,0,UPPER('Limit A/c'),13,0,'No','0','0','0','0','0','No','No','No','No',0,0,'0',0,1,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
	INSERT INTO `ledger`(`OrganizationId`,`ParentLedgerId`,`LedgerName`,`GroupId`,`AgentLedgerId`,`LimitType`,`DaraRate`,`DaraCommission`,`AkharRate`,`AkharCommission`,`Vapsi`,`TPVapsi`,`TPCommission`,`IsHissa`,`IsDibba`,`DibbaAmount`,`RefLedgerId`,`IsReport`,`TransactionMode`,`AccountStatus`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	VALUES(varOrganization,0,UPPER('Kist A/c'),13,0,'No','0','0','0','0','0','No','No','No','No',0,0,'0',0,1,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
	INSERT INTO `ledger`(`OrganizationId`,`ParentLedgerId`,`LedgerName`,`GroupId`,`AgentLedgerId`,`LimitType`,`DaraRate`,`DaraCommission`,`AkharRate`,`AkharCommission`,`Vapsi`,`TPVapsi`,`TPCommission`,`IsHissa`,`IsDibba`,`DibbaAmount`,`RefLedgerId`,`IsReport`,`TransactionMode`,`AccountStatus`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	VALUES(varOrganization,0,UPPER('Suspense A/c'),9,0,'No','0','0','0','0','0','No','No','No','No',0,0,'0',0,1,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
	INSERT INTO `ledger`(`OrganizationId`,`ParentLedgerId`,`LedgerName`,`GroupId`,`AgentLedgerId`,`LimitType`,`DaraRate`,`DaraCommission`,`AkharRate`,`AkharCommission`,`Vapsi`,`TPVapsi`,`TPCommission`,`IsHissa`,`IsDibba`,`DibbaAmount`,`RefLedgerId`,`IsReport`,`TransactionMode`,`AccountStatus`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	VALUES(varOrganization,0,UPPER('Expense A/c'),8,0,'No','0','0','0','0','0','No','No','No','No',0,0,'0',0,1,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `sys_default_role_asign`(IN varOrganization int(20))
BEGIN
	INSERT INTO `role`(`RoleId`,`OrganizationId`,`RoleName`,`IsTransaction`,`IsAllow`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	SELECT `RoleId`,varOrganization,`RoleName`,`IsTransaction`,`IsAllow`,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP() FROM `sys_role`;
	
	update role set IsAppLogin = 1
	,IsWebLogin = 1
	,IsDashboardReDeclare = 1
	where RoleId in (1,2)
    and OrganizationId = varOrganization
	;
	
	update role set IsWebLogin = 1
	where RoleId in (7,11)
    and OrganizationId = varOrganization
	;
	
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `sys_default_role_permission_asign`(IN varOrganization int(20))
BEGIN
	INSERT INTO `role_permission`(`OrganizationId`,`RoleId`,`MenuId`,`Title`,`Page`,`IsPageAllow`,`IsOption`,`Add`,`Edit`,`Delete`,`Export`,`ViewType`,`RecordStatus`,`AddedBy`,`AddedDate`,`UpdatedBy`,`UpdatedDate`)
	SELECT varOrganization,`RoleId`,`MenuId`,`Title`,`Page`,`IsPageAllow`,`IsOption`,`Add`,`Edit`,`Delete`,`Export`,`ViewType`,'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP() FROM `sys_role_permission`;
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `sys_default_shift_asign`(IN varOrganization int(20))
BEGIN
	INSERT INTO `shift` ( `OrganizationId`, `ShiftName`, `ShiftDate`, `ShiftNextDay`, `ShiftFor`, `IsActive`, `RecordStatus`, `AddedBy`, `AddedDate`, `UpdatedBy`, `UpdatedDate`) 
	VALUES (varOrganization, 'GALI', CURDATE(), 'No', 'BOTH', '1', 'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
    
	INSERT INTO `shift` (`OrganizationId`, `ShiftName`, `ShiftDate`, `ShiftNextDay`, `ShiftFor`, `IsActive`, `RecordStatus`, `AddedBy`, `AddedDate`, `UpdatedBy`, `UpdatedDate`) 
	VALUES (varOrganization, 'DESHAWER', CURDATE(), 'Yes', 'BOTH', '1', 'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
    
	INSERT INTO `shift` (`OrganizationId`, `ShiftName`, `ShiftDate`, `ShiftNextDay`, `ShiftFor`, `IsActive`, `RecordStatus`, `AddedBy`, `AddedDate`, `UpdatedBy`, `UpdatedDate`) 
	VALUES (varOrganization, 'GHAZIABAD', CURDATE(), 'No', 'BOTH', '1', 'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
    
	INSERT INTO `shift` (`OrganizationId`, `ShiftName`, `ShiftDate`, `ShiftNextDay`, `ShiftFor`, `IsActive`, `RecordStatus`, `AddedBy`, `AddedDate`, `UpdatedBy`, `UpdatedDate`) 
	VALUES (varOrganization, 'PUNJAB DAY', CURDATE(), 'No', 'BOTH', '1', 'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
    
	INSERT INTO `shift` (`OrganizationId`, `ShiftName`, `ShiftDate`, `ShiftNextDay`, `ShiftFor`, `IsActive`, `RecordStatus`, `AddedBy`, `AddedDate`, `UpdatedBy`, `UpdatedDate`) 
	VALUES (varOrganization, 'DELHI NOON', CURDATE(), 'No', 'BOTH', '1', 'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
    
	INSERT INTO `shift` (`OrganizationId`, `ShiftName`, `ShiftDate`, `ShiftNextDay`, `ShiftFor`, `IsActive`, `RecordStatus`, `AddedBy`, `AddedDate`, `UpdatedBy`, `UpdatedDate`) 
	VALUES (varOrganization, 'NEW FARIDABAD', CURDATE(), 'No', 'BOTH', '1', 'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
    
    INSERT INTO `shift` (`OrganizationId`, `ShiftName`, `ShiftDate`, `ShiftNextDay`, `ShiftFor`, `IsActive`, `RecordStatus`, `AddedBy`, `AddedDate`, `UpdatedBy`, `UpdatedDate`) 
	VALUES (varOrganization, 'DELHI TIME', CURDATE(), 'No', 'BOTH', '1', 'S','SYSTEM',CURRENT_TIMESTAMP(),'SYSTEM',CURRENT_TIMESTAMP());
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `sys_hpLedgerId_update`(
in varOrganizationId bigint(21)
)
begin

declare VoucherId BIGINT default 0;


declare varLedgerId int default 0;
declare varHPLedgerId int default 0;

DECLARE finished INTEGER DEFAULT 0;
DEClARE curLedger 
		CURSOR FOR 
			select ledger.LedgerId,hissa.HissaLedgerId
			from (
			select ledger.LedgerName,ledger.LedgerId from ledger 
			where ledger.LedgerId in (select hissa.LedgerId from hissa where hissa.RecordStatus != 'D')
			and ledger.LedgerId not in (select hissa.LedgerId from hissa where hissa.RecordStatus != 'D' and hissa.HissaLedgerId = 11)
			and ledger.OrganizationId = varOrganizationId and ledger.GroupId = 5
			and ledger.RecordStatus != 'D') as ledger
			join hissa on hissa.LedgerId = ledger.LedgerId and hissa.RecordStatus != 'D' 
			left join ledger as ledgerHissa on hissa.HissaLedgerId = ledgerHissa.LedgerId
			where ledger.LedgerId != hissa.HissaLedgerId
			group by ledger.LedgerName,ledger.LedgerId
			;


DECLARE CONTINUE HANDLER 
FOR NOT FOUND SET finished = 1;
			

OPEN curLedger;
		
getLedger: LOOP
		FETCH curLedger INTO varLedgerId,varHPLedgerId;
		IF finished = 1 THEN 
			LEAVE getLedger;
		END IF;
		
		update ledger set HPLedgerId = varHPLedgerId
		where LedgerId = varLedgerId;
		
		update hissa set HissaLedgerId = 11
		where LedgerId = varLedgerId;
		
	END LOOP getLedger;
	CLOSE curLedger;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `sys_OrganizationDeleteData`(
	IN varOrganizationId bigint
	)
begin

	delete from transaction
	where transaction.OrganizationId = varOrganizationId
	;

	delete from transaction_detail
	where transaction_detail.OrganizationId = varOrganizationId
	;

	delete from transaction_declare
	where transaction_declare.OrganizationId = varOrganizationId
	;

	delete from transaction_detail_declare
	where transaction_detail_declare.OrganizationId = varOrganizationId
	;

	delete from transaction_narration
	where transaction_narration.OrganizationId = varOrganizationId
	;

	delete from transaction_narration_declare
	where transaction_narration_declare.OrganizationId = varOrganizationId
	;

	delete from voucher
	where voucher.OrganizationId = varOrganizationId
	;

	delete from voucher_detail
	where voucher_detail.OrganizationId = varOrganizationId
	;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_agent_agentgroup_list`(
	IN `varOrganizationId` bigint(21)
	, IN `varTransactionDate` DATE
	, IN `varShiftId` int(20)
	, IN `varAgentId` bigint(8)
	, IN `varListType` int # 0 For Agents 1 for Agent Groups
	)
begin
	if ifnull(varListType,0) = 0 then
		select 
		main_agent.LedgerName as ListName
		,agent.LedgerId as ListLedgerId
		,varListType as ListType
		,sum(TotalSale) as TotalSale
		,'' as AgentName
		from ledger 
		join (
			select t.LedgerId,sum(TotalAmount) as TotalSale
				from transaction t 
				WHERE t.OrganizationId = varOrganizationId
				and t.TransactionDate = varTransactionDate
				and t.TransactionMode = 1 
				and t.ShiftId = varShiftId
			group by t.LedgerId
			union
			select t.LedgerId,sum(TotalAmount) as TotalSale
				from transaction_declare t 
				WHERE t.OrganizationId = varOrganizationId
				and t.TransactionDate = varTransactionDate
				and t.TransactionMode = 1 
				and t.ShiftId = varShiftId
			group by t.LedgerId
		) as t on ledger.LedgerId = t.LedgerId
		join comman_master as agent on agent.CommanMasterId = ledger.AgentLedgerId and agent.CommanMasterType = 1
		join ledger as main_agent on main_agent.LedgerId = agent.LedgerId
		
		where (ifnull(varAgentId,0) = 0 or ifnull(agent.LedgerId,0) = ifnull(varAgentId,0))
		#and ifnull(ledger.ParentLedgerId ,9) = 0 
		group by main_agent.LedgerName 
					,agent.LedgerId		
		order by main_agent.LedgerName
		;
	else
		select 
		ifnull(agent.CommanMasterName,'') as ListName
		,ifnull(agent.CommanMasterId,'') as ListLedgerId
		,varListType as ListType
		,sum(TotalSale) as TotalSale
		,main_agent.LedgerName as AgentName
			
		from ledger 
		join (
			select t.LedgerId,sum(TotalAmount) as TotalSale
				from transaction t 
				WHERE t.OrganizationId = varOrganizationId
				and t.TransactionDate = varTransactionDate
				and t.TransactionMode = 1 
				and t.ShiftId = varShiftId
			group by t.LedgerId
			union
			select t.LedgerId,sum(TotalAmount) as TotalSale
				from transaction_declare t 
				WHERE t.OrganizationId = varOrganizationId
				and t.TransactionDate = varTransactionDate
				and t.TransactionMode = 1 
				and t.ShiftId = varShiftId
			group by t.LedgerId
		) as t on ledger.LedgerId = t.LedgerId
		join comman_master as agent on agent.CommanMasterId = ledger.AgentLedgerId and agent.CommanMasterType = 1
		left join ledger as main_agent on main_agent.LedgerId = agent.LedgerId
		
		where (ifnull(varAgentId,0) = 0 or ifnull(agent.LedgerId,0) = ifnull(varAgentId,0))
		#and ifnull(ledger.ParentLedgerId ,9) = 0 
		group by agent.CommanMasterName,agent.CommanMasterId,main_agent.LedgerName
		order by agent.CommanMasterName
		;
	end if
	;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_all_of_organization`(IN varOrganizationId int(20),
 IN varShiftId int(20), IN varShiftDate DATE,
 IN varLedgerId int(20),
 IN varUserName varchar(100),
 IN varRoleId int(20),
 IN varRoleType varchar(20),
 IN varLedgerName varchar(50),
 IN varIsDeleted int(20)
 )
begin
# RoleId = 2 super admin, 3 distributer,4 ressaler ,5 panter
# RoleId = 11 dataentry oprater

case varRoleId 
	when 3 then

		SELECT t.TransactionId, t.OrganizationId, t.LedgerId
		,t.LedgerName LedgerName
		,t.ShiftId,t.TotalAmount
		, t.UpdatedBy, t.TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
		t.TransactionDate, 
		t.AddedDate, 
		t.UpdatedDate
		,t.AddedBy
		,t.IsUpdated
		,t.DeclareNumber
		,t.UpdateDiff
		,t.IsDada
		,t.IsBAkar
		,t.IsAAkar
		,t.AddedDayTime
		,t.UpdatedDayTime
		,t.RecordStatus
		,t.OrderAddeddate
		,t.ClientRemarks
		
		,ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
		ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
		ifnull(transaction_audit.LastStatus,0) LastStatus,
		ifnull(transaction_audit.Remark,'') Remark
		from
			(
			SELECT convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId
				,(case when varRoleId = 11 then ifnull(login.UserName,'') else l.LedgerName end) LedgerName
				, t.ShiftId, t.TotalAmount, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
				date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
				date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
				,t.AddedBy
				,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
				,'' DeclareNumber
				,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
				,0 as IsDada
				,0 as IsBAkar
				,0 as IsAAkar
				,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
				,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
				,t.RecordStatus as RecordStatus
				,t.AddedDate as OrderAddeddate
				,t.ClientRemarks
				
				FROM transaction t
				join ledger l on t.LedgerId = l.LedgerId
				join login on login.LedgerId = l.LedgerId
				where t.OrganizationId = varOrganizationId
				and t.ShiftId = varShiftId
				and t.TransactionDate = varShiftDate
				and (case when varIsDeleted = 1 then t.RecordStatus = 'D' else t.RecordStatus != 'D' end)
				and (t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
				and (varRoleType = 'ALL' 
					or t.UpdatedBy  = varUserName
					)
				and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
			) as t
		left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
		order by t.OrderAddeddate desc;
	when 4 then
		SELECT t.TransactionId, t.OrganizationId, t.LedgerId
		,t.LedgerName LedgerName
		,t.ShiftId,t.TotalAmount
		, t.UpdatedBy, t.TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
		t.TransactionDate, 
		t.AddedDate, 
		t.UpdatedDate
		,t.AddedBy
		,t.IsUpdated
		,t.DeclareNumber
		,t.UpdateDiff
		,t.IsDada
		,t.IsBAkar
		,t.IsAAkar
		,t.AddedDayTime
		,t.UpdatedDayTime
		,t.RecordStatus
		,t.OrderAddeddate
		,t.ClientRemarks
		,ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
		ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
		ifnull(transaction_audit.LastStatus,0) LastStatus,
		ifnull(transaction_audit.Remark,'') Remark
		from
			(
			SELECT convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId
				,l.LedgerName 
				, t.ShiftId, t.TotalAmount, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
				date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
				date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
				,t.AddedBy
				,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
				,'' DeclareNumber
				,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
				,0 as IsDada
				,0 as IsBAkar
				,0 as IsAAkar
				,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
				,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
				,t.RecordStatus as RecordStatus
				,t.AddedDate as OrderAddeddate
				,t.ClientRemarks
				
				FROM transaction t
				join ledger l on t.LedgerId = l.LedgerId
				where t.OrganizationId = varOrganizationId
				and t.ShiftId = varShiftId
				and t.TransactionDate = varShiftDate
				and (case when varIsDeleted = 1 then t.RecordStatus = 'D' else t.RecordStatus != 'D' end)
				and (t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId)
				and (varRoleType = 'ALL' 
					or t.UpdatedBy  = varUserName
					)
				and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
			) as t
		left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
		order by t.OrderAddeddate desc;
	when 5 then
		SELECT t.TransactionId, t.OrganizationId, t.LedgerId
		,t.LedgerName LedgerName
		,t.ShiftId,t.TotalAmount
		, t.UpdatedBy, t.TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
		t.TransactionDate, 
		t.AddedDate, 
		t.UpdatedDate
		,t.AddedBy
		,t.IsUpdated
		,t.DeclareNumber
		,t.UpdateDiff
		,t.IsDada
		,t.IsBAkar
		,t.IsAAkar
		,t.AddedDayTime
		,t.UpdatedDayTime
		,t.RecordStatus
		,t.OrderAddeddate
		,t.ClientRemarks
		,ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
		ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
		ifnull(transaction_audit.LastStatus,0) LastStatus,
		ifnull(transaction_audit.Remark,'') Remark
		from
			(
			SELECT convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId
				,l.LedgerName 
				, t.ShiftId, t.TotalAmount, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
				date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
				date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
				,t.AddedBy
				,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
				,'' DeclareNumber
				,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
				,0 as IsDada
				,0 as IsBAkar
				,0 as IsAAkar
				,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
				,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
				,t.RecordStatus as RecordStatus
				,t.AddedDate as OrderAddeddate
				,t.ClientRemarks
				
				FROM transaction t
				join ledger l on t.LedgerId = l.LedgerId
				where t.OrganizationId = varOrganizationId
				and t.ShiftId = varShiftId
				and t.TransactionDate = varShiftDate
				and (case when varIsDeleted = 1 then t.RecordStatus = 'D' else t.RecordStatus != 'D' end)
				and t.LedgerId = varLedgerId
				and (varRoleType = 'ALL' 
					or t.UpdatedBy  = varUserName
					)
				and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
			) as t
		left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
		order by t.OrderAddeddate desc;
	else
		SELECT t.TransactionId, t.OrganizationId, t.LedgerId
		,t.LedgerName LedgerName
		,t.ShiftId,t.TotalAmount
		, t.UpdatedBy, t.TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
		t.TransactionDate, 
		t.AddedDate, 
		t.UpdatedDate
		,t.AddedBy
		,t.IsUpdated
		,t.DeclareNumber
		,t.UpdateDiff
		,t.IsDada
		,t.IsBAkar
		,t.IsAAkar
		,t.AddedDayTime
		,t.UpdatedDayTime
		,t.RecordStatus
		,t.OrderAddeddate
		,t.ClientRemarks
		,ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
		ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
		ifnull(transaction_audit.LastStatus,0) LastStatus,
		ifnull(transaction_audit.Remark,'') Remark
		from
			(
			SELECT convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId
				,l.LedgerName 
				, t.ShiftId, t.TotalAmount, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
				date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
				date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
				,t.AddedBy
				,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
				,'' DeclareNumber
				,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
				,0 as IsDada
				,0 as IsBAkar
				,0 as IsAAkar
				,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
				,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
				,t.RecordStatus as RecordStatus
				,t.AddedDate as OrderAddeddate
				,t.ClientRemarks
				
				FROM transaction t
				join ledger l on t.LedgerId = l.LedgerId
				where t.OrganizationId = varOrganizationId
				and t.ShiftId = varShiftId
				and t.TransactionDate = varShiftDate
				and (case when varIsDeleted = 1 then t.RecordStatus = 'D' else t.RecordStatus != 'D' end)
				and (varRoleType = 'ALL' 
					or t.UpdatedBy  = varUserName
					)
				and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
			) as t
		left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
		order by t.OrderAddeddate desc;
	end case;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_audit_all_of_organization`(IN varOrganizationId int(20),
 IN varShiftId int(20), IN varShiftDate DATE
 ,in varIsAudit int 
 ,in varMistakeStatus int
 ,in varModifyStatus int
 ,IN varLedgerName varchar(50)
 )
begin
/*
IsAudit 0 All,1 Not Audit ,2 Audit
varMistakeStatus -1 All 0 & 1 by MistakeStatus
varModifyStatus -1 All 0 & 1 by ModifyStatus
*/
		select t.* 
		,ifnull(transaction_audit.TransactionAuditId,0) TransactionAuditId
		,ifnull(transaction_audit.Amount,0) Amount,
		ifnull(transaction_audit.AmountUpdated,0) AmountUpdated,
		ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
		ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
		ifnull(transaction_audit.LastStatus,0) LastStatus,
		ifnull(transaction_audit.Remark,'') Remark,
		ifnull(transaction_audit.AddedBy,'') AddedByAudit,
		ifnull(transaction_audit.AddedDate,'1970-01-01 00:00:00') AddedDateAudit,
		ifnull(transaction_audit.UpdatedBy,'') UpdatedByAudit,
		ifnull(transaction_audit.UpdatedDate,'1970-01-01 00:00:00') UpdatedDateAudit,
		(case when ifnull(transaction_audit.MistakeStatus,0) = 2 then 1 else 0 end) ReAudit
		from
			(
				SELECT convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId, l.LedgerName, t.ShiftId, t.TotalAmount, t.UpdatedBy
				, t.TransactionDate as 	TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
				date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
				date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
				,t.AddedBy
				,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
				,'' DeclareNumber
				,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
				,0 as IsDada
				,0 as IsBAkar
				,0 as IsAAkar
				,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
				,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
				
				,shift.ShiftName
				,t.AddedDate as OrderAddeddate
				FROM transaction t
				join ledger l on t.LedgerId = l.LedgerId and ifnull(l.ParentLedgerId,0) = 0
				join shift on shift.ShiftId = t.ShiftId 
				where t.OrganizationId = varOrganizationId
				and (case when ifnull(varShiftId , 0 ) = 0 then 
						t.TransactionDate = shift.ShiftDate
						and shift.OrganizationId = varOrganizationId
						and shift.IsActive = 1
						and shift.RecordStatus != 'D'
					else
						t.ShiftId = varShiftId
						and t.TransactionDate = varShiftDate
					end)
				and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
				and t.RecordStatus != 'D'

			) as t
			left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
			inner join login on login.UserName = t.AddedBy
			where (case when varIsAudit = 1 then (transaction_audit.TransactionAuditId is null or ifnull(transaction_audit.MistakeStatus,0) = 2) when varIsAudit = 2 then transaction_audit.TransactionAuditId is not null else true end)
			and (ifnull(transaction_audit.MistakeStatus,0) mod 2 = ifnull(varMistakeStatus,0) or ifnull(varMistakeStatus,0) = -1)
			and (transaction_audit.ModifyStatus = ifnull(varModifyStatus,0) or ifnull(varModifyStatus,0) = -1)
			and login.LoginType not in (3,4,5)
			order by t.OrderAddeddate ;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_capping`(IN varOrganizationId int(20)
 , IN varLedgerId int(20)
 , IN varShiftId int(20)
 , IN varShiftDate DATE
 , IN varTransactionId bigint(21)
 , In varIsAfterDeclare int
 )
begin
/*
varIsAfterDeclare =0 live = 1 after declare
*/
	case when ifnull(varIsAfterDeclare,0) = 0 then
		SELECT 
			Number,NumberType,sum(Amount) as Amount 

		FROM transaction t
		inner join transaction_detail td on td.TransactionId = t.TransactionId
		
		where t.OrganizationId = varOrganizationId
		and t.TransactionDate = varShiftDate
		and (ifnull(varShiftId , 0 ) = 0 or t.ShiftId = varShiftId)
		and t.LedgerId = varLedgerId
		and t.RecordStatus != 'D'
		and td.RecordStatus != 'D'
		and t.TransactionId != varTransactionId
		group by Number,NumberType		
		order by Number,NumberType ;
	else
		SELECT 
			Number,NumberType,sum(Amount) as Amount 

		FROM transaction_declare t
		inner join transaction_detail_declare td on td.TransactionId = t.TransactionId
		
		where t.OrganizationId = varOrganizationId
		and t.TransactionDate = varShiftDate
		and (ifnull(varShiftId , 0 ) = 0 or t.ShiftId = varShiftId)
		and t.LedgerId = varLedgerId
		and t.RecordStatus != 'D'
		and td.RecordStatus != 'D'
		and t.TransactionId != varTransactionId
		group by Number,NumberType		
		order by Number,NumberType ;
	end case;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_check_after_before_declare`(
IN varOrganizationId int(20)
, IN varShiftId int(20)
, IN varShiftDate DATE
, IN varLedgerId int(20)
, IN varLedgerName varchar(50)
, IN varIsAfterDeclare int(20)
)
begin

		select t.* ,
		ifnull(transaction_audit.MistakeStatus,0) mod 2 MistakeStatus,
		ifnull(transaction_audit.ModifyStatus,0) ModifyStatus,
		ifnull(transaction_audit.LastStatus,0) LastStatus,
		ifnull(transaction_audit.Remark,'') Remark
		from
			(
			select convert(t.TransactionId,char) TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
			, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa
			, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				t.TransactionDate , 
				t.AddedDate, 
				t.UpdatedDate
			,t.AddedBy
			,IsUpdated
			,DeclareNumber
			,UpdateDiff
			,max(IsDada) as IsDada
			,max(IsBAkar) as IsBAkar
			,max(IsAAkar) as IsAAkar
			,t.AddedDayTime
			,t.UpdatedDayTime
			,t.RecordStatus as RecordStatus
			,t.IsAfterDeclare
			,t.DeclareDateAdded
			from (
				SELECT t.TransactionId, t.OrganizationId, t.LedgerId, l.LedgerName, t.ShiftId, t.TotalAmount
				, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa
				, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
					date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
					date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
					date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
				,t.AddedBy
				,(case when t.UpdatedDate = t.AddedDate then 'No' else 'Yes' end ) as IsUpdated
				,DeclareNumber
				,timediff(t.UpdatedDate , t.AddedDate) UpdateDiff
				,(case when td.Number = d.DeclareNumber then 1 else 0 end ) as IsDada
				,(case when td.Number = right(lpad ((d.DeclareNumber mod 10) * 111 ,3,"0"),3) then 1 else 0 end ) as IsBAkar
				,(case when td.Number = right(lpad ((floor((d.DeclareNumber/10)) mod 10) * 1111 ,4,"0"),4) then 1 else 0 end ) as IsAAkar
				,date_format(t.AddedDate,'%d - %h:%i %p') as AddedDayTime
				,date_format(t.UpdatedDate,'%d - %h:%i %p') as UpdatedDayTime
				,t.RecordStatus as RecordStatus
				,if(t.UpdatedDate > d.AddedDate,1,0) IsAfterDeclare 
				,d.AddedDate DeclareDateAdded
				FROM transaction_declare t
					inner join transaction_detail_declare td on td.TransactionId = t.TransactionId
					inner join ledger l on t.LedgerId = l.LedgerId
					inner join `declare_result` as d on d.RecordStatus != 'D' and d.DeclareDate = t.TransactionDate and d.ShiftId = t.ShiftId and d.OrganizationId = varOrganizationId
					where t.OrganizationId = varOrganizationId
					and t.ShiftId = varShiftId
					and t.TransactionDate = varShiftDate
					
					and t.RecordStatus != 'D' 
					and (t.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0)
					and l.LedgerName like concat(ifnull(varLedgerName,'') ,'%')
				) as t
			where 1=1
			and (case varIsAfterDeclare when 0 then t.IsAfterDeclare = 0 when 1 then t.IsAfterDeclare = 1 else True end)
			group by t.TransactionId, t.OrganizationId, t.LedgerId, t.LedgerName, t.ShiftId, t.TotalAmount
			, t.UpdatedBy, t.TransactionDate , t.TransactionType, t.KFlag, t.IsHissa
			, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
				t.TransactionDate, 
				t.AddedDate, 
				t.UpdatedDate
			,t.AddedBy
			,DeclareNumber
			,IsUpdated
			,UpdateDiff
			,t.RecordStatus 
			,t.IsAfterDeclare
			,t.DeclareDateAdded
		) as t
		left join transaction_audit on transaction_audit.TransactionId = t.TransactionId and transaction_audit.RecordStatus != 'D'
		order by t.AddedDate desc;
			

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_check_after_before_declare_consolidated_amount`(
IN varOrganizationId int(20)
, IN varShiftId int(20)
, IN varShiftFromDate DATE
, IN varShiftToDate DATE
)
begin
		
	select 	t.TotSale,t.Amount,t.TotSaleBeforeTransaction
	,t.AmountBeforeTransaction,t.DeclareNumber,t.TransactionDate,t.ShiftId
	,shift.ShiftName
	from
	(
		select	sum(Amount) as TotSale
		,-sum((ifnull((if((Number = declare_result.DeclareNumber or Number = right(lpad ((declare_result.DeclareNumber mod 10) * 111 ,3,"0"),3)  
							or Number = right(lpad ((floor((declare_result.DeclareNumber/10)) mod 10) * 1111 ,4,"0"),4)) 
							and t.TransactionMode = 1 ,t.Amount * t.Rate ,0 )),0)
				- ifnull((if(t.TransactionMode = 1 ,t.FinalAmount ,0 )),0)
				)
				*(((100-ifnull(t.SelfHissa,0))/100))*(((100-ifnull(t.OtherHissa,0))/100))
				)as Amount
				
		,sum(if(t.UpdatedDate > declare_result.AddedDate,0,Amount)) as TotSaleBeforeTransaction
		
		,-sum(if(t.UpdatedDate > declare_result.AddedDate,0,
			(ifnull((if((Number = declare_result.DeclareNumber or Number = right(lpad ((declare_result.DeclareNumber mod 10) * 111 ,3,"0"),3)  
					or Number = right(lpad ((floor((declare_result.DeclareNumber/10)) mod 10) * 1111 ,4,"0"),4)) 
					and t.TransactionMode = 1 ,Amount * Rate ,0 )),0)
					- ifnull((if(t.TransactionMode = 1 ,FinalAmount ,0 )),0) 
					)
					*(((100-ifnull(t.SelfHissa,0))/100))*(((100-ifnull(t.OtherHissa,0))/100))
				)
			)as AmountBeforeTransaction
		,declare_result.DeclareNumber as DeclareNumber
		,t.TransactionDate
		,t.ShiftId
		from (
			select  
				Number,Amount,Rate,transaction_detail_declare.FinalAmount
				,transaction_declare.SelfHissa
				,transaction_declare.OtherHissa
				,transaction_declare.TransactionMode
				,transaction_declare.UpdatedDate
				,transaction_declare.TransactionDate
				,transaction_declare.ShiftId
			from transaction_declare 
			inner join transaction_detail_declare on transaction_declare.TransactionId = transaction_detail_declare.TransactionId
			where transaction_declare.TransactionDate between varShiftFromDate and varShiftToDate 
			and  (transaction_declare.ShiftId = varShiftId or ifnull(varShiftId,0) = 0 )
			and  transaction_declare.OrganizationId = varOrganizationId
			and transaction_declare.TransactionMode = 1 
			and transaction_declare.RecordStatus!='D'
			and transaction_detail_declare.RecordStatus!='D'
		) as t
		inner join declare_result on declare_result.DeclareDate = t.TransactionDate 
					and declare_result.ShiftId = t.ShiftId 
					and declare_result.RecordStatus != 'D'		
		group by declare_result.DeclareNumber 
		,t.TransactionDate
		,t.ShiftId
	) as t
	inner join shift on shift.ShiftId = t.ShiftId
	order by t.TransactionDate,shift.ShiftOrder
		;
		

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_collection_of_hp_ledgerwise`(
       IN `TransactionDates` DATE,
       IN `varShiftId` BIGINT(21),
	   IN `varOrganizationId` BIGINT(8),
	   IN `varHPLedgerId` BIGINT(8),
	   IN `varAmountLess` INT,
	   IN `varPercentLess` INT
)
begin

	select Number as Number
	,
				case when round(((sum(
							NEW_BAL
							) 
					- varAmountLess) * (100 - varPercentLess)/100),0) > 0 
				then
					round(((sum(
								NEW_BAL
								) 
					- varAmountLess) * (100 - varPercentLess)/100),0) 
				else
					0
				end
	as NEW_BAL
	
    from 
	(
		SELECT SUM(IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)) AS KhaiAmount
		,SUM(IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)) AS LagaiAmount
/*		,
		sum((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))) as Amount
		
		,(sum(((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)))
		*(((100-ifnull(t.SelfHissa,0))/100))*(((100-ifnull(t.OtherHissa,0))/100))
				)
		 )
		AS NEW_BAL
*/
		,
		sum((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))) as Amount
		
		,(sum(((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)))
		*(((100-ifnull(t.SelfHissa,0))/100))
				)
		 )
		AS NEW_BAL

		,mainjantrinumbers.Num  as Number
		FROM transaction_detail td
		JOIN transaction t ON td.TransactionId = t.TransactionId
		and t.TransactionDate = TransactionDates  
		and  t.ShiftId = varShiftId
		and  td.RecordStatus!='D'
		and  t.RecordStatus!='D'
		and (ifnull(varOrganizationId,0) = 0 or t.OrganizationId = varOrganizationId)
		join ledger l on t.LedgerId = l.LedgerId
				right join mainjantrinumbers on td.Number = (case when td.NumberType = 1 then mainjantrinumbers.Num  
						when td.NumberType = 2 then right(lpad ((mainjantrinumbers.Num mod 10) * 111 ,3,"0"),3)
						when td.NumberType = 3 then right(lpad ((floor((mainjantrinumbers.Num/10)) mod 10) * 1111 ,4,"0"),4)
						else -1
						end)
		where 1=1
		and (ifnull(varHPLedgerId,0) = 0 or l.HPLedgerId = varHPLedgerId )

		GROUP BY mainjantrinumbers.Num
	) as AA
	group by AA.Number
	Order By AA.Number ASC;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_collection_of_hp_ledgerwise_declare`(
       IN `TransactionDates` DATE,
       IN `varShiftId` BIGINT(21),
	   IN `varOrganizationId` BIGINT(8),
	   IN `varHPLedgerId` BIGINT(8),
	   IN `varAmountLess` INT,
	   IN `varPercentLess` INT
)
begin

	select Number as Number
	,
				case when round(((sum(
							NEW_BAL
							) 
					- varAmountLess) * (100 - varPercentLess)/100),0) > 0 
				then
					round(((sum(
								NEW_BAL
								) 
					- varAmountLess) * (100 - varPercentLess)/100),0) 
				else
					0
				end
	as NEW_BAL
	
    from 
	(
		SELECT SUM(IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)) AS KhaiAmount
		,SUM(IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)) AS LagaiAmount
/*		,
		sum((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))) as Amount
		
		,(sum(((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)))
		*(((100-ifnull(t.SelfHissa,0))/100))*(((100-ifnull(t.OtherHissa,0))/100))
				)
		 )
		AS NEW_BAL
*/
		,
		sum((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))) as Amount
		
		,(sum(((IF(t.TransactionMode = '1', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0))
		- (IF(t.TransactionMode = '0', if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10), 0)))
		*(((100-ifnull(t.SelfHissa,0))/100))
				)
		 )
		AS NEW_BAL

		,mainjantrinumbers.Num  as Number
		FROM transaction_detail_declare td
		JOIN transaction_declare t ON td.TransactionId = t.TransactionId
		and t.TransactionDate = TransactionDates  
		and  t.ShiftId = varShiftId
		and  td.RecordStatus!='D'
		and  t.RecordStatus!='D'
		and (ifnull(varOrganizationId,0) = 0 or t.OrganizationId = varOrganizationId)
		join ledger l on t.LedgerId = l.LedgerId
				right join mainjantrinumbers on td.Number = (case when td.NumberType = 1 then mainjantrinumbers.Num  
						when td.NumberType = 2 then right(lpad ((mainjantrinumbers.Num mod 10) * 111 ,3,"0"),3)
						when td.NumberType = 3 then right(lpad ((floor((mainjantrinumbers.Num/10)) mod 10) * 1111 ,4,"0"),4)
						else -1
						end)
		where 1=1
		and (ifnull(varHPLedgerId,0) = 0 or l.HPLedgerId = varHPLedgerId )

		GROUP BY mainjantrinumbers.Num
	) as AA
	group by AA.Number
	Order By AA.Number ASC;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_collection_of_organization`(
	IN `varOrganizationId` bigint(21)
	, IN `varTransactionDate` DATE
	, IN `varShiftId` int(20)
	, IN `varLedgerId` varchar(100)
	, IN `varAgentId` bigint(8)
	, IN `varAmountLess` INT
	, IN `varPercentLess` INT
	, IN `varMultiplyUp` float
	, IN `varIsCommCut` int
	, IN `varIsHissaCut` int
	, IN `varIsDibba` int
	, IN `varIsMixing` int
	)
begin
	declare varRoundBy int;
	declare varRoundByShift int;
	
	select organization.RoundOffOnCollection into varRoundBy 
		from organization 
		where organization.OrganizationId = varOrganizationId
	;
	select shift.RoundOffOnCollection into varRoundByShift 
		from shift 
		where shift.ShiftId = varShiftId
	;
	set varRoundBy = if(ifnull(varRoundByShift,0) > 0 , ifnull(varRoundByShift,0) ,varRoundBy);
	
	case when ifnull(varIsMixing,0) = 0 then

		SELECT DISTINCT 0 as TransactionId,
		round(
		case when 
			ifnull((((SUM(t.Amount) 
			* varMultiplyUp )
			- varAmountLess) * (100 - varPercentLess)/100),0) > 0 
		then
			(case when (select organization.IsCollectionJantriRoundOf from organization where organization.OrganizationId = varOrganizationId) = 1 then 
				((ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0))
				div varRoundBy) * varRoundBy
				+ IF
				(
					(ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0))	
					MOD varRoundBy = 0, 0, varRoundBy
				)			
			else
				ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0)
			end)
		else
			0
		end
		,0)
		AS 'Amount', 
		t.Number,t.TransactionDate,t.ShiftId
		from (
			select
				(case when ifnull(IsDibba,'NO') = 'YES' and varIsDibba = 1 then 
					(case when 
							ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
							*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
							),0)
							> DibbaAmount then 
						
						(
							ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
							*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
							),0)
							- DibbaAmount) 
					else 0 end)			
				else 
					ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
					*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
					),0)
				end)			
			AS 'Amount', 
			td.Number,t.TransactionDate,t.ShiftId

			FROM transaction_detail td
			JOIN transaction t ON td.TransactionId = t.TransactionId
			inner join ledger l on t.LedgerId = l.LedgerId
			WHERE t.OrganizationId = varOrganizationId
			and t.TransactionDate = varTransactionDate
			and t.TransactionMode = 1 
			and t.ShiftId = varShiftId
				and (ifnull(varLedgerId,'') = '' or ifnull(varLedgerId,'') = '0' or FIND_IN_SET(t.LedgerId,varLedgerId) or FIND_IN_SET(l.ParentLedgerId,varLedgerId) 
					or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where FIND_IN_SET(dis.ParentLedgerId,varLedgerId)))
				and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
															where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = 31))								
					)
			AND td.RecordStatus != 'D'
			GROUP BY td.Number,t.TransactionDate,t.ShiftId,t.LedgerId,l.DibbaAmount,l.IsDibba
		) as t	
		group by t.Number,t.TransactionDate,t.ShiftId	
		;
	else
		SELECT DISTINCT 0 as TransactionId,
		round(
		case when 
			ifnull((((SUM(t.Amount) 
			* varMultiplyUp )
			- varAmountLess) * (100 - varPercentLess)/100),0) > 0 
		then
			(case when (select organization.IsCollectionJantriRoundOf from organization where organization.OrganizationId = varOrganizationId) = 1 then 
				((ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0))
				div varRoundBy) * varRoundBy
				+ IF
				(
					(ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0))	
					MOD varRoundBy = 0, 0, varRoundBy
				)			
			else
				ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0)
			end)
		else
			0
		end
		,0)
		AS 'Amount', 
		t.Number,t.TransactionDate,t.ShiftId
		from (
			select
				(case when ifnull(IsDibba,'NO') = 'YES' and varIsDibba = 1 then 
					(case when 
							ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
							*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
							),0)
							> DibbaAmount then 
						
						(
							ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
							*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
							),0)
							- DibbaAmount) 
					else 0 end)			
				else 
					ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
					*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
					),0)
				end)			
			AS 'Amount', 
			mainjantrinumbers.Num as Number,t.TransactionDate,t.ShiftId

			FROM transaction_detail td
			JOIN transaction t ON td.TransactionId = t.TransactionId
			and t.OrganizationId = varOrganizationId
			and t.TransactionDate = varTransactionDate
			and t.TransactionMode = 1 
			and t.ShiftId = varShiftId
			AND td.RecordStatus != 'D'
			inner join ledger l on t.LedgerId = l.LedgerId
				and (ifnull(varLedgerId,'') = '' or ifnull(varLedgerId,'') = '0' or FIND_IN_SET(t.LedgerId,varLedgerId) or FIND_IN_SET(l.ParentLedgerId,varLedgerId) 
					or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where FIND_IN_SET(dis.ParentLedgerId,varLedgerId)))
				and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
															where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = 31))								
					)
				right join mainjantrinumbers on td.Number = (case when td.NumberType = 1 then mainjantrinumbers.Num  
						when td.NumberType = 2 then right(lpad ((mainjantrinumbers.Num mod 10) * 111 ,3,"0"),3)
						when td.NumberType = 3 then right(lpad ((floor((mainjantrinumbers.Num/10)) mod 10) * 1111 ,4,"0"),4)
						else -1
						end)
			GROUP BY mainjantrinumbers.Num,t.TransactionDate,t.ShiftId,t.LedgerId,l.DibbaAmount,l.IsDibba
		) as t	
		group by t.Number,t.TransactionDate,t.ShiftId	
		;
	end case;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_collection_of_organization_new`(
	IN `varOrganizationId` bigint(21)
	, IN `varTransactionDate` DATE
	, IN `varShiftId` int(20)
	, IN `varLedgerId` varchar(2000)
	, IN `varAgentId` bigint(8)
	, IN `varAmountLess` INT
	, IN `varPercentLess` INT
	, IN `varMultiplyUp` float
	, IN `varIsCommCut` int
	, IN `varIsHissaCut` int
	, IN `varIsDibba` int
	, IN `varIsMixing` int
	, IN `varAgentLedgerId` bigint(8)
	, IN `varAgentGroupId` bigint(8)
	, IN `varAfterDeclare` int #0 for before declare 1 for after declare 
	)
begin
	declare varRoundBy int;
	declare varRoundByShift int;
	if varAfterDeclare = 0 then 
		select organization.RoundOffOnCollection into varRoundBy 
			from organization 
			where organization.OrganizationId = varOrganizationId
		;
		select shift.RoundOffOnCollection into varRoundByShift 
			from shift 
			where shift.ShiftId = varShiftId
		;
		set varRoundBy = if(ifnull(varRoundByShift,0) > 0 , ifnull(varRoundByShift,0) ,varRoundBy);
		
		case when ifnull(varIsMixing,0) = 0 then

			SELECT DISTINCT 0 as TransactionId,
			round(
			case when 
				ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0) > 0 
			then
				(case when (select organization.IsCollectionJantriRoundOf from organization where organization.OrganizationId = varOrganizationId) = 1 then 
					((ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0))
					div varRoundBy) * varRoundBy
					+ IF
					(
						(ifnull((((SUM(t.Amount) 
						* varMultiplyUp )
						- varAmountLess) * (100 - varPercentLess)/100),0))	
						MOD varRoundBy = 0, 0, varRoundBy
					)			
				else
					ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0)
				end)
			else
				0
			end
			,0)
			AS 'Amount', 
			t.Number,t.TransactionDate,t.ShiftId
			from (
				select
					(case when ifnull(IsDibba,'NO') = 'YES' and varIsDibba = 1 then 
						(case when 
								ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
								*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
								),0)
								> DibbaAmount then 
							
							(
								ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
								*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
								),0)
								- DibbaAmount) 
						else 0 end)			
					else 
						ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
						*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
						),0)
					end)			
				AS 'Amount', 
				td.Number,t.TransactionDate,t.ShiftId
				,l.AgentLedgerId
				FROM transaction_detail td
				JOIN transaction t ON td.TransactionId = t.TransactionId
				inner join ledger l on t.LedgerId = l.LedgerId
				WHERE t.OrganizationId = varOrganizationId
				and t.TransactionDate = varTransactionDate
				and t.TransactionMode = 1 
				and t.ShiftId = varShiftId
					and (ifnull(varLedgerId,'') = '' or ifnull(varLedgerId,'') = '0' or FIND_IN_SET(t.LedgerId,varLedgerId) or FIND_IN_SET(l.ParentLedgerId,varLedgerId) 
						or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where FIND_IN_SET(dis.ParentLedgerId,varLedgerId)))
					and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
																where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = 31))								
						)
				AND td.RecordStatus != 'D'
				GROUP BY td.Number,t.TransactionDate,t.ShiftId,t.LedgerId,l.DibbaAmount,l.IsDibba,l.AgentLedgerId
			) as t	
			join comman_master as agent on agent.CommanMasterId = t.AgentLedgerId and agent.CommanMasterType = 1
			where (ifnull(varAgentLedgerId,0) = 0 or ifnull(agent.LedgerId,0) = ifnull(varAgentLedgerId,0))
			and (ifnull(varAgentGroupId,0) = 0 or ifnull(t.AgentLedgerId,0) = ifnull(varAgentGroupId,0)) 
			group by t.Number,t.TransactionDate,t.ShiftId	
			;
		else
			SELECT DISTINCT 0 as TransactionId,
			round(
			case when 
				ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0) > 0 
			then
				(case when (select organization.IsCollectionJantriRoundOf from organization where organization.OrganizationId = varOrganizationId) = 1 then 
					((ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0))
					div varRoundBy) * varRoundBy
					+ IF
					(
						(ifnull((((SUM(t.Amount) 
						* varMultiplyUp )
						- varAmountLess) * (100 - varPercentLess)/100),0))	
						MOD varRoundBy = 0, 0, varRoundBy
					)			
				else
					ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0)
				end)
			else
				0
			end
			,0)
			AS 'Amount', 
			t.Number,t.TransactionDate,t.ShiftId
			from (
				select
					(case when ifnull(IsDibba,'NO') = 'YES' and varIsDibba = 1 then 
						(case when 
								ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
								*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
								),0)
								> DibbaAmount then 
							
							(
								ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
								*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
								),0)
								- DibbaAmount) 
						else 0 end)			
					else 
						ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
						*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
						),0)
					end)			
				AS 'Amount', 
				mainjantrinumbers.Num as Number,t.TransactionDate,t.ShiftId
				,l.AgentLedgerId
				FROM transaction_detail td
				JOIN transaction t ON td.TransactionId = t.TransactionId
				and t.OrganizationId = varOrganizationId
				and t.TransactionDate = varTransactionDate
				and t.TransactionMode = 1 
				and t.ShiftId = varShiftId
				AND td.RecordStatus != 'D'
				inner join ledger l on t.LedgerId = l.LedgerId
					and (ifnull(varLedgerId,'') = '' or ifnull(varLedgerId,'') = '0' or FIND_IN_SET(t.LedgerId,varLedgerId) or FIND_IN_SET(l.ParentLedgerId,varLedgerId) 
						or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where FIND_IN_SET(dis.ParentLedgerId,varLedgerId)))
					and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
																where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = 31))								
						)
					right join mainjantrinumbers on td.Number = (case when td.NumberType = 1 then mainjantrinumbers.Num  
							when td.NumberType = 2 then right(lpad ((mainjantrinumbers.Num mod 10) * 111 ,3,"0"),3)
							when td.NumberType = 3 then right(lpad ((floor((mainjantrinumbers.Num/10)) mod 10) * 1111 ,4,"0"),4)
							else -1
							end)
				GROUP BY mainjantrinumbers.Num,t.TransactionDate,t.ShiftId,t.LedgerId,l.DibbaAmount,l.IsDibba,l.AgentLedgerId
			) as t	
			join comman_master as agent on agent.CommanMasterId = t.AgentLedgerId and agent.CommanMasterType = 1
			where (ifnull(varAgentLedgerId,0) = 0 or ifnull(agent.LedgerId,0) = ifnull(varAgentLedgerId,0))
			and (ifnull(varAgentGroupId,0) = 0 or ifnull(t.AgentLedgerId,0) = ifnull(varAgentGroupId,0)) 
			group by t.Number,t.TransactionDate,t.ShiftId	
			;
		end case;
	else
		select organization.RoundOffOnCollection into varRoundBy 
			from organization 
			where organization.OrganizationId = varOrganizationId
		;
		select shift.RoundOffOnCollection into varRoundByShift 
			from shift 
			where shift.ShiftId = varShiftId
		;
		set varRoundBy = if(ifnull(varRoundByShift,0) > 0 , ifnull(varRoundByShift,0) ,varRoundBy);
		
		case when ifnull(varIsMixing,0) = 0 then

			SELECT DISTINCT 0 as TransactionId,
			round(
			case when 
				ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0) > 0 
			then
				(case when (select organization.IsCollectionJantriRoundOf from organization where organization.OrganizationId = varOrganizationId) = 1 then 
					((ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0))
					div varRoundBy) * varRoundBy
					+ IF
					(
						(ifnull((((SUM(t.Amount) 
						* varMultiplyUp )
						- varAmountLess) * (100 - varPercentLess)/100),0))	
						MOD varRoundBy = 0, 0, varRoundBy
					)			
				else
					ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0)
				end)
			else
				0
			end
			,0)
			AS 'Amount', 
			t.Number,t.TransactionDate,t.ShiftId
			from (
				select
					(case when ifnull(IsDibba,'NO') = 'YES' and varIsDibba = 1 then 
						(case when 
								ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
								*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
								),0)
								> DibbaAmount then 
							
							(
								ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
								*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
								),0)
								- DibbaAmount) 
						else 0 end)			
					else 
						ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
						*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
						),0)
					end)			
				AS 'Amount', 
				td.Number,t.TransactionDate,t.ShiftId
				,l.AgentLedgerId
				FROM transaction_detail_declare td
				JOIN transaction_declare t ON td.TransactionId = t.TransactionId
				inner join ledger l on t.LedgerId = l.LedgerId
				WHERE t.OrganizationId = varOrganizationId
				and t.TransactionDate = varTransactionDate
				and t.TransactionMode = 1 
				and t.ShiftId = varShiftId
					and (ifnull(varLedgerId,'') = '' or ifnull(varLedgerId,'') = '0' or FIND_IN_SET(t.LedgerId,varLedgerId) or FIND_IN_SET(l.ParentLedgerId,varLedgerId) 
						or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where FIND_IN_SET(dis.ParentLedgerId,varLedgerId)))
					and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
																where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = 31))								
						)
				AND td.RecordStatus != 'D'
				GROUP BY td.Number,t.TransactionDate,t.ShiftId,t.LedgerId,l.DibbaAmount,l.IsDibba,l.AgentLedgerId
			) as t	
			join comman_master as agent on agent.CommanMasterId = t.AgentLedgerId and agent.CommanMasterType = 1
			where (ifnull(varAgentLedgerId,0) = 0 or ifnull(agent.LedgerId,0) = ifnull(varAgentLedgerId,0))
			and (ifnull(varAgentGroupId,0) = 0 or ifnull(t.AgentLedgerId,0) = ifnull(varAgentGroupId,0)) 
			group by t.Number,t.TransactionDate,t.ShiftId	
			;
		else
			SELECT DISTINCT 0 as TransactionId,
			round(
			case when 
				ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0) > 0 
			then
				(case when (select organization.IsCollectionJantriRoundOf from organization where organization.OrganizationId = varOrganizationId) = 1 then 
					((ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0))
					div varRoundBy) * varRoundBy
					+ IF
					(
						(ifnull((((SUM(t.Amount) 
						* varMultiplyUp )
						- varAmountLess) * (100 - varPercentLess)/100),0))	
						MOD varRoundBy = 0, 0, varRoundBy
					)			
				else
					ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0)
				end)
			else
				0
			end
			,0)
			AS 'Amount', 
			t.Number,t.TransactionDate,t.ShiftId
			from (
				select
					(case when ifnull(IsDibba,'NO') = 'YES' and varIsDibba = 1 then 
						(case when 
								ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
								*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
								),0)
								> DibbaAmount then 
							
							(
								ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
								*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
								),0)
								- DibbaAmount) 
						else 0 end)			
					else 
						ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
						*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
						),0)
					end)			
				AS 'Amount', 
				mainjantrinumbers.Num as Number,t.TransactionDate,t.ShiftId
				,l.AgentLedgerId
				FROM transaction_detail_declare td
				JOIN transaction_declare t ON td.TransactionId = t.TransactionId
				and t.OrganizationId = varOrganizationId
				and t.TransactionDate = varTransactionDate
				and t.TransactionMode = 1 
				and t.ShiftId = varShiftId
				AND td.RecordStatus != 'D'
				inner join ledger l on t.LedgerId = l.LedgerId
					and (ifnull(varLedgerId,'') = '' or ifnull(varLedgerId,'') = '0' or FIND_IN_SET(t.LedgerId,varLedgerId) or FIND_IN_SET(l.ParentLedgerId,varLedgerId) 
						or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where FIND_IN_SET(dis.ParentLedgerId,varLedgerId)))
					and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
																where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = 31))								
						)
					right join mainjantrinumbers on td.Number = (case when td.NumberType = 1 then mainjantrinumbers.Num  
							when td.NumberType = 2 then right(lpad ((mainjantrinumbers.Num mod 10) * 111 ,3,"0"),3)
							when td.NumberType = 3 then right(lpad ((floor((mainjantrinumbers.Num/10)) mod 10) * 1111 ,4,"0"),4)
							else -1
							end)
				GROUP BY mainjantrinumbers.Num,t.TransactionDate,t.ShiftId,t.LedgerId,l.DibbaAmount,l.IsDibba,l.AgentLedgerId
			) as t	
			join comman_master as agent on agent.CommanMasterId = t.AgentLedgerId and agent.CommanMasterType = 1
			where (ifnull(varAgentLedgerId,0) = 0 or ifnull(agent.LedgerId,0) = ifnull(varAgentLedgerId,0))
			and (ifnull(varAgentGroupId,0) = 0 or ifnull(t.AgentLedgerId,0) = ifnull(varAgentGroupId,0)) 
			group by t.Number,t.TransactionDate,t.ShiftId	
			;
		end case;
	end if;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_count_of_organization`(IN varOrganizationId int(20)
 , IN varShiftId int(20)
 , IN varShiftDate DATE
 , In varIsAfterDeclare int
 )
begin
/*
varIsAfterDeclare =0 live = 1 after declare
*/
	case when ifnull(varIsAfterDeclare,0) = 0 then
		SELECT 
			t.LedgerId, l.LedgerName, count(1) as TransactionCount , sum(TotalAmount) as TotalAmount 

		FROM transaction t
		join ledger l on t.LedgerId = l.LedgerId and ifnull(l.ParentLedgerId,0) = 0
		join shift on shift.ShiftId = t.ShiftId
		join login on login.UserName = t.AddedBy
		where t.OrganizationId = varOrganizationId
		and t.TransactionDate = varShiftDate
		and (ifnull(varShiftId , 0 ) = 0 or t.ShiftId = varShiftId)
		and t.RecordStatus != 'D'
		and login.LoginType not in (3,4,5)
		group by t.LedgerId, l.LedgerName		
		order by l.LedgerName;
	else
		SELECT 
			t.LedgerId, l.LedgerName, count(1) as TransactionCount , sum(TotalAmount) as TotalAmount 

		FROM transaction_declare t
		join ledger l on t.LedgerId = l.LedgerId and ifnull(l.ParentLedgerId,0) = 0
		join shift on shift.ShiftId = t.ShiftId
		join login on login.UserName = t.AddedBy
		where t.OrganizationId = varOrganizationId
		and t.TransactionDate = varShiftDate
		and (ifnull(varShiftId , 0 ) = 0 or t.ShiftId = varShiftId)
		and t.RecordStatus != 'D'
		and login.LoginType not in (3,4,5)
		group by t.LedgerId, l.LedgerName		
		order by l.LedgerName;

	end case;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_declare_collection_of_organization`(
	IN `varOrganizationId` bigint(21)
	, IN `varTransactionDate` DATE
	, IN `varShiftId` int(20)
	, IN `varLedgerId` varchar(200)
	, IN `varAgentId` bigint(8)
	, IN `varAmountLess` INT
	, IN `varPercentLess` INT
	, IN `varMultiplyUp` float
	, IN `varIsCommCut` int
	, IN `varIsHissaCut` int
	, IN `varIsDibba` int
	, IN `varIsMixing` int
	)
begin
	declare varRoundBy int;
	declare varRoundByShift int;
	
	select organization.RoundOffOnCollection into varRoundBy 
		from organization 
		where organization.OrganizationId = varOrganizationId
	;
	select shift.RoundOffOnCollection into varRoundByShift 
		from shift 
		where shift.ShiftId = varShiftId
	;
	set varRoundBy = if(ifnull(varRoundByShift,0) > 0 , ifnull(varRoundByShift,0) ,varRoundBy);
	
	case when ifnull(varIsMixing,0) = 0 then

		SELECT DISTINCT 0 as TransactionId,
		round(
		case when 
			ifnull((((SUM(t.Amount) 
			* varMultiplyUp )
			- varAmountLess) * (100 - varPercentLess)/100),0) > 0 
		then
			(case when (select organization.IsCollectionJantriRoundOf from organization where organization.OrganizationId = varOrganizationId) = 1 then 
				((ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0))
				div varRoundBy) * varRoundBy
				+ IF
				(
					(ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0))	
					MOD varRoundBy = 0, 0, varRoundBy
				)			
			else
				ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0)
			end)
		else
			0
		end
		,0)
		AS 'Amount', 
		t.Number,t.TransactionDate,t.ShiftId
		from (
			select
				(case when ifnull(IsDibba,'NO') = 'YES' and varIsDibba = 1 then 
					(case when 
							ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
							*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
							),0)
							> DibbaAmount then 
						
						(
							ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
							*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
							),0)
							- DibbaAmount) 
					else 0 end)			
				else 
					ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,td.Amount,td.FinalAmount), 0)
					*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
					),0)
				end)			
			AS 'Amount', 
			td.Number,t.TransactionDate,t.ShiftId

			FROM transaction_detail_declare td
			JOIN transaction_declare t ON td.TransactionId = t.TransactionId
			inner join ledger l on t.LedgerId = l.LedgerId
			WHERE t.OrganizationId = varOrganizationId
			and t.TransactionDate = varTransactionDate
			and (t.TransactionMode = 1 
					or (case when instr(varLedgerId,',') = 0 and (ifnull(varLedgerId,'') != '' and ifnull(varLedgerId,'') != '0') then l.GroupId = 2 else false end)
					)
			and t.ShiftId = varShiftId
				and (ifnull(varLedgerId,'') = '' or ifnull(varLedgerId,'') = '0' or FIND_IN_SET(t.LedgerId,varLedgerId) or FIND_IN_SET(l.ParentLedgerId,varLedgerId) 
					or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where FIND_IN_SET(dis.ParentLedgerId,varLedgerId)))
				and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
															where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = varAgentId))								
					)
			AND td.RecordStatus != 'D'
			GROUP BY td.Number,t.TransactionDate,t.ShiftId,t.LedgerId,l.DibbaAmount,l.IsDibba
		) as t	
		group by t.Number,t.TransactionDate,t.ShiftId	
		;
	else
		SELECT DISTINCT 0 as TransactionId,
		round(
		case when 
			ifnull((((SUM(t.Amount) 
			* varMultiplyUp )
			- varAmountLess) * (100 - varPercentLess)/100),0) > 0 
		then
			(case when (select organization.IsCollectionJantriRoundOf from organization where organization.OrganizationId = varOrganizationId) = 1 then 
				((ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0))
				div varRoundBy) * varRoundBy
				+ IF
				(
					(ifnull((((SUM(t.Amount) 
					* varMultiplyUp )
					- varAmountLess) * (100 - varPercentLess)/100),0))	
					MOD varRoundBy = 0, 0, varRoundBy
				)			
			else
				ifnull((((SUM(t.Amount) 
				* varMultiplyUp )
				- varAmountLess) * (100 - varPercentLess)/100),0)
			end)
		else
			0
		end
		,0)
		AS 'Amount', 
		t.Number,t.TransactionDate,t.ShiftId
		from (
			select
				(case when ifnull(IsDibba,'NO') = 'YES' and varIsDibba = 1 then 
					(case when 
							ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
							*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
							),0)
							> DibbaAmount then 
						
						(
							ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
							*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
							),0)
							- DibbaAmount) 
					else 0 end)			
				else 
					ifnull(SUM(IF(t.EntryType = 'Main', if(varIsCommCut = 0,if(td.NumberType = 1,td.Amount,td.Amount/10),if(td.NumberType = 1,td.FinalAmount,td.FinalAmount/10)), 0)
					*(((100-ifnull(if(varIsHissaCut = 0,0,t.SelfHissa),0))/100))*(((100-ifnull(if(varIsHissaCut = 0,0,t.OtherHissa),0))/100)) 
					),0)
				end)			
			AS 'Amount', 
			mainjantrinumbers.Num as Number,t.TransactionDate,t.ShiftId

			FROM transaction_detail_declare td
			JOIN transaction_declare t ON td.TransactionId = t.TransactionId
			and t.OrganizationId = varOrganizationId
			and t.TransactionDate = varTransactionDate
			and (t.TransactionMode = 1 
					or (case when instr(varLedgerId,',') = 0 and (ifnull(varLedgerId,'') != '' and ifnull(varLedgerId,'') != '0') then l.GroupId = 2 else false end)
					)
			and t.ShiftId = varShiftId
			AND td.RecordStatus != 'D'
			inner join ledger l on t.LedgerId = l.LedgerId
				and (ifnull(varLedgerId,'') = '' or ifnull(varLedgerId,'') = '0' or FIND_IN_SET(t.LedgerId,varLedgerId) or FIND_IN_SET(l.ParentLedgerId,varLedgerId) 
					or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where FIND_IN_SET(dis.ParentLedgerId,varLedgerId)))
				and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
															where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = varAgentId))								
					)
				right join mainjantrinumbers on td.Number = (case when td.NumberType = 1 then mainjantrinumbers.Num  
						when td.NumberType = 2 then right(lpad ((mainjantrinumbers.Num mod 10) * 111 ,3,"0"),3)
						when td.NumberType = 3 then right(lpad ((floor((mainjantrinumbers.Num/10)) mod 10) * 1111 ,4,"0"),4)
						else -1
						end)
			GROUP BY mainjantrinumbers.Num,t.TransactionDate,t.ShiftId,t.LedgerId,l.DibbaAmount,l.IsDibba
		) as t	
		group by t.Number,t.TransactionDate,t.ShiftId	
		;
	end case;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_detail_row_of_organization`(
IN varOrganizationId int(20)
, IN varTransactionId bigint(21)
, IN varLedgerId bigint(21)
, IN varShiftDate DATE
, IN varShiftId bigint(21)
)
SELECT td.*, IF(CHAR_LENGTH(td.Number) = 2, ROUND(td.Number), td.Number) as Number
	FROM transaction_detail td
	join transaction t on t.TransactionId = td.TransactionId
	where td.OrganizationId = varOrganizationId
	and (ifnull(varTransactionId,0)=0 or td.TransactionId = varTransactionId)
	and (ifnull(varLedgerId,0)=0 or t.LedgerId = varLedgerId)
	and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId )
	and t.TransactionDate = varShiftDate
	and td.RecordStatus != 'D'
	and t.RecordStatus != 'D'
    order by td.OrderNumber ASC$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_jantri_of_organization`(IN `varOrganizationId` bigint(21)
, IN `varTransactionDate` DATE
, IN `varShiftId` int(20)
, IN `varLedgerId` bigint(21)
, IN `varAgentId` bigint(8)
, IN `varMode` int
)
select AA.NumberType
	,sum(case when ifnull(IsDibba,'NO') = 'YES' then 
					(case when ((Amount - DibbaAmount) * (100 - Commission) / 100) > DibbaAmount 
						then (((Amount - DibbaAmount) * (100 - Commission) / 100)) 
						else 0 end) 
				else 
					((Amount) * (100 - Commission) / 100) 
				end

) Amount
	,AA.Number
	from
	(	
		SELECT DISTINCT 
		td.Number,td.NumberType
		,l.LedgerId
		,(case when varMode = 1 then 0 else td.Commission end) as Commission  
		,SUM(IF(t.EntryType = 'Main', td.FinalAmount, 0)) AS FinalAmount
		,round(SUM(if(t.EntryType = 'Main', if (t.TransactionMode = 1,
		((case when varMode = 1 then td.FinalAmount	else td.Amount end) * (100-ifnull(t.SelfHissa,0)) * (100-
		
		ifnull(
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = t.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				,0)
		))/10000
		,0),0))) as Amount
		
		FROM transaction_detail td
		JOIN transaction t ON td.TransactionId = t.TransactionId
		join ledger l on t.LedgerId = l.LedgerId
		WHERE t.OrganizationId = varOrganizationId
		and t.TransactionDate = varTransactionDate
		and t.ShiftId = varShiftId
		AND td.RecordStatus != 'D'
		AND t.RecordStatus != 'D'
		and (ifnull(varLedgerId,0) = 0 or t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
		and (ifnull(varAgentId,0) = 0 or l.AgentLedgerId = varAgentId)									
			
		GROUP BY td.Number,td.NumberType
		,l.LedgerId
		,td.Commission
    ) as AA 
	join ledger as l on l.LedgerId = AA.LedgerId
	group by AA.NumberType,AA.Number
	Order By AA.NumberType,AA.Number ASC$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_jantri_of_organization_declare`(IN `varOrganizationId` bigint(21)
, IN `varTransactionDate` DATE
, IN `varShiftId` int(20)
, IN `varLedgerId` bigint(21)
, IN `varAgentId` bigint(8)
, IN `varMode` int
)
select AA.NumberType
	,sum(case when ifnull(IsDibba,'NO') = 'YES' then 
					(case when ((Amount - DibbaAmount) * (100 - Commission) / 100) > DibbaAmount 
						then (((Amount - DibbaAmount) * (100 - Commission) / 100)) 
						else 0 end) 
				else 
					((Amount) * (100 - Commission) / 100) 
				end

) Amount
	,AA.Number
	from
	(	
		SELECT DISTINCT 
		td.Number,td.NumberType
		,l.LedgerId
		,(case when varMode = 1 then 0 else td.Commission end) as Commission  
		,SUM(IF(t.EntryType = 'Main', td.FinalAmount, 0)) AS FinalAmount
		,round(SUM(if(t.EntryType = 'Main', if (t.TransactionMode = 1,
		((case when varMode = 1 then td.FinalAmount	else td.Amount end) * (100-ifnull(t.SelfHissa,0)) * (100-
		
		ifnull(
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = t.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				,0)
		))/10000
		,0),0))) as Amount
		
		FROM transaction_detail_declare td
		JOIN transaction_declare t ON td.TransactionId = t.TransactionId
		join ledger l on t.LedgerId = l.LedgerId
		WHERE t.OrganizationId = varOrganizationId
		and t.TransactionDate = varTransactionDate
		and t.ShiftId = varShiftId
		AND td.RecordStatus != 'D'
		AND t.RecordStatus != 'D'
		and (ifnull(varLedgerId,0) = 0 or t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
		and (ifnull(varAgentId,0) = 0 or l.AgentLedgerId = varAgentId)									
		GROUP BY td.Number,td.NumberType
		,l.LedgerId
		,td.Commission
    ) as AA 
	join ledger as l on l.LedgerId = AA.LedgerId
	group by AA.NumberType,AA.Number
	Order By AA.NumberType,AA.Number ASC$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_jantri_of_organization_declare_new`(IN `varOrganizationId` bigint(21)
, IN `varTransactionDate` DATE
, IN `varShiftId` int(20)
, IN `varLedgerId` bigint(21)
, IN `varAgentId` bigint(8)
, IN `varMode` int
, IN `varAmountLess` INT
, IN `varPercentLess` INT
)
select AA.NumberType
	,(case when round(((sum(case when ifnull(IsDibba,'NO') = 'YES' then 
					(case when ((Amount - DibbaAmount) * (100 - Commission) / 100) > DibbaAmount 
						then (((Amount - DibbaAmount) * (100 - Commission) / 100)) 
						else 0 end) 
				else 
					((Amount) * (100 - Commission) / 100) 
				end) - varAmountLess) * (100 - varPercentLess)/100),0) > 0 
	then 
				round(((sum(case when ifnull(IsDibba,'NO') = 'YES' then 
					(case when ((Amount - DibbaAmount) * (100 - Commission) / 100) > DibbaAmount 
						then (((Amount - DibbaAmount) * (100 - Commission) / 100)) 
						else 0 end) 
				else 
					((Amount) * (100 - Commission) / 100) 
				end) - varAmountLess) * (100 - varPercentLess)/100),0)
	else 0 end

)	
	as		Amount
	,AA.Number
	from
	(	
		SELECT DISTINCT 
		td.Number,td.NumberType
		,l.LedgerId
		,(case when varMode = 1 then 0 else td.Commission end) as Commission  
		,SUM(IF(t.EntryType = 'Main', td.FinalAmount, 0)) AS FinalAmount
		,round(SUM(if(t.EntryType = 'Main', if (t.TransactionMode = 1,
		((case when varMode = 1 then td.FinalAmount	else td.Amount end) * (100-ifnull(t.SelfHissa,0)) * (100-
		
		ifnull(
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = t.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				,0)
		))/10000
		,0),0))) as Amount
		
		FROM transaction_detail_declare td
		JOIN transaction_declare t ON td.TransactionId = t.TransactionId
		join ledger l on t.LedgerId = l.LedgerId
		WHERE t.OrganizationId = varOrganizationId
		and t.TransactionDate = varTransactionDate
		and t.ShiftId = varShiftId
		AND td.RecordStatus != 'D'
		AND t.RecordStatus != 'D'
		and (ifnull(varLedgerId,0) = 0 or t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
		and (ifnull(varAgentId,0) = 0 or l.AgentLedgerId = varAgentId)									
		GROUP BY td.Number,td.NumberType
		,l.LedgerId
		,td.Commission
    ) as AA 
	join ledger as l on l.LedgerId = AA.LedgerId
	group by AA.NumberType,AA.Number
	Order By AA.NumberType,AA.Number ASC$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_jantri_of_organization_new`(IN `varOrganizationId` bigint(21)
, IN `varTransactionDate` DATE
, IN `varShiftId` int(20)
, IN `varLedgerId` bigint(21)
, IN `varAgentId` bigint(8)
, IN `varMode` int
, IN `varAmountLess` INT
, IN `varPercentLess` INT
)
select AA.NumberType
	,(case when round(((sum(case when ifnull(IsDibba,'NO') = 'YES' then 
					(case when ((Amount - DibbaAmount) * (100 - Commission) / 100) > DibbaAmount 
						then (((Amount - DibbaAmount) * (100 - Commission) / 100)) 
						else 0 end) 
				else 
					((Amount) * (100 - Commission) / 100) 
				end) - varAmountLess) * (100 - varPercentLess)/100),0) > 0 
	then 
				round(((sum(case when ifnull(IsDibba,'NO') = 'YES' then 
					(case when ((Amount - DibbaAmount) * (100 - Commission) / 100) > DibbaAmount 
						then (((Amount - DibbaAmount) * (100 - Commission) / 100)) 
						else 0 end) 
				else 
					((Amount) * (100 - Commission) / 100) 
				end) - varAmountLess) * (100 - varPercentLess)/100),0)
	else 0 end

)	
	as		Amount
	,AA.Number
	from
	(	
		SELECT DISTINCT 
		td.Number,td.NumberType
		,l.LedgerId
		,(case when varMode = 1 then 0 else td.Commission end) as Commission  
		,SUM(IF(t.EntryType = 'Main', td.FinalAmount, 0)) AS FinalAmount
		,round(SUM(if(t.EntryType = 'Main', if (t.TransactionMode = 1,
		((case when varMode = 1 then td.FinalAmount	else td.Amount end) * (100-ifnull(t.SelfHissa,0)) * (100-
		
		ifnull(
						(select sum(Hissa) from 
						hissa 
						where hissa.RecordStatus!='D' and hissa.LedgerId = t.LedgerId and hissa.LedgerId != hissa.HissaLedgerId)
				,0)
		))/10000
		,0),0))) as Amount
		
		FROM transaction_detail td
		JOIN transaction t ON td.TransactionId = t.TransactionId
		join ledger l on t.LedgerId = l.LedgerId
		WHERE t.OrganizationId = varOrganizationId
		and t.TransactionDate = varTransactionDate
		and t.ShiftId = varShiftId
		AND td.RecordStatus != 'D'
		AND t.RecordStatus != 'D'
		and (ifnull(varLedgerId,0) = 0 or t.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
		and (ifnull(varAgentId,0) = 0 or l.AgentLedgerId = varAgentId)									
			
		GROUP BY td.Number,td.NumberType
		,l.LedgerId
		,td.Commission
    ) as AA 
	join ledger as l on l.LedgerId = AA.LedgerId
	group by AA.NumberType,AA.Number
	Order By AA.NumberType,AA.Number ASC$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_kwada_total_party_wise`(
  IN varOrganizationId int(20)
 , IN varShiftId int(20)
 , IN varShiftDate DATE
 , IN varLedgerId int(20)
 , IN varUserName varchar(100)
 , IN varAmount float
 , IN varCount int(20)
 )
begin
	select distinct t.LedgerId,t.LedgerName 
	,(select sum(ts.TotalAmount) from transaction as ts where ts.LedgerId = t.LedgerId
			and ts.ShiftId = varShiftId
			and ts.TransactionDate = varShiftDate
			and ts.RecordStatus != 'D'
    
    ) as TotalAmount
	,varShiftId as ShiftId , varShiftDate as ShiftDate
		from 
		(
		SELECT  t.LedgerId,l.LedgerName,sum(td.Amount) as Amount,td.Number,td.NumberType
			FROM transaction t
			join transaction_detail td on t.TransactionId = td.TransactionId
			join ledger l on t.LedgerId = l.LedgerId
			where t.OrganizationId = varOrganizationId
			and t.ShiftId = varShiftId
			and t.TransactionDate = varShiftDate
			and t.RecordStatus != 'D'
			and td.RecordStatus != 'D'

			group by t.LedgerId
			, l.LedgerName,td.NumberType
			,td.Number
			having sum(td.Amount) >= varAmount
		) as t
	group by t.LedgerId,t.LedgerName,t.Amount
	having count(1) >= varCount
	;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_kwada_total_party_wise_declare`(
  IN varOrganizationId int(20)
 , IN varShiftId int(20)
 , IN varShiftDate DATE
 , IN varLedgerId int(20)
 , IN varUserName varchar(100)
 , IN varAmount float
 , IN varCount int(20)
 )
begin
	select distinct t.LedgerId,t.LedgerName 
	,(select sum(ts.TotalAmount) from transaction_declare as ts where ts.LedgerId = t.LedgerId
			and ts.ShiftId = varShiftId
			and ts.TransactionDate = varShiftDate
			and ts.RecordStatus != 'D'
    
    ) as TotalAmount
	,varShiftId as ShiftId , varShiftDate as ShiftDate
		from 
		(
		SELECT  t.LedgerId,l.LedgerName,sum(td.Amount) as Amount,td.Number,td.NumberType
			FROM transaction_declare t
			join transaction_detail_declare td on t.TransactionId = td.TransactionId
			join ledger l on t.LedgerId = l.LedgerId
			where t.OrganizationId = varOrganizationId
			and t.ShiftId = varShiftId
			and t.TransactionDate = varShiftDate
			and t.RecordStatus != 'D'
			and td.RecordStatus != 'D'

			group by t.LedgerId
			, l.LedgerName,td.NumberType
			,td.Number
			having sum(td.Amount) >= varAmount
		) as t
	group by t.LedgerId,t.LedgerName,t.Amount
	having count(1) >= varCount
	;
	
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_limit_check_of_ledger`(IN varOrganizationId int(20)
, IN varLedgerId varchar(50)
, IN varTransactionId varchar(50)
, IN varTransactionIdIsTmp varchar(50)
)
SELECT l.*
	,ledger_limit.LedgerBalance 
    ,ledger_limit.LedgerLimit 
    ,ledger_limit.TransConsum 
	- (case when varTransactionIdIsTmp = 0 then 
		ifnull((select sum(transaction.TotalAmount)
		from transaction 
		where transaction.LedgerId = varLedgerId
		and transaction.TransactionId = varTransactionId
		and transaction.RecordStatus != 'D'
		),0) 
	when 1 then
		ifnull((select sum(transaction_declare.TotalAmount)
		from transaction_declare 
		where transaction_declare.LedgerId = varLedgerId
		and transaction_declare.TransactionId = varTransactionId
		and transaction_declare.RecordStatus != 'D'
		),0) 
	else
		0
	end

)
	as TransConsum
    ,ledger_limit.FinalLimit 
	- (case when varTransactionIdIsTmp = 0 then 
		ifnull((select sum(transaction.TotalAmount)
		from transaction 
		where transaction.LedgerId = varLedgerId
		and transaction.TransactionId = varTransactionId
		and transaction.RecordStatus != 'D'
		),0) 
	when 1 then
		ifnull((select sum(transaction_declare.TotalAmount)
		from transaction_declare 
		where transaction_declare.LedgerId = varLedgerId
		and transaction_declare.TransactionId = varTransactionId
		and transaction_declare.RecordStatus != 'D'
		),0) 
	else
		0
	end)
	as FinalLimit
	
    FROM ledger l
	left join ledger_limit on l.LedgerId = ledger_limit.LedgerId
    where l.OrganizationId = varOrganizationId
	and l.LedgerId = varLedgerId
	and l.RecordStatus != 'D'
    order by l.LedgerName desc$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_narration_row_of_organization`(IN varOrganizationId int(20), IN varTransactionId bigint(21))
SELECT tn.*
	FROM transaction_narration tn
	where tn.OrganizationId = varOrganizationId
	and tn.TransactionId = varTransactionId
	and tn.RecordStatus != 'D'$$
DELIMITER ;
;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_row_of_organization`(IN varOrganizationId int(20), IN varTransactionId bigint(21))
BEGIN
	SELECT t.TransactionId, t.OrganizationId, t.LedgerId
    ,t.SelfHissa
    ,t.OtherHissa
    , l.LedgerName, t.ShiftId, t.TotalAmount, t.UpdatedBy, t.TransactionDate as TransactionDateDB, t.TransactionType, t.KFlag, t.IsHissa, t.DaraRate, t.DaraCommission, t.AkharRate, t.AkharCommission, t.DeviceType,
	date_format(t.TransactionDate,'%d-%m-%Y') as TransactionDate, 
	date_format(t.AddedDate,'%d-%m-%Y %h:%i %p') as AddedDate, 
	date_format(t.UpdatedDate,'%d-%m-%Y %h:%i %p') as UpdatedDate
	,t.Tax
	FROM transaction t
	join ledger l on t.LedgerId = l.LedgerId
	where t.OrganizationId = varOrganizationId
	and t.TransactionId = varTransactionId
	and t.RecordStatus != 'D'
    order by t.UpdatedDate desc;

END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `transaction_today_not_working_ledger`(
       IN `varOrganizationId` BIGINT(8),
	   IN `varShiftId` BIGINT(21),
	   IN `TransactionDates` DATE
    
)
begin

	select t.LedgerId,l.LedgerName,LastWorkingDays as LastWorkingDays
	,login.Mobile,ifnull(agent.CommanMasterName,'NA') as AgentName
	from
	(
		select t.LedgerId,count(1) as LastWorkingDays
		from
			(select t.TransactionDate,t.OrganizationId,t.LedgerId
			
			FROM transaction_declare t 
				where t.TransactionDate between DATE_ADD(TransactionDates,INTERVAL -3 DAY) and DATE_ADD(TransactionDates,INTERVAL -1 DAY)   
				and  (t.ShiftId = varShiftId or ifnull(varShiftId,0) = 0)
				and  t.RecordStatus!='D'
				and (ifnull(varOrganizationId,0) = 0 or t.OrganizationId = varOrganizationId)
				and t.LedgerId not in (select transaction.LedgerId from transaction 
					where transaction.TransactionDate = TransactionDates 
					and  (transaction.ShiftId = varShiftId or ifnull(varShiftId,0) = 0)
					and  transaction.RecordStatus!='D'
					and (ifnull(varOrganizationId,0) = 0 or transaction.OrganizationId = varOrganizationId)
					group by transaction.LedgerId )
				and t.LedgerId not in (select transaction_declare.LedgerId from transaction_declare 
					where transaction_declare.TransactionDate = TransactionDates 
					and  (transaction_declare.ShiftId = varShiftId or ifnull(varShiftId,0) = 0)
					and  transaction_declare.RecordStatus!='D'
					and (ifnull(varOrganizationId,0) = 0 or transaction_declare.OrganizationId = varOrganizationId)
					group by transaction_declare.LedgerId )
				GROUP BY t.TransactionDate,t.OrganizationId,t.LedgerId
			) as t			
		group by t.LedgerId
		having count(1) >= 1  
	) as t
    join ledger l on t.LedgerId = l.LedgerId and ifnull(l.ParentLedgerId,0) = 0
	left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1			
	left join login on login.LedgerId = l.LedgerId
	Order By -LastWorkingDays ,l.LedgerName ASC;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `Transfer_Voucher_TablesToDump1`(IN UpToDate DATE )
    NO SQL
begin

delete from voucher_tmp ;
delete from voucher_detail_tmp ;

/*
ALTER TABLE `voucher_dump` 
DROP INDEX `OrganizationId` ,
DROP INDEX `ShiftId` ,
DROP INDEX `VoucherDate` ,
DROP INDEX `VoucherType` ,
DROP INDEX `VoucherId`, 
DROP INDEX `RecordStatus` 
;



ALTER TABLE `voucher_detail_dump` 
DROP INDEX `VoucherId` ,
DROP INDEX `OrganizationId` ,
DROP INDEX `LedgerId` ,
DROP INDEX `OppositeLedgerId` ,
DROP INDEX `VoucherDate` ,
DROP INDEX `AmountType` ,
DROP INDEX `VoucherDetailType` ,
DROP INDEX `RecordStatus` ,
DROP INDEX `ShiftId` 
;
*/

INSERT INTO voucher_dump
(
  `VoucherId` ,
  `OrganizationId` ,
  `ShiftId` ,
  `VoucherDate` ,
  `VoucherType` ,
  `Amount` ,
  `Remark` ,
  `LagaiKhai` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 
)
SELECT 
  `VoucherId` ,
  `OrganizationId` ,
  `ShiftId` ,
  `VoucherDate` ,
  `VoucherType` ,
  `Amount` ,
  `Remark` ,
  `LagaiKhai` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 
FROM voucher
where VoucherDate <= UpToDate
and RecordStatus <> 'D'
and VoucherId not in (-1,-2) ;

INSERT INTO voucher_detail_dump
(  `VoucherDetailId` ,
  `OrganizationId` ,
  `VoucherId` ,
  `ShiftId` ,
  `LedgerId` ,
  `OppositeLedgerId` ,
  `FromLedgerId` ,
  `VoucherType` ,
  `VoucherDetailType` ,
  `VoucherDate` ,
  `Amount` ,
  `AmountType` ,
  `OpenAmount` ,
  `SelfHissa` ,
  `OtherHissa` ,
  `Flag1` ,
  `Remark` ,
  `MondayFinalFlag` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 
)
SELECT   `VoucherDetailId` ,
  `OrganizationId` ,
  `VoucherId` ,
  `ShiftId` ,
  `LedgerId` ,
  `OppositeLedgerId` ,
  `FromLedgerId` ,
  `VoucherType` ,
  `VoucherDetailType` ,
  `VoucherDate` ,
  `Amount` ,
  `AmountType` ,
  `OpenAmount` ,
  `SelfHissa` ,
  `OtherHissa` ,
  `Flag1` ,
  `Remark` ,
  `MondayFinalFlag` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 

FROM voucher_detail
where VoucherDate <= UpToDate
and RecordStatus <> 'D'
and VoucherId not in (-1,-2) ;

/*
ALTER TABLE `voucher_dump` 
ADD INDEX `OrganizationId` (`OrganizationId` ASC),
ADD INDEX `ShiftId` (`ShiftId` ASC),
ADD INDEX `VoucherDate` (`VoucherDate` ASC),
ADD INDEX `VoucherType` (`VoucherType` ASC),
ADD INDEX `VoucherId` (`VoucherId` ASC),
ADD INDEX `RecordStatus` (`RecordStatus` ASC)
;


ALTER TABLE `voucher_detail_dump` 
ADD INDEX `VoucherId` (`VoucherId` ASC),
ADD INDEX `OrganizationId` (`OrganizationId` ASC),
ADD INDEX `LedgerId` (`LedgerId` ASC),
ADD INDEX `OppositeLedgerId` (`OppositeLedgerId` ASC),
ADD INDEX `VoucherDate` (`VoucherDate` ASC),
ADD INDEX `AmountType` (`AmountType` ASC),
ADD INDEX `VoucherDetailType` (`VoucherDetailType` ASC),
ADD INDEX `RecordStatus` (`RecordStatus` ASC),
ADD INDEX `ShiftId` (`ShiftId` ASC)

;
*/
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `Transfer_Voucher_TablesToDump2`(IN UpToDate DATE )
    NO SQL
begin

INSERT INTO voucher_tmp
(
  `VoucherId` ,
  `OrganizationId` ,
  `ShiftId` ,
  `VoucherDate` ,
  `VoucherType` ,
  `Amount` ,
  `Remark` ,
  `LagaiKhai` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 

)
SELECT -1
	,0
	,0
    ,UpToDate,
    1,
    0,
    '',
    0,
    0,
    'S',
    -1,
    CURRENT_TIMESTAMP(),
    -1,
    CURRENT_TIMESTAMP()
;

INSERT INTO voucher_detail_tmp
(
  `VoucherDetailId` ,
  `OrganizationId` ,
  `VoucherId` ,
  `ShiftId` ,
  `LedgerId` ,
  `OppositeLedgerId` ,
  `FromLedgerId` ,
  `VoucherType` ,
  `VoucherDetailType` ,
  `VoucherDate` ,
  `Amount` ,
  `AmountType` ,
  `OpenAmount` ,
  `SelfHissa` ,
  `OtherHissa` ,
  `Flag1` ,
  `Remark` ,
  `MondayFinalFlag` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 


)
SELECT VoucherDetailId,
	OrganizationId,
    -1,
	0,
    LedgerId,
    0,
	0,
	1,	
	0,
	UpToDate,
    sum((case when AmountType ='Dr' then Amount else -Amount end)) ,
    'Dr',
    0,
	0,
    0,
    0,
	'',
	'True',
	'AUTO',
	
    'S',
    -1,
    CURRENT_TIMESTAMP(),
    -1,
    CURRENT_TIMESTAMP()
FROM voucher_detail_dump
where VoucherType != 2
and RecordStatus <> 'D'
group by 
    LedgerId,OrganizationId
;

INSERT INTO voucher_tmp
(
  `VoucherId` ,
  `OrganizationId` ,
  `ShiftId` ,
  `VoucherDate` ,
  `VoucherType` ,
  `Amount` ,
  `Remark` ,
  `LagaiKhai` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 
)
SELECT -2
	,0
	,0
    ,UpToDate,
    2,
    0,
    '',
    0,
    0,
    'S',
    -1,
    CURRENT_TIMESTAMP(),
    -1,
    CURRENT_TIMESTAMP()
;


INSERT INTO voucher_detail_tmp
(  `VoucherDetailId` ,
  `OrganizationId` ,
  `VoucherId` ,
  `ShiftId` ,
  `LedgerId` ,
  `OppositeLedgerId` ,
  `FromLedgerId` ,
  `VoucherType` ,
  `VoucherDetailType` ,
  `VoucherDate` ,
  `Amount` ,
  `AmountType` ,
  `OpenAmount` ,
  `SelfHissa` ,
  `OtherHissa` ,
  `Flag1` ,
  `Remark` ,
  `MondayFinalFlag` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 
)
SELECT VoucherDetailId,
	OrganizationId,
    -2,
	0,
    LedgerId,
    0,
	0,
	2,	
	0,
	UpToDate,
    sum((case when AmountType ='Dr' then Amount else -Amount end)) ,
    'Dr',
    0,
	0,
    0,
    0,
	'',
	'True',
	'AUTO',
	
    'S',
    -1,
    CURRENT_TIMESTAMP(),
    -1,
    CURRENT_TIMESTAMP()
FROM voucher_detail_dump
where VoucherType = 2
and RecordStatus <> 'D'
group by 
    LedgerId,OrganizationId
;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `Transfer_Voucher_TablesToDump3`(IN UpToDate DATE )
    NO SQL
begin
delete FROM voucher
where VoucherDate <= UpToDate;

delete FROM voucher_detail
where VoucherDate <= UpToDate;

end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `Transfer_Voucher_TablesToDump4`(IN UpToDate DATE )
    NO SQL
begin
INSERT INTO voucher
(
  `VoucherId` ,
  `OrganizationId` ,
  `ShiftId` ,
  `VoucherDate` ,
  `VoucherType` ,
  `Amount` ,
  `Remark` ,
  `LagaiKhai` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 
)
SELECT 
  `VoucherId` ,
  `OrganizationId` ,
  `ShiftId` ,
  `VoucherDate` ,
  `VoucherType` ,
  `Amount` ,
  `Remark` ,
  `LagaiKhai` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 
from voucher_tmp
;

INSERT INTO voucher_detail
(
	  `VoucherDetailId` ,
  `OrganizationId` ,
  `VoucherId` ,
  `ShiftId` ,
  `LedgerId` ,
  `OppositeLedgerId` ,
  `FromLedgerId` ,
  `VoucherType` ,
  `VoucherDetailType` ,
  `VoucherDate` ,
  `Amount` ,
  `AmountType` ,
  `OpenAmount` ,
  `SelfHissa` ,
  `OtherHissa` ,
  `Flag1` ,
  `Remark` ,
  `MondayFinalFlag` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 
)
	SELECT   `VoucherDetailId` ,
  `OrganizationId` ,
  `VoucherId` ,
  `ShiftId` ,
  `LedgerId` ,
  `OppositeLedgerId` ,
  `FromLedgerId` ,
  `VoucherType` ,
  `VoucherDetailType` ,
  `VoucherDate` ,
  `Amount` ,
  `AmountType` ,
  `OpenAmount` ,
  `SelfHissa` ,
  `OtherHissa` ,
  `Flag1` ,
  `Remark` ,
  `MondayFinalFlag` ,
  `VoucherMode` ,
  `RecordStatus` ,
  `AddedBy` ,
  `AddedDate` ,
  `UpdatedBy` ,
  `UpdatedDate` 

FROM voucher_detail_tmp
;
end$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `update_ledger_Status`(
	IN varLedgerId int
	, IN varUpdateRecordStatus varchar(20)
	, IN varUpdateIsHide bigint
	, IN varRecordStatus varchar(20)
	, IN varIsHide bigint
	, IN varUpdatedBy bigint
	)
BEGIN
	SET @s = CONCAT('update ledger 
	' );
	
	if ifnull(varUpdateRecordStatus,'') != '' then 
		SET @s = CONCAT(@s,' set RecordStatus = ''',varRecordStatus,'''
		');
		if ifnull(varUpdateIsHide,'') != '' then 
			SET @s = CONCAT(@s,' , IsHide = ''',varUpdateIsHide,'''
			');
		end if;
	else
		if ifnull(varUpdateIsHide,'') != '' then 
			SET @s = CONCAT(@s,'set IsHide = ''',varUpdateIsHide,'''
			');
		end if;
	end if;
	SET @s = CONCAT(@s,' , UpdatedBy = ''',varUpdatedBy,'''
	');
	SET @s = CONCAT(@s,' , UpdatedDate = getdate() 
	');
	SET @s = CONCAT(@s,' where 1=1 
	');
	SET @s = CONCAT(@s,' and RecordStatus != ''',varRecordStatus,'''
	');
	SET @s = CONCAT(@s,' and IsHide != ''',varIsHide,'''
	');
	SET @s = CONCAT(@s,' and (ledger.LedgerId = ',varLedgerId,'
		or (ledger.LedgerId in (select Retailer.LedgerId from ledger as Retailer where Retailer.ParentLedgerId = ',varLedgerId,'))
		or (ledger.LedgerId in (select Retailer.LedgerId from ledger as Retailer 
			where Retailer.ParentLedgerId in (select Distributer.LedgerId from ledger as Distributer where Distributer.ParentLedgerId = ',varLedgerId,')) 
			)
		)
	');
	
	PREPARE stmt FROM @s;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	
END$$

DELIMITER;

DELIMITER $$

CREATE DEFINER=`stark99db21`@`%` PROCEDURE `voucher_all_of_organization`(IN varOrganizationId bigint(20)
	, IN `varFromDate` DATE
	, IN `varToDate` DATE
	, IN `varLedgerId` bigint(20)
	, IN `varVoucherType` INT(10)
	, IN `varAgentId` bigint(8)
	, IN varIsDeleted int(20)

)
    NO SQL
SELECT v.VoucherId as VoucherId, vd.*,v.Remark,
	(case when ifnull(v.ShiftId,0) != 0 then '' else v.Remark end

) VoucherRemark,
    l.LedgerName as LedgerName, ol.LedgerName as OppositLedgerName
    FROM voucher v
    JOIN voucher_detail vd ON v.VoucherId = vd.VoucherId
    join (select min(VoucherDetailId)VoucherDetailId from voucher_detail 
			where (case when varIsDeleted = 1 then true else voucher_detail.RecordStatus != 'D' end) 
	group by voucher_detail.VoucherId) as MinVoucher on MinVoucher.VoucherDetailId = vd.VoucherDetailId
    JOIN ledger l ON vd.LedgerId = l.LedgerId
	JOIN ledger ol ON vd.OppositeLedgerId = ol.LedgerId
    WHERE v.OrganizationId = varOrganizationId
    and v.VoucherType = varVoucherType
    AND v.VoucherDate >= varFromDate
    AND v.VoucherDate <= varToDate
		and (ifnull(varLedgerId,0) = 0 or vd.LedgerId = varLedgerId or l.ParentLedgerId = varLedgerId 
			or l.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.ParentLedgerId = varLedgerId))
		and (ifnull(varAgentId,0) = 0 or l.ParentLedgerId in (select Res.LedgerId from ledger as Res 
													where Res.ParentLedgerId in (select dis.LedgerId from ledger as dis where dis.AgentLedgerId = 31))								
			)
    and (case when varIsDeleted = 1 then v.RecordStatus = 'D' else v.RecordStatus != 'D' AND vd.RecordStatus != 'D' end)
				
	order by vd.VoucherDate DESC, UpdatedDate DESC$$

DELIMITER;