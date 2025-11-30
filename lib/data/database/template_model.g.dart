// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTemplateModelCollection on Isar {
  IsarCollection<TemplateModel> get templateModels => this.collection();
}

const TemplateModelSchema = CollectionSchema(
  name: r'TemplateModel',
  id: -6674148670052366061,
  properties: {
    r'aspectRatio': PropertySchema(
      id: 0,
      name: r'aspectRatio',
      type: IsarType.double,
    ),
    r'canvasHeight': PropertySchema(
      id: 1,
      name: r'canvasHeight',
      type: IsarType.double,
    ),
    r'canvasWidth': PropertySchema(
      id: 2,
      name: r'canvasWidth',
      type: IsarType.double,
    )
  },
  estimateSize: _templateModelEstimateSize,
  serialize: _templateModelSerialize,
  deserialize: _templateModelDeserialize,
  deserializeProp: _templateModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'cells': LinkSchema(
      id: -2182717908812851706,
      name: r'cells',
      target: r'CellModel',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _templateModelGetId,
  getLinks: _templateModelGetLinks,
  attach: _templateModelAttach,
  version: '3.1.0',
);

int _templateModelEstimateSize(
  TemplateModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _templateModelSerialize(
  TemplateModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.aspectRatio);
  writer.writeDouble(offsets[1], object.canvasHeight);
  writer.writeDouble(offsets[2], object.canvasWidth);
}

TemplateModel _templateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TemplateModel();
  object.aspectRatio = reader.readDouble(offsets[0]);
  object.canvasHeight = reader.readDouble(offsets[1]);
  object.canvasWidth = reader.readDouble(offsets[2]);
  object.id = id;
  return object;
}

P _templateModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _templateModelGetId(TemplateModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _templateModelGetLinks(TemplateModel object) {
  return [object.cells];
}

void _templateModelAttach(
    IsarCollection<dynamic> col, Id id, TemplateModel object) {
  object.id = id;
  object.cells.attach(col, col.isar.collection<CellModel>(), r'cells', id);
}

extension TemplateModelQueryWhereSort
    on QueryBuilder<TemplateModel, TemplateModel, QWhere> {
  QueryBuilder<TemplateModel, TemplateModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TemplateModelQueryWhere
    on QueryBuilder<TemplateModel, TemplateModel, QWhereClause> {
  QueryBuilder<TemplateModel, TemplateModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TemplateModelQueryFilter
    on QueryBuilder<TemplateModel, TemplateModel, QFilterCondition> {
  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      aspectRatioEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aspectRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      aspectRatioGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aspectRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      aspectRatioLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aspectRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      aspectRatioBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aspectRatio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      canvasHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canvasHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      canvasHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'canvasHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      canvasHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'canvasHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      canvasHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'canvasHeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      canvasWidthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canvasWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      canvasWidthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'canvasWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      canvasWidthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'canvasWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      canvasWidthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'canvasWidth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TemplateModelQueryObject
    on QueryBuilder<TemplateModel, TemplateModel, QFilterCondition> {}

extension TemplateModelQueryLinks
    on QueryBuilder<TemplateModel, TemplateModel, QFilterCondition> {
  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition> cells(
      FilterQuery<CellModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'cells');
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      cellsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'cells', length, true, length, true);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      cellsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'cells', 0, true, 0, true);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      cellsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'cells', 0, false, 999999, true);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      cellsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'cells', 0, true, length, include);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      cellsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'cells', length, include, 999999, true);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterFilterCondition>
      cellsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'cells', lower, includeLower, upper, includeUpper);
    });
  }
}

extension TemplateModelQuerySortBy
    on QueryBuilder<TemplateModel, TemplateModel, QSortBy> {
  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy> sortByAspectRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aspectRatio', Sort.asc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy>
      sortByAspectRatioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aspectRatio', Sort.desc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy>
      sortByCanvasHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasHeight', Sort.asc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy>
      sortByCanvasHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasHeight', Sort.desc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy> sortByCanvasWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasWidth', Sort.asc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy>
      sortByCanvasWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasWidth', Sort.desc);
    });
  }
}

extension TemplateModelQuerySortThenBy
    on QueryBuilder<TemplateModel, TemplateModel, QSortThenBy> {
  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy> thenByAspectRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aspectRatio', Sort.asc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy>
      thenByAspectRatioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aspectRatio', Sort.desc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy>
      thenByCanvasHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasHeight', Sort.asc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy>
      thenByCanvasHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasHeight', Sort.desc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy> thenByCanvasWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasWidth', Sort.asc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy>
      thenByCanvasWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasWidth', Sort.desc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension TemplateModelQueryWhereDistinct
    on QueryBuilder<TemplateModel, TemplateModel, QDistinct> {
  QueryBuilder<TemplateModel, TemplateModel, QDistinct>
      distinctByAspectRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aspectRatio');
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QDistinct>
      distinctByCanvasHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canvasHeight');
    });
  }

  QueryBuilder<TemplateModel, TemplateModel, QDistinct>
      distinctByCanvasWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canvasWidth');
    });
  }
}

extension TemplateModelQueryProperty
    on QueryBuilder<TemplateModel, TemplateModel, QQueryProperty> {
  QueryBuilder<TemplateModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TemplateModel, double, QQueryOperations> aspectRatioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aspectRatio');
    });
  }

  QueryBuilder<TemplateModel, double, QQueryOperations> canvasHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canvasHeight');
    });
  }

  QueryBuilder<TemplateModel, double, QQueryOperations> canvasWidthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canvasWidth');
    });
  }
}
