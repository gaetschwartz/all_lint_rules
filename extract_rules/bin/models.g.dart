// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Diff _$$_DiffFromJson(Map<String, dynamic> json) => _$_Diff(
      (json['oldRules'] as List<dynamic>).map((e) => e as String).toList(),
      (json['newRules'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_DiffToJson(_$_Diff instance) => <String, dynamic>{
      'oldRules': instance.oldRules,
      'newRules': instance.newRules,
    };

_$_RulesDiff _$$_RulesDiffFromJson(Map<String, dynamic> json) => _$_RulesDiff(
      addedRules: (json['addedRules'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      removedRules: (json['removedRules'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$_RulesDiffToJson(_$_RulesDiff instance) =>
    <String, dynamic>{
      'addedRules': instance.addedRules,
      'removedRules': instance.removedRules,
    };
