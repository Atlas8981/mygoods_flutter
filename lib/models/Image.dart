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

// ignore_for_file: public_member_api_docs, file_names, unnecessary_new, prefer_if_null_operators, prefer_const_constructors, slash_for_doc_comments, annotate_overrides, non_constant_identifier_names, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unnecessary_const, dead_code

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Image type in your schema. */
@immutable
class Image extends Model {
  static const classType = const _ImageModelType();
  final String id;
  final String? _imageName;
  final String? _imageUrl;
  final String? _itemID;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get imageName {
    return _imageName;
  }
  
  String? get imageUrl {
    return _imageUrl;
  }
  
  String get itemID {
    try {
      return _itemID!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Image._internal({required this.id, imageName, imageUrl, required itemID, createdAt, updatedAt}): _imageName = imageName, _imageUrl = imageUrl, _itemID = itemID, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Image({String? id, String? imageName, String? imageUrl, required String itemID}) {
    return Image._internal(
      id: id == null ? UUID.getUUID() : id,
      imageName: imageName,
      imageUrl: imageUrl,
      itemID: itemID);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Image &&
      id == other.id &&
      _imageName == other._imageName &&
      _imageUrl == other._imageUrl &&
      _itemID == other._itemID;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Image {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("imageName=" + "$_imageName" + ", ");
    buffer.write("imageUrl=" + "$_imageUrl" + ", ");
    buffer.write("itemID=" + "$_itemID" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Image copyWith({String? id, String? imageName, String? imageUrl, String? itemID}) {
    return Image._internal(
      id: id ?? this.id,
      imageName: imageName ?? this.imageName,
      imageUrl: imageUrl ?? this.imageUrl,
      itemID: itemID ?? this.itemID);
  }
  
  Image.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _imageName = json['imageName'],
      _imageUrl = json['imageUrl'],
      _itemID = json['itemID'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'imageName': _imageName, 'imageUrl': _imageUrl, 'itemID': _itemID, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "image.id");
  static final QueryField IMAGENAME = QueryField(fieldName: "imageName");
  static final QueryField IMAGEURL = QueryField(fieldName: "imageUrl");
  static final QueryField ITEMID = QueryField(fieldName: "itemID");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Image";
    modelSchemaDefinition.pluralName = "Images";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Image.IMAGENAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Image.IMAGEURL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Image.ITEMID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ImageModelType extends ModelType<Image> {
  const _ImageModelType();
  
  @override
  Image fromJson(Map<String, dynamic> jsonData) {
    return Image.fromJson(jsonData);
  }
}