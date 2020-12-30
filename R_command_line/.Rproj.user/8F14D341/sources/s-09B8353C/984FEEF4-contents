
--- Check SQL environment configuration is ready for running extrenal R script


--Check external script status
sp_configure


-- Enable extrenal script feature
EXEC sp_configure  'external scripts enabled', 1
RECONFIGURE WITH OVERRIDE




-- Verify extenal script launching is running

EXECUTE sp_configure  'external scripts enabled'

-- Open the Services panel or SQL Server Configuration Manager, and verify SQL Server Launchpad 
--service is running. You should have one service for every database engine instance that has R 
--or Python installed.


-- Verify sp execute sciript for R is working

EXEC sp_execute_external_script  @language =N'R',
@script=N'
OutputDataSet <- InputDataSet;
',
@input_data_1 =N'SELECT 1 AS hello'
WITH RESULT SETS (([hello] int not null));
GO





03 ---- Create table to store the models
use exercises;
go

drop table if exists iris_models
go

create table iris_models(
	[id] varchar(30) not null default ('new model') primary key,
	[value] varbinary(max) not null
);
go




-- 04-create-stored-proc-generate-model.sql

use exercises;
go

drop procedure if exists dbo.sp_iris_model_generator;
go

create procedure dbo.sp_iris_model_generator
as
begin
	execute sp_execute_external_script
	@language = N'R',
	@script = N'
	
	library(caret)
    library(randomForest)

	
	classifier_RF <- randomForest(x = InputDataSet[, -5],
								  y = InputDataSet$Species)


	OutputDataSet <- data.frame(payload = as.raw(serialize(classifier_RF, connection=NULL)));
	

	',
	@input_data_1 = N'select 
					* from Iris;'
	with result sets ((model varbinary(max)));
end;




-----------------------------


--05-generate-model.sql

use exercises;
go

insert into iris_models([value])
exec sp_iris_model_generator;

--update cdr_models 
--set [id] = 'DecisionForest'
--where [id] = 'new model';

select * from iris_models;
go


----------------------------------
-- Create store procedure to predict Iris type

use exercises;
go

drop procedure if exists dbo.sp_predict_iris;
go


create procedure dbo.sp_predict_iris (@inquery nvarchar(max))
as
begin
	declare @serialize_iris_model varbinary(max) = 
	(select [value] from iris_models
	where [id] = 'new model');

execute sp_execute_external_script
@language = N'R',
@script = N'

library(caret)
library(randomForest)

classifier_RF <- unserialize(serialize_iris_model)


#predict the test dataset

predict_iris <- predict(classifier_RF, newdata = InputDataSet[1:4])

OutputDataSet <- cbind(InputDataSet, data.frame(predict_iris)


)

',
@input_data_1 = @inquery,
	@params = N'@serialize_iris_model varbinary(max)',
	@serialize_iris_model = @serialize_iris_model
	with result sets ((
						"Sepal.Length" float,
						"Sepal.Width" float,
						"Petal.Length" float,
						"Petal.Width" float,
						"Species" varchar(255),
						"predict_iris" varchar(255)));
end;
go

---------------------------------------------


---- Predict new dataset
use exercises;
go

exec dbo.sp_predict_iris
@inquery = N'SELECT top 20
		[Sepal.Length]
		,[Sepal.Width]
		,[Petal.Length]
		,[Petal.Width]
		,[Species]
  FROM [Iris]

  order by NEWID();'
;
GO