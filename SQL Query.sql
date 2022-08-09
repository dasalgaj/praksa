CREATE TABLE Users
(
	UserID int IDENTITY(1,1),
	Email VARCHAR(60),
	Lozinka VARCHAR(60)

	primary key (UserID)
);