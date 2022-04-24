1. Setup Hive
	await Hive.initFlutter(path);

2. Create Hive Model
	create a model class
	transform model class
		modify model class
			part modelname.g.dart
			@HiveType() and HiveField()
		generate model adapter
			flutter packages pub run build_runner build
		register model class adapter
			Hive.registerAdapter(adapterClass)
	 
3. Use CRUD Operations

4. Connect to UI