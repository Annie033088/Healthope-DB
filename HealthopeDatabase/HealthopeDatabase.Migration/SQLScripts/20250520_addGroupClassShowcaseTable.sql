CREATE TABLE t_groupClassShowcase (
    f_groupClassShowcaseId INT NOT NULL IDENTITY PRIMARY KEY,
    f_name NVARCHAR(20) NOT NULL,
    f_introduction NVARCHAR(80) NOT NULL,
    f_specialty NVARCHAR(500) NOT NULL,
    f_imageUrl NVARCHAR(100) NOT NULL,
    f_category INT NOT NULL,
    f_icon INT NOT NULL,
    f_sort INT NOT NULL,
    f_updateTime DATETIME NOT NULL DEFAULT GETDATE()
);
