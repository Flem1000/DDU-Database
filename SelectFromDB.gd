extends Node2D

var database = PostgreSQLClient.new()

var user = "fkvnahsx"
var password = "gWfgi4V-8O98JHE8JPv1sxXxIBru4zLC"
var host = "cornelius.db.elephantsql.com"
var port = 5432
var databaseConnection = "fkvnahsx"


# Called when the node enters the scene tree for the first time.
func _ready():
	#database.connect("connection_established", self, "selectFromDB")
	database.connect("connection_error", self, "error")
	database.connect("connection_closed", self, "closedConnection")
	database.connect_to_host("postgresql://%s:%s@%s:%d/%s" % [user, password, host, port, databaseConnection])

func selectFromDB():
	print("running select query")
	var data = database.execute("""
		BEGIN;
		SElECT * FROM test;
		commit;
	""")
	
	var return_data = ""
	
	for i in data[1].data_row:
		return_data += str(i) + "\t"
		return_data += "\n"
		print(i)
		$Label11.text = str(return_data)

	
func insertIntoDB(id,name,score,user_password):
	print("running insert query")
	var data = database.execute("""
		BEGIN;
		INSERT INTO test (id, name, score, password) values (%s, '%s', %s, '%s');
		commit;
	""" % [id, name, score, user_password])
	
func updateDB(name, score):
	print("running update query")
	var data = database.execute("""
		BEGIN;
		update test set score = %s where name = '%s';
		commit;
	""" % [score, name])

func login(name, user_password):
	print("logging in")
	var data = database.execute("""
		BEGIN;
		SElECT score FROM test where name = '%s' AND password = '%s';
		commit;
	""" % [name, user_password])
	
	for i in data[1].data_row:
		print(i)
		$Label10.text = str(i)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	database.poll()
	
func closedConnection():
	print("database has closed!")

func _exit_tree():
	database.close()


func _on_Button2_button_down():
	selectFromDB()
	pass # Replace with function body.


func _on_Button_button_down():
	insertIntoDB($TextEdit.text,$TextEdit2.text,$TextEdit3.text,$TextEdit4.text)
	pass # Replace with function body.


func _on_Button3_button_down():
	updateDB($TextEdit2.text,$TextEdit3.text)


func _on_Button4_button_down():
	login($TextEdit5.text,$TextEdit6.text)
