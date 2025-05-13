ALTER TABLE t_member
ADD f_emergencyContactName VARCHAR(50) NOT NULL DEFAULT '',
    f_emergencyContactPhone INT NOT NULL DEFAULT 0,
    f_emergencyContactRelation VARCHAR(10) NOT NULL DEFAULT '';