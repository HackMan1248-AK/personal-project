/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;

/** This is an auto generated class representing the Task type in your schema. */
class Task extends amplify_core.Model {
  static const classType = const _TaskModelType();
  final String id;
  final String? _name;
  final String? _category;
  final int? _difficulty;
  final int? _timeIntensive;
  final String? _fromTime;
  final String? _toTime;
  final amplify_core.TemporalDate? _fromDate;
  final amplify_core.TemporalDate? _toDate;
  final amplify_core.TemporalDateTime? _createdAt;
  final bool? _completed;
  final amplify_core.TemporalDateTime? _updatedAt;
  final int? _version;

  @override
  getInstanceType() => classType;

  @Deprecated(
    '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.',
  )
  @override
  String getId() => id;

  TaskModelIdentifier get modelIdentifier {
    return TaskModelIdentifier(id: id);
  }

  String get name {
    try {
      return _name!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
        amplify_core
            .AmplifyExceptionMessages
            .codeGenRequiredFieldForceCastExceptionMessage,
        recoverySuggestion: amplify_core
            .AmplifyExceptionMessages
            .codeGenRequiredFieldForceCastRecoverySuggestion,
        underlyingException: e.toString(),
      );
    }
  }

  String? get category {
    return _category;
  }

  int? get difficulty {
    return _difficulty;
  }

  int? get timeIntensive {
    return _timeIntensive;
  }

  String? get fromTime {
    return _fromTime;
  }

  String? get toTime {
    return _toTime;
  }

  amplify_core.TemporalDate? get fromDate {
    return _fromDate;
  }

  amplify_core.TemporalDate? get toDate {
    return _toDate;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  bool get completed {
    return _completed ?? false;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  int get version => _version!;

  const Task._internal({
    required this.id,
    required name,
    category,
    difficulty,
    timeIntensive,
    fromTime,
    toTime,
    fromDate,
    toDate,
    createdAt,
    required completed,
    updatedAt,
    version,
  }) : _name = name,
       _category = category,
       _difficulty = difficulty,
       _timeIntensive = timeIntensive,
       _fromTime = fromTime,
       _toTime = toTime,
       _fromDate = fromDate,
       _toDate = toDate,
       _createdAt = createdAt,
       _completed = completed,
       _updatedAt = updatedAt,
       _version = version;

  factory Task({
    String? id,
    required String name,
    String? category,
    int? difficulty,
    int? timeIntensive,
    String? fromTime,
    String? toTime,
    amplify_core.TemporalDate? fromDate,
    amplify_core.TemporalDate? toDate,
    amplify_core.TemporalDateTime? createdAt,
    required bool completed,
    int? version,
  }) {
    return Task._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      category: category,
      difficulty: difficulty,
      timeIntensive: timeIntensive,
      fromTime: fromTime,
      toTime: toTime,
      fromDate: fromDate,
      toDate: toDate,
      createdAt: createdAt,
      completed: completed,
      version: version,
    );
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Task &&
        id == other.id &&
        _name == other._name &&
        _category == other._category &&
        _difficulty == other._difficulty &&
        _timeIntensive == other._timeIntensive &&
        _fromTime == other._fromTime &&
        _toTime == other._toTime &&
        _fromDate == other._fromDate &&
        _toDate == other._toDate &&
        _createdAt == other._createdAt &&
        _completed == other._completed;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Task {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write(
      "difficulty=" +
          (_difficulty != null ? _difficulty.toString() : "null") +
          ", ",
    );
    buffer.write(
      "timeIntensive=" +
          (_timeIntensive != null ? _timeIntensive.toString() : "null") +
          ", ",
    );
    buffer.write("fromTime=" + "$_fromTime" + ", ");
    buffer.write("toTime=" + "$_toTime" + ", ");
    buffer.write(
      "fromDate=" + (_fromDate != null ? _fromDate.format() : "null") + ", ",
    );
    buffer.write(
      "toDate=" + (_toDate != null ? _toDate.format() : "null") + ", ",
    );
    buffer.write(
      "createdAt=" + (_createdAt != null ? _createdAt.format() : "null") + ", ",
    );
    buffer.write(
      "completed=" +
          (_completed != null ? _completed.toString() : "null") +
          ", ",
    );
    buffer.write(
      "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"),
    );
    buffer.write("}");

    return buffer.toString();
  }

  Task copyWith({
    String? name,
    String? category,
    int? difficulty,
    int? timeIntensive,
    String? fromTime,
    String? toTime,
    amplify_core.TemporalDate? fromDate,
    amplify_core.TemporalDate? toDate,
    amplify_core.TemporalDateTime? createdAt,
    bool? completed,
  }) {
    return Task._internal(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      timeIntensive: timeIntensive ?? this.timeIntensive,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      createdAt: createdAt ?? this.createdAt,
      completed: completed ?? this.completed,
    );
  }

  Task copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String?>? category,
    ModelFieldValue<int?>? difficulty,
    ModelFieldValue<int?>? timeIntensive,
    ModelFieldValue<String?>? fromTime,
    ModelFieldValue<String?>? toTime,
    ModelFieldValue<amplify_core.TemporalDate?>? fromDate,
    ModelFieldValue<amplify_core.TemporalDate?>? toDate,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<bool>? completed,
  }) {
    return Task._internal(
      id: id,
      name: name == null ? this.name : name.value,
      category: category == null ? this.category : category.value,
      difficulty: difficulty == null ? this.difficulty : difficulty.value,
      timeIntensive: timeIntensive == null
          ? this.timeIntensive
          : timeIntensive.value,
      fromTime: fromTime == null ? this.fromTime : fromTime.value,
      toTime: toTime == null ? this.toTime : toTime.value,
      fromDate: fromDate == null ? this.fromDate : fromDate.value,
      toDate: toDate == null ? this.toDate : toDate.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      completed: completed == null ? this.completed : completed.value,
    );
  }

  Task.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      _name = json['name'],
      _category = json['category'],
      _difficulty = (json['difficulty'] as num?)?.toInt(),
      _timeIntensive = (json['timeIntensive'] as num?)?.toInt(),
      _fromTime = json['fromTime'],
      _toTime = json['toTime'],
      _fromDate = json['fromDate'] != null
          ? amplify_core.TemporalDate.fromString(json['fromDate'])
          : null,
      _toDate = json['toDate'] != null
          ? amplify_core.TemporalDate.fromString(json['toDate'])
          : null,
      _createdAt = json['createdAt'] != null
          ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
          : null,
      _completed = json['completed'],
      _updatedAt = json['updatedAt'] != null
          ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
          : null,
      _version = (json['_version'] as num?)?.toInt();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': _name,
    'category': _category,
    'difficulty': _difficulty,
    'timeIntensive': _timeIntensive,
    'fromTime': _fromTime,
    'toTime': _toTime,
    'fromDate': _fromDate?.format(),
    'toDate': _toDate?.format(),
    'createdAt': _createdAt?.format(),
    'completed': _completed,
    'updatedAt': _updatedAt?.format(),
    '_version': _version,
  };

  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'category': _category,
    'difficulty': _difficulty,
    'timeIntensive': _timeIntensive,
    'fromTime': _fromTime,
    'toTime': _toTime,
    'fromDate': _fromDate,
    'toDate': _toDate,
    'createdAt': _createdAt,
    'completed': _completed,
    'updatedAt': _updatedAt,
    '_version': _version,
  };

  static final amplify_core.QueryModelIdentifier<TaskModelIdentifier>
  MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TaskModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final DIFFICULTY = amplify_core.QueryField(fieldName: "difficulty");
  static final TIMEINTENSIVE = amplify_core.QueryField(
    fieldName: "timeIntensive",
  );
  static final FROMTIME = amplify_core.QueryField(fieldName: "fromTime");
  static final TOTIME = amplify_core.QueryField(fieldName: "toTime");
  static final FROMDATE = amplify_core.QueryField(fieldName: "fromDate");
  static final TODATE = amplify_core.QueryField(fieldName: "toDate");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final COMPLETED = amplify_core.QueryField(fieldName: "completed");
  static var schema = amplify_core.Model.defineSchema(
    define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
      modelSchemaDefinition.name = "Task";
      modelSchemaDefinition.pluralName = "Tasks";

      modelSchemaDefinition.authRules = [
        amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.PUBLIC,
          operations: const [
            amplify_core.ModelOperation.CREATE,
            amplify_core.ModelOperation.UPDATE,
            amplify_core.ModelOperation.DELETE,
            amplify_core.ModelOperation.READ,
          ],
        ),
      ];

      modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: Task.NAME,
          isRequired: true,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: Task.CATEGORY,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: Task.DIFFICULTY,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.int,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: Task.TIMEINTENSIVE,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.int,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: Task.FROMTIME,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: Task.TOTIME,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: Task.FROMDATE,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.date,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: Task.TODATE,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.date,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: Task.CREATEDAT,
          isRequired: false,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.field(
          key: Task.COMPLETED,
          isRequired: true,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.bool,
          ),
        ),
      );

      modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
          fieldName: 'updatedAt',
          isRequired: false,
          isReadOnly: true,
          ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime,
          ),
        ),
      );
    },
  );
}

class _TaskModelType extends amplify_core.ModelType<Task> {
  const _TaskModelType();

  @override
  Task fromJson(Map<String, dynamic> jsonData) {
    return Task.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'Task';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Task] in your schema.
 */
class TaskModelIdentifier implements amplify_core.ModelIdentifier<Task> {
  final String id;

  /** Create an instance of TaskModelIdentifier using [id] the primary key. */
  const TaskModelIdentifier({required this.id});

  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{'id': id});

  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap().entries
      .map((entry) => (<String, dynamic>{entry.key: entry.value}))
      .toList();

  @override
  String serializeAsString() => serializeAsMap().values.join('#');

  @override
  String toString() => 'TaskModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TaskModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
