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
import 'package:collection/collection.dart';


/** This is an auto generated class representing the User type in your schema. */
class User extends amplify_core.Model {
  static const classType = const _UserModelType();
  final String id;
  final double? _knowledge;
  final double? _charisma;
  final double? _strength;
  final double? _persistence;
  final double? _level;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final List<Subject>? _subjects;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserModelIdentifier get modelIdentifier {
      return UserModelIdentifier(
        id: id
      );
  }
  
  double get knowledge {
    try {
      return _knowledge!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get charisma {
    try {
      return _charisma!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get strength {
    try {
      return _strength!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get persistence {
    try {
      return _persistence!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get level {
    try {
      return _level!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  List<Subject>? get subjects {
    return _subjects;
  }
  
  const User._internal({required this.id, required knowledge, required charisma, required strength, required persistence, required level, createdAt, updatedAt, subjects}): _knowledge = knowledge, _charisma = charisma, _strength = strength, _persistence = persistence, _level = level, _createdAt = createdAt, _updatedAt = updatedAt, _subjects = subjects;
  
  factory User({String? id, required double knowledge, required double charisma, required double strength, required double persistence, required double level, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, List<Subject>? subjects}) {
    return User._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      knowledge: knowledge,
      charisma: charisma,
      strength: strength,
      persistence: persistence,
      level: level,
      createdAt: createdAt,
      updatedAt: updatedAt,
      subjects: subjects != null ? List<Subject>.unmodifiable(subjects) : subjects);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      id == other.id &&
      _knowledge == other._knowledge &&
      _charisma == other._charisma &&
      _strength == other._strength &&
      _persistence == other._persistence &&
      _level == other._level &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt &&
      DeepCollectionEquality().equals(_subjects, other._subjects);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("knowledge=" + (_knowledge != null ? _knowledge!.toString() : "null") + ", ");
    buffer.write("charisma=" + (_charisma != null ? _charisma!.toString() : "null") + ", ");
    buffer.write("strength=" + (_strength != null ? _strength!.toString() : "null") + ", ");
    buffer.write("persistence=" + (_persistence != null ? _persistence!.toString() : "null") + ", ");
    buffer.write("level=" + (_level != null ? _level!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({double? knowledge, double? charisma, double? strength, double? persistence, double? level, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, List<Subject>? subjects}) {
    return User._internal(
      id: id,
      knowledge: knowledge ?? this.knowledge,
      charisma: charisma ?? this.charisma,
      strength: strength ?? this.strength,
      persistence: persistence ?? this.persistence,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subjects: subjects ?? this.subjects);
  }
  
  User copyWithModelFieldValues({
    ModelFieldValue<double>? knowledge,
    ModelFieldValue<double>? charisma,
    ModelFieldValue<double>? strength,
    ModelFieldValue<double>? persistence,
    ModelFieldValue<double>? level,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt,
    ModelFieldValue<List<Subject>?>? subjects
  }) {
    return User._internal(
      id: id,
      knowledge: knowledge == null ? this.knowledge : knowledge.value,
      charisma: charisma == null ? this.charisma : charisma.value,
      strength: strength == null ? this.strength : strength.value,
      persistence: persistence == null ? this.persistence : persistence.value,
      level: level == null ? this.level : level.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
      subjects: subjects == null ? this.subjects : subjects.value
    );
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _knowledge = (json['knowledge'] as num?)?.toDouble(),
      _charisma = (json['charisma'] as num?)?.toDouble(),
      _strength = (json['strength'] as num?)?.toDouble(),
      _persistence = (json['persistence'] as num?)?.toDouble(),
      _level = (json['level'] as num?)?.toDouble(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _subjects = json['subjects']  is Map
        ? (json['subjects']['items'] is List
          ? (json['subjects']['items'] as List)
              .where((e) => e != null)
              .map((e) => Subject.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['subjects'] is List
          ? (json['subjects'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Subject.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null);
  
  Map<String, dynamic> toJson() => {
    'id': id, 'knowledge': _knowledge, 'charisma': _charisma, 'strength': _strength, 'persistence': _persistence, 'level': _level, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'subjects': _subjects?.map((Subject? e) => e?.toJson()).toList()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'knowledge': _knowledge,
    'charisma': _charisma,
    'strength': _strength,
    'persistence': _persistence,
    'level': _level,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'subjects': _subjects
  };

  static final amplify_core.QueryModelIdentifier<UserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final KNOWLEDGE = amplify_core.QueryField(fieldName: "knowledge");
  static final CHARISMA = amplify_core.QueryField(fieldName: "charisma");
  static final STRENGTH = amplify_core.QueryField(fieldName: "strength");
  static final PERSISTENCE = amplify_core.QueryField(fieldName: "persistence");
  static final LEVEL = amplify_core.QueryField(fieldName: "level");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final SUBJECTS = amplify_core.QueryField(
    fieldName: "subjects",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Subject'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["id"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.KNOWLEDGE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.CHARISMA,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.STRENGTH,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PERSISTENCE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.LEVEL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.SUBJECTS,
      isRequired: false,
      ofModelName: 'Subject',
      associatedKey: Subject.USERID
    ));
  });
}

class _UserModelType extends amplify_core.ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'User';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [User] in your schema.
 */
class UserModelIdentifier implements amplify_core.ModelIdentifier<User> {
  final String id;

  /** Create an instance of UserModelIdentifier using [id] the primary key. */
  const UserModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'UserModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}