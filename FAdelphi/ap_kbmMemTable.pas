{***************************************************************************}
{ This source code was generated automatically by                           }
{ Pas file import tool for Scripter Studio (Pro)                            }
{                                                                           }
{ Scripter Studio and Pas file import tool for Scripter Studio              }
{ written by TMS Software                                                   }
{            copyright © 1997 - 2010                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{***************************************************************************}
unit ap_kbmMemTable;

interface

uses
  SysUtils,
  Classes,
  DB,
  DBCommon,
  SyncObjs,
  Masks,
  kbmMemTypes,
  kbmString,
  kbmList,
  kbmMove,
  kbmMemTable,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatkbmMemTableLibrary = class(TatScripterLibrary)
    procedure __TkbmFieldListDestroy(AMachine: TatVirtualMachine);
    procedure __TkbmFieldListAdd(AMachine: TatVirtualMachine);
    procedure __TkbmFieldListClear(AMachine: TatVirtualMachine);
    procedure __TkbmFieldListIndexOf(AMachine: TatVirtualMachine);
    procedure __TkbmFieldListAssignTo(AMachine: TatVirtualMachine);
    procedure __TkbmFieldListMergeOptionsTo(AMachine: TatVirtualMachine);
    procedure __TkbmFieldListClearOptions(AMachine: TatVirtualMachine);
    procedure __TkbmFieldListGetAsString(AMachine: TatVirtualMachine);
    procedure __GetTkbmFieldListCount(AMachine: TatVirtualMachine);
    procedure __TkbmIndexCreate(AMachine: TatVirtualMachine);
    procedure __TkbmIndexDestroy(AMachine: TatVirtualMachine);
    procedure __TkbmIndexSearchRecordID(AMachine: TatVirtualMachine);
    procedure __TkbmIndexClear(AMachine: TatVirtualMachine);
    procedure __TkbmIndexLoad(AMachine: TatVirtualMachine);
    procedure __TkbmIndexReSort(AMachine: TatVirtualMachine);
    procedure __TkbmIndexRebuild(AMachine: TatVirtualMachine);
    procedure __TkbmIndexRebuildDepending(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexDependantIndexes(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexBase(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexEnabled(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexEnabled(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIsSorted(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexIsSorted(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIsDirty(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexIsDirty(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIsOrdered(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIsFiltered(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexIsFiltered(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIsRange(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexIsRange(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIsFullScope(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIndexType(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexIndexType(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIndexOptions(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexIndexOptions(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIndexFields(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexIndexFields(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIndexFieldList(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexIndexFieldList(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexDataset(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexDataset(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexName(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexName(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexReferences(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexReferences(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexIsRowOrder(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexIsRowOrder(AMachine: TatVirtualMachine);
    procedure __GetTkbmIndexUpdateStatus(AMachine: TatVirtualMachine);
    procedure __SetTkbmIndexUpdateStatus(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesCreate(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesDestroy(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesClear(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesAdd(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesAddIndex(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesDeleteIndex(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesReBuild(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesDelete(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesGet(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesGetIndex(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesEmpty(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesGetByFieldNames(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesEmptyAll(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesReBuildAll(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesMarkAllDirty(AMachine: TatVirtualMachine);
    procedure __TkbmIndexesCount(AMachine: TatVirtualMachine);
    procedure __TkbmCustomStreamFormatCreate(AMachine: TatVirtualMachine);
    procedure __TkbmCustomStreamFormatAssign(AMachine: TatVirtualMachine);
    procedure __TkbmCommonGetDeletedRecordsCount(AMachine: TatVirtualMachine);
    procedure __TkbmCommonGetFieldSize(AMachine: TatVirtualMachine);
    procedure __TkbmCommonGetFieldDataOffset(AMachine: TatVirtualMachine);
    procedure __TkbmCommonCreate(AMachine: TatVirtualMachine);
    procedure __TkbmCommonDestroy(AMachine: TatVirtualMachine);
    procedure __TkbmCommonLock(AMachine: TatVirtualMachine);
    procedure __TkbmCommonUnlock(AMachine: TatVirtualMachine);
    procedure __TkbmCommonGetFieldIsVarLength(AMachine: TatVirtualMachine);
    procedure __TkbmCommonDeAttachAllTables(AMachine: TatVirtualMachine);
    procedure __TkbmCommonAttachTable(AMachine: TatVirtualMachine);
    procedure __TkbmCommonDeAttachTable(AMachine: TatVirtualMachine);
    procedure __TkbmCommonLayoutRecord(AMachine: TatVirtualMachine);
    procedure __TkbmCommonPackRecords(AMachine: TatVirtualMachine);
    procedure __TkbmCommonRecordCount(AMachine: TatVirtualMachine);
    procedure __TkbmCommonDeletedRecordCount(AMachine: TatVirtualMachine);
    procedure __TkbmCommonRollback(AMachine: TatVirtualMachine);
    procedure __TkbmCommonCommit(AMachine: TatVirtualMachine);
    procedure __TkbmCommonIsAnyTableActive(AMachine: TatVirtualMachine);
    procedure __TkbmCommonCloseTables(AMachine: TatVirtualMachine);
    procedure __TkbmCommonRefreshTables(AMachine: TatVirtualMachine);
    procedure __TkbmCommonResyncTables(AMachine: TatVirtualMachine);
    procedure __TkbmCommonEmptyTables(AMachine: TatVirtualMachine);
    procedure __TkbmCommonRebuildIndexes(AMachine: TatVirtualMachine);
    procedure __TkbmCommonMarkIndexesDirty(AMachine: TatVirtualMachine);
    procedure __TkbmCommonUpdateIndexes(AMachine: TatVirtualMachine);
    procedure __TkbmCommonClearIndexes(AMachine: TatVirtualMachine);
    procedure __TkbmCommonIncTransactionLevel(AMachine: TatVirtualMachine);
    procedure __TkbmCommonDecTransactionLevel(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonDataRecordSize(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonRecords(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonRecordID(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonRecordID(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonUniqueRecordID(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonUniqueRecordID(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonDeletedCount(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonDeletedCount(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonAttachMaxCount(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonAttachMaxCount(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonAttachCount(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonStandalone(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonStandalone(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonAutoIncMin(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonAutoIncMin(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonAutoIncMax(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonAutoIncMax(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonPerformance(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonPerformance(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonVersioningMode(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonVersioningMode(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonEnableVersioning(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonEnableVersioning(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonCapacity(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonCapacity(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonIsDataModified(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonIsDataModified(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonTransactionLevel(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonFieldModified(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonFieldModified(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonLanguageID(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonLanguageID(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonSortID(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonSortID(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonSubLanguageID(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonSubLanguageID(AMachine: TatVirtualMachine);
    procedure __GetTkbmCommonLocaleID(AMachine: TatVirtualMachine);
    procedure __SetTkbmCommonLocaleID(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTable__CalcFieldsSize(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTable__ClearBuffers(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTable__SetTempState(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTable__RestoreState(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCreate(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableDestroy(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableUpdateStatus(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCreateBlobStream(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableIsSequenced(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSavePersistent(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableLoadPersistent(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableGetAggregateFieldName(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableGetAggregateFieldOption(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableBuildFieldList(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableFindFieldInList(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableIsFieldListsEqual(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableIsFieldListsBegin(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSetFieldListOptions(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableClearModified(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableDestroyIndexes(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCreateIndexes(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableIsMasterDetailActive(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSwitchToIndex(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCreateFieldAs(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableMoveRecord(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCopyRecord(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableMoveCurRecord(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableGetVersionFieldData(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableGetVersionStatus(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableGetVersionCount(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSetVersionFieldData(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSetVersionStatus(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableResetAutoInc(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableProgress(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCopyRecords(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableAssignRecord(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableLock(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableUnlock(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableUpdateFieldVariables(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCopyFieldProperties(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCopyFieldsProperties(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableExists(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCreateTable(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableEmptyTable(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCreateTableAs(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableDeleteTable(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTablePackTable(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableAddIndex(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableDeleteIndex(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableUpdateIndexes(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableIndexFieldCount(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableStartTransaction(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCommit(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableRollback(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableUndo(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableLoadFromFile(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableLoadFromStream(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableLoadFromFileViaFormat(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableLoadFromStreamViaFormat(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSaveToFile(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSaveToStream(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSaveToFileViaFormat(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSaveToStreamViaFormat(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableLoadFromDataSet(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSaveToDataSet(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableUpdateToDataSet(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSortDefault(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSort(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSortOn(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableLookup(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableLookupByIndex(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableLocate(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSetKey(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableEditKey(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableGotoNearest(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableGotoKey(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableApplyRange(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCancelRange(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSetRangeStart(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableSetRangeEnd(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableEditRangeStart(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableEditRangeEnd(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCheckPoint(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableCheckPointRecord(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableGetRows(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableReset(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableGotoCurrent(AMachine: TatVirtualMachine);
    procedure __TkbmCustomMemTableGroupBy(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTablePersistentSaved(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTablePersistentSaved(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAttachedTo(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableAttachedTo(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAttachedAutoRefresh(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableAttachedAutoRefresh(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTablePerformance(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTablePerformance(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableCurIndex(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIgnoreAutoIncPopulation(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableIgnoreAutoIncPopulation(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAttachMaxCount(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableAttachMaxCount(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAttachCount(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableDesignActivation(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableDesignActivation(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableLanguageID(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableLanguageID(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableSortID(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableSortID(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableSubLanguageID(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableSubLanguageID(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableLocaleID(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableLocaleID(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableCommon(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAutoIncValue(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAutoIncMinValue(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableAutoIncMinValue(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAutoUpdateFieldVariables(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableAutoUpdateFieldVariables(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAllData(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableAllData(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableStoreDataOnForm(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableStoreDataOnForm(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableCommaText(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableCommaText(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableCapacity(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableCapacity(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableDeletedRecordsCount(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIndexFieldNames(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableIndexFieldNames(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIndexName(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableIndexName(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableEnableIndexes(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableEnableIndexes(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAutoAddIndexes(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableAutoAddIndexes(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAutoReposition(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableAutoReposition(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableSortFields(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableSortFields(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableSortOptions(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableSortOptions(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableReadOnly(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableReadOnly(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableStandalone(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableStandalone(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIgnoreReadOnly(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableIgnoreReadOnly(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableRangeActive(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableRangeIgnoreNullKeyValues(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableRangeIgnoreNullKeyValues(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTablePersistentFile(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTablePersistentFile(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTablePersistent(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTablePersistent(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTablePersistentBackup(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTablePersistentBackup(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTablePersistentBackupExt(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTablePersistentBackupExt(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableProgressFlags(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableProgressFlags(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableLoadLimit(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableLoadLimit(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableLoadCount(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableLoadCount(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableLoadedCompletely(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableLoadedCompletely(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableSaveLimit(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableSaveLimit(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableSaveCount(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableSaveCount(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableSavedCompletely(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableSavedCompletely(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableRecalcOnFetch(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableRecalcOnFetch(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIsFieldModified(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableEnableVersioning(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableEnableVersioning(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableVersioningMode(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableVersioningMode(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIsVersioning(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableStatusFilter(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableStatusFilter(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableDeltaHandler(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableDeltaHandler(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIndexes(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIndexByName(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIndexDefs(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableIndexDefs(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIndexFields(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableIndexFields(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableRecalcOnIndex(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableRecalcOnIndex(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableFilterOptions(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableFilterOptions(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableDetailFields(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableDetailFields(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableMasterFields(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableMasterFields(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableMasterSource(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableMasterSource(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableRecordTag(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableRecordTag(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableVersion(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableVersion(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableIsDataModified(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableIsDataModified(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableTransactionLevel(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableTableState(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableTableState(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableDefaultFormat(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableDefaultFormat(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableCommaTextFormat(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableCommaTextFormat(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTablePersistentFormat(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTablePersistentFormat(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableFormFormat(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableFormFormat(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomMemTableAllDataFormat(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomMemTableAllDataFormat(AMachine: TatVirtualMachine);
    procedure __TkbmBlobStreamCreate(AMachine: TatVirtualMachine);
    procedure __TkbmBlobStreamDestroy(AMachine: TatVirtualMachine);
    procedure __TkbmBlobStreamWrite(AMachine: TatVirtualMachine);
    procedure __TkbmBlobStreamTruncate(AMachine: TatVirtualMachine);
    procedure __TkbmCustomDeltaHandlerResolve(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomDeltaHandlerDataSet(AMachine: TatVirtualMachine);
    procedure __SetTkbmCustomDeltaHandlerDataSet(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomDeltaHandlerFieldCount(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomDeltaHandlerOrigValues(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomDeltaHandlerValues(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomDeltaHandlerOrigValuesByName(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomDeltaHandlerValuesByName(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomDeltaHandlerFieldNames(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomDeltaHandlerFields(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomDeltaHandlerRecNo(AMachine: TatVirtualMachine);
    procedure __GetTkbmCustomDeltaHandlerUniqueRecID(AMachine: TatVirtualMachine);
    procedure __StreamToVariant(AMachine: TatVirtualMachine);
    procedure __VariantToStream(AMachine: TatVirtualMachine);
    procedure __IndexOptions2CompareOptions(AMachine: TatVirtualMachine);
    procedure __CompareOptions2IndexOptions(AMachine: TatVirtualMachine);
    procedure __CopyFieldDefs(AMachine: TatVirtualMachine);
    procedure __GetkbmSupportedFieldTypes(AMachine: TatVirtualMachine);
    procedure __GetkbmStringTypes(AMachine: TatVirtualMachine);
    procedure __GetkbmBinaryTypes(AMachine: TatVirtualMachine);
    procedure __GetkbmBlobTypes(AMachine: TatVirtualMachine);
    procedure __GetkbmNonBlobTypes(AMachine: TatVirtualMachine);
    procedure __GetkbmVarLengthNonBlobTypes(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;

  EMemTableErrorClass = class of EMemTableError;
  EMemTableFatalErrorClass = class of EMemTableFatalError;
  EMemTableInvalidRecordClass = class of EMemTableInvalidRecord;
  EMemTableIndexErrorClass = class of EMemTableIndexError;
  EMemTableDupKeyClass = class of EMemTableDupKey;
  EMemTableFilterErrorClass = class of EMemTableFilterError;
  EMemTableLocaleErrorClass = class of EMemTableLocaleError;
  EMemTableInvalidLocaleClass = class of EMemTableInvalidLocale;
  TkbmFieldListClass = class of TkbmFieldList;
  TkbmIndexClass = class of TkbmIndex;
  TkbmIndexesClass = class of TkbmIndexes;
  TkbmCustomStreamFormatClass = class of TkbmCustomStreamFormat;
  TkbmStreamFormatClass = class of TkbmStreamFormat;
  TkbmCSClass = class of TkbmCS;
  TkbmCommonClass = class of TkbmCommon;
  TkbmMasterDataLinkClass = class of TkbmMasterDataLink;
  TkbmCustomMemTableClass = class of TkbmCustomMemTable;
  TkbmMemTableClass = class of TkbmMemTable;
  TkbmBlobStreamClass = class of TkbmBlobStream;
  TkbmCustomDeltaHandlerClass = class of TkbmCustomDeltaHandler;

  TatkbmMemTableDispatcher = class(TatEventDispatcher)
  private
    procedure __TkbmOnFilterIndex( DataSet: TDataSet;  Index: TkbmIndex; var Accept: boolean);
    procedure __TkbmOnUserAggregate( DataSet: TDataSet; const UserFunction: integer; const Count: integer; const Value: double; var Accumulator: double);
    procedure __TkbmOnProgress( DataSet: TDataSet;  Percentage: integer;  Code: TkbmProgressCode);
    procedure __TkbmOnLoadRecord( DataSet: TDataSet; var Accept: boolean);
    procedure __TkbmOnLoadField( DataSet: TDataSet;  FieldNo: integer;  Field: TField);
    procedure __TkbmOnSaveRecord( DataSet: TDataSet; var Accept: boolean);
    procedure __TkbmOnSaveField( DataSet: TDataSet;  FieldNo: integer;  Field: TField);
    procedure __TkbmOnCompressField( DataSet: TDataSet;  Field: TField; const Buffer: PAnsiChar; var Size: longint; var ResultBuffer: PAnsiChar);
    procedure __TkbmOnDecompressField( DataSet: TDataSet;  Field: TField; const Buffer: PAnsiChar; var Size: longint; var ResultBuffer: PAnsiChar);
    procedure __TkbmOnSave( DataSet: TDataSet;  StorageType: TkbmMemTableStorageType;  Stream: TStream);
    procedure __TkbmOnLoad( DataSet: TDataSet;  StorageType: TkbmMemTableStorageType;  Stream: TStream);
    procedure __TkbmOnSetupField( DataSet: TDataSet;  Field: TField; var FieldFlags: byte);
    procedure __TkbmOnSetupFieldProperties( DataSet: TDataSet;  Field: TField);
    procedure __TkbmOnCompress( Dataset: TkbmCustomMemTable;  UnCompressedStream: TStream;  CompressedStream: TStream);
    procedure __TkbmOnDeCompress( Dataset: TkbmCustomMemTable;  CompressedStream: TStream;  DeCompressedStream: TStream);
    procedure __TkbmDeltaHandlerGetValue( ADeltaHandler: TkbmCustomDeltaHandler;  AField: TField; var AValue: variant);
  end;

  TkbmBookmarkWrapper = class(TatRecordWrapper)
  private
    FFlag: TBookmarkFlag;
    FRecordID: TkbmNativeInt;
  public
    constructor Create(ARecord: TkbmBookmark);
    function ObjToRec: TkbmBookmark;
  published
    property Flag: TBookmarkFlag read FFlag write FFlag;
    property RecordID: TkbmNativeInt read FRecordID write FRecordID;
  end;
  
  TkbmUserBookmarkWrapper = class(TatRecordWrapper)
  private
    FDataID: longint;
    FRecordID: TkbmNativeInt;
  public
    constructor Create(ARecord: TkbmUserBookmark);
    function ObjToRec: TkbmUserBookmark;
  published
    property DataID: longint read FDataID write FDataID;
    property RecordID: TkbmNativeInt read FRecordID write FRecordID;
  end;
  

implementation

constructor TkbmBookmarkWrapper.Create(ARecord: TkbmBookmark);
begin
  inherited Create;
  FFlag := ARecord.Flag;
  FRecordID := ARecord.RecordID;
end;

function TkbmBookmarkWrapper.ObjToRec: TkbmBookmark;
begin
  result.Flag := FFlag;
  result.RecordID := FRecordID;
end;

constructor TkbmUserBookmarkWrapper.Create(ARecord: TkbmUserBookmark);
begin
  inherited Create;
  FDataID := ARecord.DataID;
  FRecordID := ARecord.RecordID;
end;

function TkbmUserBookmarkWrapper.ObjToRec: TkbmUserBookmark;
begin
  result.DataID := FDataID;
  result.RecordID := FRecordID;
end;



procedure TatkbmMemTableLibrary.__TkbmFieldListDestroy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmFieldList(CurrentObject).Destroy;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmFieldListAdd(AMachine: TatVirtualMachine);
  var
  Param1: TkbmifoOptions;
  AResult: variant;
begin
  with AMachine do
  begin
IntToSet(Param1, VarToInteger(GetInputArg(1)), SizeOf(Param1));
AResult := Integer(TkbmFieldList(CurrentObject).Add(TField(VarToObject(GetInputArg(0))),Param1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmFieldListClear(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmFieldList(CurrentObject).Clear;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmFieldListIndexOf(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmFieldList(CurrentObject).IndexOf(TField(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmFieldListAssignTo(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmFieldList(CurrentObject).AssignTo(TkbmFieldList(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmFieldListMergeOptionsTo(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmFieldList(CurrentObject).MergeOptionsTo(TkbmFieldList(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmFieldListClearOptions(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmFieldList(CurrentObject).ClearOptions;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmFieldListGetAsString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(TkbmFieldList(CurrentObject).GetAsString);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmFieldListCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmFieldList(CurrentObject).Count));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexCreate(AMachine: TatVirtualMachine);
  var
  Param4: TkbmMemTableCompareOptions;
  AResult: variant;
begin
  with AMachine do
  begin
IntToSet(Param4, VarToInteger(GetInputArg(4)), SizeOf(Param4));
AResult := ObjectToVar(TkbmIndexClass(CurrentClass.ClassRef).Create(TkbmIndex(VarToObject(GetInputArg(0))),VarToStr(GetInputArg(1)),TkbmCustomMemTable(VarToObject(GetInputArg(2))),VarToStr(GetInputArg(3)),Param4,TkbmIndexType(VarToInteger(GetInputArg(5)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexDestroy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).Destroy;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexSearchRecordID(AMachine: TatVirtualMachine);
  var
  Param1: TkbmNativeInt;
  AResult: variant;
begin
  with AMachine do
  begin
Param1 := VarToInteger(GetInputArg(1));
AResult := Integer(TkbmIndex(CurrentObject).SearchRecordID(VarToInteger(GetInputArg(0)),Param1));
    ReturnOutputArg(AResult);
    SetInputArg(1,Integer(Param1));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexClear(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).Clear;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexLoad(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).Load;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexReSort(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).ReSort;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexRebuild(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).Rebuild;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexRebuildDepending(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).RebuildDepending;
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexDependantIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmIndex(CurrentObject).DependantIndexes));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexBase(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmIndex(CurrentObject).Base));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexEnabled(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmIndex(CurrentObject).Enabled);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexEnabled(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).Enabled:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIsSorted(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmIndex(CurrentObject).IsSorted);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexIsSorted(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).IsSorted:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIsDirty(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmIndex(CurrentObject).IsDirty);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexIsDirty(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).IsDirty:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIsOrdered(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmIndex(CurrentObject).IsOrdered);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIsFiltered(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmIndex(CurrentObject).IsFiltered);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexIsFiltered(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).IsFiltered:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIsRange(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmIndex(CurrentObject).IsRange);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexIsRange(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).IsRange:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIsFullScope(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmIndex(CurrentObject).IsFullScope);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIndexType(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmIndex(CurrentObject).IndexType));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexIndexType(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).IndexType:=TkbmIndexType(VarToInteger(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIndexOptions(AMachine: TatVirtualMachine);
var
PropValueSet: TkbmMemTableCompareOptions;
begin
  with AMachine do
  begin
    PropValueSet := TkbmIndex(CurrentObject).IndexOptions;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexIndexOptions(AMachine: TatVirtualMachine);
  var
  TempVar: TkbmMemTableCompareOptions;
begin
  with AMachine do
  begin
    IntToSet(TempVar, VarToInteger(GetInputArg(0)), SizeOf(TempVar));
    TkbmIndex(CurrentObject).IndexOptions:=TempVar;
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIndexFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmIndex(CurrentObject).IndexFields));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexIndexFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).IndexFields:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIndexFieldList(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmIndex(CurrentObject).IndexFieldList));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexIndexFieldList(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).IndexFieldList:=TkbmFieldList(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexDataset(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmIndex(CurrentObject).Dataset));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexDataset(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).Dataset:=TkbmCustomMemTable(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexName(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmIndex(CurrentObject).Name));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexName(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).Name:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexReferences(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmIndex(CurrentObject).References));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexReferences(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).References:=TkbmList(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexIsRowOrder(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmIndex(CurrentObject).IsRowOrder);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexIsRowOrder(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndex(CurrentObject).IsRowOrder:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmIndexUpdateStatus(AMachine: TatVirtualMachine);
var
PropValueSet: TUpdateStatusSet;
begin
  with AMachine do
  begin
    PropValueSet := TkbmIndex(CurrentObject).UpdateStatus;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmIndexUpdateStatus(AMachine: TatVirtualMachine);
  var
  TempVar: TUpdateStatusSet;
begin
  with AMachine do
  begin
    IntToSet(TempVar, VarToInteger(GetInputArg(0)), SizeOf(TempVar));
    TkbmIndex(CurrentObject).UpdateStatus:=TempVar;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TkbmIndexesClass(CurrentClass.ClassRef).Create(TkbmCustomMemTable(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesDestroy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).Destroy;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesClear(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).Clear;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesAdd(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).Add(TIndexDef(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesAddIndex(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).AddIndex(TkbmIndex(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesDeleteIndex(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).DeleteIndex(TkbmIndex(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesReBuild(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).ReBuild(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesDelete(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).Delete(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesGet(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TkbmIndexes(CurrentObject).Get(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesGetIndex(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TkbmIndexes(CurrentObject).GetIndex(VarToInteger(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesEmpty(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).Empty(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesGetByFieldNames(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TkbmIndexes(CurrentObject).GetByFieldNames(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesEmptyAll(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).EmptyAll;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesReBuildAll(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).ReBuildAll;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesMarkAllDirty(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmIndexes(CurrentObject).MarkAllDirty;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmIndexesCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmIndexes(CurrentObject).Count);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomStreamFormatCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TkbmCustomStreamFormatClass(CurrentClass.ClassRef).Create(TComponent(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomStreamFormatAssign(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomStreamFormat(CurrentObject).Assign(TPersistent(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonGetDeletedRecordsCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCommon(CurrentObject).GetDeletedRecordsCount);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonGetFieldSize(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCommon(CurrentObject).GetFieldSize(TFieldType(VarToInteger(GetInputArg(0))),VarToInteger(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonGetFieldDataOffset(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCommon(CurrentObject).GetFieldDataOffset(TField(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TkbmCommonClass(CurrentClass.ClassRef).Create(TkbmCustomMemTable(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonDestroy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).Destroy;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonLock(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).Lock;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonUnlock(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).Unlock;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonGetFieldIsVarLength(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCommon(CurrentObject).GetFieldIsVarLength(TFieldType(VarToInteger(GetInputArg(0))),VarToInteger(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonDeAttachAllTables(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).DeAttachAllTables(TkbmCustomMemTable(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonAttachTable(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).AttachTable(TkbmCustomMemTable(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonDeAttachTable(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).DeAttachTable(TkbmCustomMemTable(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonLayoutRecord(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).LayoutRecord(VarToInteger(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonPackRecords(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).PackRecords;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonRecordCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCommon(CurrentObject).RecordCount);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonDeletedRecordCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCommon(CurrentObject).DeletedRecordCount);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonRollback(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).Rollback;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonCommit(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).Commit;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonIsAnyTableActive(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCommon(CurrentObject).IsAnyTableActive;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonCloseTables(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).CloseTables(TkbmCustomMemTable(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonRefreshTables(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).RefreshTables(TkbmCustomMemTable(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonResyncTables(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).ResyncTables;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonEmptyTables(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).EmptyTables;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonRebuildIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).RebuildIndexes;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonMarkIndexesDirty(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).MarkIndexesDirty;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonUpdateIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).UpdateIndexes;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonClearIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).ClearIndexes;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonIncTransactionLevel(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).IncTransactionLevel;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCommonDecTransactionLevel(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).DecTransactionLevel;
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonDataRecordSize(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).DataRecordSize));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonRecords(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCommon(CurrentObject).Records));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonRecordID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).RecordID));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonRecordID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).RecordID:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonUniqueRecordID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).UniqueRecordID));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonUniqueRecordID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).UniqueRecordID:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonDeletedCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).DeletedCount));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonDeletedCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).DeletedCount:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonAttachMaxCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).AttachMaxCount));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonAttachMaxCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).AttachMaxCount:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonAttachCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).AttachCount));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonStandalone(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCommon(CurrentObject).Standalone);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonStandalone(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).Standalone:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonAutoIncMin(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).AutoIncMin));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonAutoIncMin(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).AutoIncMin:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonAutoIncMax(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).AutoIncMax));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonAutoIncMax(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).AutoIncMax:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonPerformance(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).Performance));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonPerformance(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).Performance:=TkbmPerformance(VarToInteger(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonVersioningMode(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).VersioningMode));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonVersioningMode(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).VersioningMode:=TkbmVersioningMode(VarToInteger(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonEnableVersioning(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCommon(CurrentObject).EnableVersioning);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonEnableVersioning(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).EnableVersioning:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonCapacity(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).Capacity));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonCapacity(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).Capacity:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonIsDataModified(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCommon(CurrentObject).IsDataModified);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonIsDataModified(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).IsDataModified:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonTransactionLevel(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).TransactionLevel));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonFieldModified(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCommon(CurrentObject).FieldModified[VarToInteger(GetArrayIndex(0))]);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonFieldModified(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).FieldModified[VarToInteger(GetArrayIndex(0))]:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonLanguageID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).LanguageID));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonLanguageID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).LanguageID:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonSortID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).SortID));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonSortID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).SortID:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonSubLanguageID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).SubLanguageID));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonSubLanguageID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).SubLanguageID:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCommonLocaleID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCommon(CurrentObject).LocaleID));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCommonLocaleID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCommon(CurrentObject).LocaleID:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTable__CalcFieldsSize(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCustomMemTable(CurrentObject).__CalcFieldsSize);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTable__ClearBuffers(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).__ClearBuffers;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTable__SetTempState(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCustomMemTable(CurrentObject).__SetTempState(TDataSetState(VarToInteger(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTable__RestoreState(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).__RestoreState(TDataSetState(VarToInteger(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TkbmCustomMemTableClass(CurrentClass.ClassRef).Create(TComponent(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableDestroy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Destroy;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableUpdateStatus(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCustomMemTable(CurrentObject).UpdateStatus);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCreateBlobStream(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TkbmCustomMemTable(CurrentObject).CreateBlobStream(TField(VarToObject(GetInputArg(0))),TBlobStreamMode(VarToInteger(GetInputArg(1)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableIsSequenced(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).IsSequenced;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSavePersistent(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SavePersistent;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableLoadPersistent(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).LoadPersistent;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableGetAggregateFieldName(AMachine: TatVirtualMachine);
  var
  Param1: TkbmifoOptions;
  AResult: variant;
begin
  with AMachine do
  begin
IntToSet(Param1, VarToInteger(GetInputArg(1)), SizeOf(Param1));
AResult := string(TkbmCustomMemTableClass(CurrentClass.ClassRef).GetAggregateFieldName(VarToStr(GetInputArg(0)),Param1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableGetAggregateFieldOption(AMachine: TatVirtualMachine);
  var
  AResultSet: TkbmifoOptions;
  AResult: variant;
begin
  with AMachine do
  begin
AResultSet := TkbmCustomMemTableClass(CurrentClass.ClassRef).GetAggregateFieldOption(VarToStr(GetInputArg(0)));
AResult := IntFromSet(AResultSet, SizeOf(AResultSet));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableBuildFieldList(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      3: TkbmCustomMemTable(CurrentObject).BuildFieldList(TDataSet(VarToObject(GetInputArg(0))),TkbmFieldList(VarToObject(GetInputArg(1))),VarToStr(GetInputArg(2)));
      4: TkbmCustomMemTable(CurrentObject).BuildFieldList(TDataSet(VarToObject(GetInputArg(0))),TkbmFieldList(VarToObject(GetInputArg(1))),VarToStr(GetInputArg(2)),GetInputArg(3));
    end;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableFindFieldInList(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TkbmCustomMemTable(CurrentObject).FindFieldInList(TkbmFieldList(VarToObject(GetInputArg(0))),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableIsFieldListsEqual(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).IsFieldListsEqual(TkbmFieldList(VarToObject(GetInputArg(0))),TkbmFieldList(VarToObject(GetInputArg(1))),GetInputArg(2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableIsFieldListsBegin(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).IsFieldListsBegin(TkbmFieldList(VarToObject(GetInputArg(0))),TkbmFieldList(VarToObject(GetInputArg(1))),GetInputArg(2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSetFieldListOptions(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SetFieldListOptions(TkbmFieldList(VarToObject(GetInputArg(0))),TkbmifoOption(VarToInteger(GetInputArg(1))),VarToStr(GetInputArg(2)));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableClearModified(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).ClearModified;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableDestroyIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).DestroyIndexes;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCreateIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).CreateIndexes;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableIsMasterDetailActive(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).IsMasterDetailActive;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSwitchToIndex(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SwitchToIndex(TkbmIndex(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCreateFieldAs(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := ObjectToVar(TkbmCustomMemTable(CurrentObject).CreateFieldAs(TField(VarToObject(GetInputArg(0)))));
2: AResult := ObjectToVar(TkbmCustomMemTable(CurrentObject).CreateFieldAs(TField(VarToObject(GetInputArg(0))),GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableMoveRecord(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).MoveRecord(VarToInteger(GetInputArg(0)),VarToInteger(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCopyRecord(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).CopyRecord(VarToInteger(GetInputArg(0)),VarToInteger(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableMoveCurRecord(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).MoveCurRecord(VarToInteger(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableGetVersionFieldData(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).GetVersionFieldData(TField(VarToObject(GetInputArg(0))),VarToInteger(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableGetVersionStatus(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCustomMemTable(CurrentObject).GetVersionStatus(VarToInteger(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableGetVersionCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCustomMemTable(CurrentObject).GetVersionCount);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSetVersionFieldData(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).SetVersionFieldData(TField(VarToObject(GetInputArg(0))),VarToInteger(GetInputArg(1)),GetInputArg(2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSetVersionStatus(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCustomMemTable(CurrentObject).SetVersionStatus(VarToInteger(GetInputArg(0)),TUpdateStatus(VarToInteger(GetInputArg(1)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableResetAutoInc(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).ResetAutoInc;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableProgress(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Progress(VarToInteger(GetInputArg(0)),TkbmProgressCode(VarToInteger(GetInputArg(1))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCopyRecords(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCustomMemTable(CurrentObject).CopyRecords(TDataSet(VarToObject(GetInputArg(0))),TDataSet(VarToObject(GetInputArg(1))),VarToInteger(GetInputArg(2)),GetInputArg(3),GetInputArg(4)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableAssignRecord(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).AssignRecord(TDataSet(VarToObject(GetInputArg(0))),TDataSet(VarToObject(GetInputArg(1))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableLock(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Lock;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableUnlock(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Unlock;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableUpdateFieldVariables(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).UpdateFieldVariables;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCopyFieldProperties(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).CopyFieldProperties(TField(VarToObject(GetInputArg(0))),TField(VarToObject(GetInputArg(1))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCopyFieldsProperties(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).CopyFieldsProperties(TDataSet(VarToObject(GetInputArg(0))),TDataSet(VarToObject(GetInputArg(1))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableExists(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).Exists;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCreateTable(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).CreateTable;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableEmptyTable(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).EmptyTable;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCreateTableAs(AMachine: TatVirtualMachine);
  var
  Param1: TkbmMemTableCopyTableOptions;
begin
  with AMachine do
  begin
IntToSet(Param1, VarToInteger(GetInputArg(1)), SizeOf(Param1));
    TkbmCustomMemTable(CurrentObject).CreateTableAs(TDataSet(VarToObject(GetInputArg(0))),Param1);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableDeleteTable(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).DeleteTable;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTablePackTable(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).PackTable;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableAddIndex(AMachine: TatVirtualMachine);
  var
  Param2: TIndexOptions;
  AResult: variant;
begin
  with AMachine do
  begin
IntToSet(Param2, VarToInteger(GetInputArg(2)), SizeOf(Param2));
AResult := ObjectToVar(TkbmCustomMemTable(CurrentObject).AddIndex(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableDeleteIndex(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).DeleteIndex(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableUpdateIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).UpdateIndexes;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableIndexFieldCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCustomMemTable(CurrentObject).IndexFieldCount);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableStartTransaction(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).StartTransaction;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCommit(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Commit;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableRollback(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Rollback;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableUndo(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Undo;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableLoadFromFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).LoadFromFile(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableLoadFromStream(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).LoadFromStream(TStream(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableLoadFromFileViaFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).LoadFromFileViaFormat(VarToStr(GetInputArg(0)),TkbmCustomStreamFormat(VarToObject(GetInputArg(1))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableLoadFromStreamViaFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).LoadFromStreamViaFormat(TStream(VarToObject(GetInputArg(0))),TkbmCustomStreamFormat(VarToObject(GetInputArg(1))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSaveToFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SaveToFile(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSaveToStream(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SaveToStream(TStream(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSaveToFileViaFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SaveToFileViaFormat(VarToStr(GetInputArg(0)),TkbmCustomStreamFormat(VarToObject(GetInputArg(1))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSaveToStreamViaFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SaveToStreamViaFormat(TStream(VarToObject(GetInputArg(0))),TkbmCustomStreamFormat(VarToObject(GetInputArg(1))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableLoadFromDataSet(AMachine: TatVirtualMachine);
  var
  Param1: TkbmMemTableCopyTableOptions;
begin
  with AMachine do
  begin
IntToSet(Param1, VarToInteger(GetInputArg(1)), SizeOf(Param1));
    TkbmCustomMemTable(CurrentObject).LoadFromDataSet(TDataSet(VarToObject(GetInputArg(0))),Param1);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSaveToDataSet(AMachine: TatVirtualMachine);
  var
  Param1: TkbmMemTableCopyTableOptions;
begin
  with AMachine do
  begin
IntToSet(Param1, VarToInteger(GetInputArg(1)), SizeOf(Param1));
    Case InputArgCount of
      1: TkbmCustomMemTable(CurrentObject).SaveToDataSet(TDataSet(VarToObject(GetInputArg(0))));
      2: TkbmCustomMemTable(CurrentObject).SaveToDataSet(TDataSet(VarToObject(GetInputArg(0))),Param1);
    end;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableUpdateToDataSet(AMachine: TatVirtualMachine);
  var
  Param2: TkbmMemTableUpdateFlags;
begin
  with AMachine do
  begin
IntToSet(Param2, VarToInteger(GetInputArg(2)), SizeOf(Param2));
    TkbmCustomMemTable(CurrentObject).UpdateToDataSet(TDataSet(VarToObject(GetInputArg(0))),VarToStr(GetInputArg(1)),Param2);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSortDefault(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SortDefault;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSort(AMachine: TatVirtualMachine);
  var
  Param0: TkbmMemTableCompareOptions;
begin
  with AMachine do
  begin
IntToSet(Param0, VarToInteger(GetInputArg(0)), SizeOf(Param0));
    TkbmCustomMemTable(CurrentObject).Sort(Param0);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSortOn(AMachine: TatVirtualMachine);
  var
  Param1: TkbmMemTableCompareOptions;
begin
  with AMachine do
  begin
IntToSet(Param1, VarToInteger(GetInputArg(1)), SizeOf(Param1));
    TkbmCustomMemTable(CurrentObject).SortOn(VarToStr(GetInputArg(0)),Param1);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableLookup(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).Lookup(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableLookupByIndex(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).LookupByIndex(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)),GetInputArg(3));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableLocate(AMachine: TatVirtualMachine);
  var
  Param2: TLocateOptions;
  AResult: variant;
begin
  with AMachine do
  begin
IntToSet(Param2, VarToInteger(GetInputArg(2)), SizeOf(Param2));
AResult := TkbmCustomMemTable(CurrentObject).Locate(VarToStr(GetInputArg(0)),GetInputArg(1),Param2);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSetKey(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SetKey;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableEditKey(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).EditKey;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableGotoNearest(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).GotoNearest;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableGotoKey(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).GotoKey;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableApplyRange(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).ApplyRange;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCancelRange(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).CancelRange;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSetRangeStart(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SetRangeStart;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableSetRangeEnd(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SetRangeEnd;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableEditRangeStart(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).EditRangeStart;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableEditRangeEnd(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).EditRangeEnd;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCheckPoint(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).CheckPoint;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableCheckPointRecord(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TkbmCustomMemTable(CurrentObject).CheckPointRecord(VarToInteger(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableGetRows(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TkbmCustomMemTable(CurrentObject).GetRows(VarToInteger(GetInputArg(0)),GetInputArg(1),GetInputArg(2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableReset(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Reset;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableGotoCurrent(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).GotoCurrent(TkbmCustomMemTable(VarToObject(GetInputArg(0))));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomMemTableGroupBy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).GroupBy(TkbmCustomMemTable(VarToObject(GetInputArg(0))),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTablePersistentSaved(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).PersistentSaved);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTablePersistentSaved(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).PersistentSaved:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAttachedTo(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).AttachedTo));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableAttachedTo(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).AttachedTo:=TkbmCustomMemTable(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAttachedAutoRefresh(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).AttachedAutoRefresh);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableAttachedAutoRefresh(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).AttachedAutoRefresh:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTablePerformance(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).Performance));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTablePerformance(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Performance:=TkbmPerformance(VarToInteger(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableCurIndex(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).CurIndex));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIgnoreAutoIncPopulation(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).IgnoreAutoIncPopulation);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableIgnoreAutoIncPopulation(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).IgnoreAutoIncPopulation:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAttachMaxCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).AttachMaxCount));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableAttachMaxCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).AttachMaxCount:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAttachCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).AttachCount));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableDesignActivation(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).DesignActivation);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableDesignActivation(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).DesignActivation:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableLanguageID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).LanguageID));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableLanguageID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).LanguageID:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableSortID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).SortID));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableSortID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SortID:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableSubLanguageID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).SubLanguageID));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableSubLanguageID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SubLanguageID:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableLocaleID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).LocaleID));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableLocaleID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).LocaleID:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableCommon(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).Common));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAutoIncValue(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).AutoIncValue));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAutoIncMinValue(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).AutoIncMinValue));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableAutoIncMinValue(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).AutoIncMinValue:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAutoUpdateFieldVariables(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).AutoUpdateFieldVariables);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableAutoUpdateFieldVariables(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).AutoUpdateFieldVariables:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAllData(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).AllData);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableAllData(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).AllData:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableStoreDataOnForm(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).StoreDataOnForm);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableStoreDataOnForm(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).StoreDataOnForm:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableCommaText(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmCustomMemTable(CurrentObject).CommaText));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableCommaText(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).CommaText:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableCapacity(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).Capacity));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableCapacity(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Capacity:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableDeletedRecordsCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).DeletedRecordsCount));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIndexFieldNames(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmCustomMemTable(CurrentObject).IndexFieldNames));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableIndexFieldNames(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).IndexFieldNames:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIndexName(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmCustomMemTable(CurrentObject).IndexName));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableIndexName(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).IndexName:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableEnableIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).EnableIndexes);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableEnableIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).EnableIndexes:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAutoAddIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).AutoAddIndexes);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableAutoAddIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).AutoAddIndexes:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAutoReposition(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).AutoReposition);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableAutoReposition(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).AutoReposition:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableSortFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmCustomMemTable(CurrentObject).SortFields));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableSortFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SortFields:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableSortOptions(AMachine: TatVirtualMachine);
var
PropValueSet: TkbmMemTableCompareOptions;
begin
  with AMachine do
  begin
    PropValueSet := TkbmCustomMemTable(CurrentObject).SortOptions;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableSortOptions(AMachine: TatVirtualMachine);
  var
  TempVar: TkbmMemTableCompareOptions;
begin
  with AMachine do
  begin
    IntToSet(TempVar, VarToInteger(GetInputArg(0)), SizeOf(TempVar));
    TkbmCustomMemTable(CurrentObject).SortOptions:=TempVar;
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableReadOnly(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).ReadOnly);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableReadOnly(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).ReadOnly:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableStandalone(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).Standalone);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableStandalone(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Standalone:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIgnoreReadOnly(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).IgnoreReadOnly);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableIgnoreReadOnly(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).IgnoreReadOnly:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableRangeActive(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).RangeActive);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableRangeIgnoreNullKeyValues(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).RangeIgnoreNullKeyValues);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableRangeIgnoreNullKeyValues(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).RangeIgnoreNullKeyValues:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTablePersistentFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmCustomMemTable(CurrentObject).PersistentFile));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTablePersistentFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).PersistentFile:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTablePersistent(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).Persistent);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTablePersistent(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Persistent:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTablePersistentBackup(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).PersistentBackup);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTablePersistentBackup(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).PersistentBackup:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTablePersistentBackupExt(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmCustomMemTable(CurrentObject).PersistentBackupExt));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTablePersistentBackupExt(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).PersistentBackupExt:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableProgressFlags(AMachine: TatVirtualMachine);
var
PropValueSet: TkbmProgressCodes;
begin
  with AMachine do
  begin
    PropValueSet := TkbmCustomMemTable(CurrentObject).ProgressFlags;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableProgressFlags(AMachine: TatVirtualMachine);
  var
  TempVar: TkbmProgressCodes;
begin
  with AMachine do
  begin
    IntToSet(TempVar, VarToInteger(GetInputArg(0)), SizeOf(TempVar));
    TkbmCustomMemTable(CurrentObject).ProgressFlags:=TempVar;
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableLoadLimit(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).LoadLimit));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableLoadLimit(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).LoadLimit:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableLoadCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).LoadCount));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableLoadCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).LoadCount:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableLoadedCompletely(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).LoadedCompletely);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableLoadedCompletely(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).LoadedCompletely:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableSaveLimit(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).SaveLimit));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableSaveLimit(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SaveLimit:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableSaveCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).SaveCount));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableSaveCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SaveCount:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableSavedCompletely(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).SavedCompletely);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableSavedCompletely(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).SavedCompletely:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableRecalcOnFetch(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).RecalcOnFetch);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableRecalcOnFetch(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).RecalcOnFetch:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIsFieldModified(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).IsFieldModified[VarToInteger(GetArrayIndex(0))]);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableEnableVersioning(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).EnableVersioning);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableEnableVersioning(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).EnableVersioning:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableVersioningMode(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).VersioningMode));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableVersioningMode(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).VersioningMode:=TkbmVersioningMode(VarToInteger(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIsVersioning(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).IsVersioning);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableStatusFilter(AMachine: TatVirtualMachine);
var
PropValueSet: TUpdateStatusSet;
begin
  with AMachine do
  begin
    PropValueSet := TkbmCustomMemTable(CurrentObject).StatusFilter;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableStatusFilter(AMachine: TatVirtualMachine);
  var
  TempVar: TUpdateStatusSet;
begin
  with AMachine do
  begin
    IntToSet(TempVar, VarToInteger(GetInputArg(0)), SizeOf(TempVar));
    TkbmCustomMemTable(CurrentObject).StatusFilter:=TempVar;
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableDeltaHandler(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).DeltaHandler));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableDeltaHandler(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).DeltaHandler:=TkbmCustomDeltaHandler(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIndexes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).Indexes));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIndexByName(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).IndexByName[VarToStr(GetArrayIndex(0))]));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIndexDefs(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).IndexDefs));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableIndexDefs(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).IndexDefs:=TIndexDefs(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIndexFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).IndexFields[VarToInteger(GetArrayIndex(0))]));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableIndexFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).IndexFields[VarToInteger(GetArrayIndex(0))]:=TField(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableRecalcOnIndex(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).RecalcOnIndex);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableRecalcOnIndex(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).RecalcOnIndex:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableFilterOptions(AMachine: TatVirtualMachine);
var
PropValueSet: TFilterOptions;
begin
  with AMachine do
  begin
    PropValueSet := TkbmCustomMemTable(CurrentObject).FilterOptions;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableFilterOptions(AMachine: TatVirtualMachine);
  var
  TempVar: TFilterOptions;
begin
  with AMachine do
  begin
    IntToSet(TempVar, VarToInteger(GetInputArg(0)), SizeOf(TempVar));
    TkbmCustomMemTable(CurrentObject).FilterOptions:=TempVar;
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableDetailFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmCustomMemTable(CurrentObject).DetailFields));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableDetailFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).DetailFields:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableMasterFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmCustomMemTable(CurrentObject).MasterFields));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableMasterFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).MasterFields:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableMasterSource(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).MasterSource));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableMasterSource(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).MasterSource:=TDataSource(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableRecordTag(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).RecordTag));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableRecordTag(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).RecordTag:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableVersion(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmCustomMemTable(CurrentObject).Version));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableVersion(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).Version:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableIsDataModified(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomMemTable(CurrentObject).IsDataModified);
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableIsDataModified(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).IsDataModified:=GetInputArg(0);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableTransactionLevel(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).TransactionLevel));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableTableState(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomMemTable(CurrentObject).TableState));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableTableState(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).TableState:=TkbmState(VarToInteger(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableDefaultFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).DefaultFormat));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableDefaultFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).DefaultFormat:=TkbmCustomStreamFormat(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableCommaTextFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).CommaTextFormat));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableCommaTextFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).CommaTextFormat:=TkbmCustomStreamFormat(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTablePersistentFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).PersistentFormat));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTablePersistentFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).PersistentFormat:=TkbmCustomStreamFormat(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableFormFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).FormFormat));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableFormFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).FormFormat:=TkbmCustomStreamFormat(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomMemTableAllDataFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomMemTable(CurrentObject).AllDataFormat));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomMemTableAllDataFormat(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomMemTable(CurrentObject).AllDataFormat:=TkbmCustomStreamFormat(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmBlobStreamCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TkbmBlobStreamClass(CurrentClass.ClassRef).Create(TBlobField(VarToObject(GetInputArg(0))),TBlobStreamMode(VarToInteger(GetInputArg(1)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmBlobStreamDestroy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmBlobStream(CurrentObject).Destroy;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmBlobStreamWrite(AMachine: TatVirtualMachine);
  var
  Param0: Variant;
  AResult: variant;
begin
  with AMachine do
  begin
Param0 := GetInputArg(0);
AResult := Integer(TkbmBlobStream(CurrentObject).Write(Param0,VarToInteger(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmBlobStreamTruncate(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmBlobStream(CurrentObject).Truncate;
  end;
end;

procedure TatkbmMemTableLibrary.__TkbmCustomDeltaHandlerResolve(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomDeltaHandler(CurrentObject).Resolve;
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomDeltaHandlerDataSet(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomDeltaHandler(CurrentObject).DataSet));
  end;
end;

procedure TatkbmMemTableLibrary.__SetTkbmCustomDeltaHandlerDataSet(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TkbmCustomDeltaHandler(CurrentObject).DataSet:=TkbmCustomMemTable(VarToObject(GetInputArg(0)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomDeltaHandlerFieldCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomDeltaHandler(CurrentObject).FieldCount));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomDeltaHandlerOrigValues(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomDeltaHandler(CurrentObject).OrigValues[VarToInteger(GetArrayIndex(0))]);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomDeltaHandlerValues(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomDeltaHandler(CurrentObject).Values[VarToInteger(GetArrayIndex(0))]);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomDeltaHandlerOrigValuesByName(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomDeltaHandler(CurrentObject).OrigValuesByName[VarToStr(GetArrayIndex(0))]);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomDeltaHandlerValuesByName(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TkbmCustomDeltaHandler(CurrentObject).ValuesByName[VarToStr(GetArrayIndex(0))]);
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomDeltaHandlerFieldNames(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(TkbmCustomDeltaHandler(CurrentObject).FieldNames[VarToInteger(GetArrayIndex(0))]));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomDeltaHandlerFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TkbmCustomDeltaHandler(CurrentObject).Fields[VarToInteger(GetArrayIndex(0))]));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomDeltaHandlerRecNo(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomDeltaHandler(CurrentObject).RecNo));
  end;
end;

procedure TatkbmMemTableLibrary.__GetTkbmCustomDeltaHandlerUniqueRecID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(TkbmCustomDeltaHandler(CurrentObject).UniqueRecID));
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnFilterIndex( DataSet: TDataSet;  Index: TkbmIndex; var Accept: boolean);
var
  AcceptTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnFilterIndex(BeforeCall)(DataSet,Index,Accept);
    AcceptTemp := Accept;
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,Index,AcceptTemp]);
    Accept := AcceptTemp;
    if AssignedMethod(AfterCall) then
      TkbmOnFilterIndex(AfterCall)(DataSet,Index,Accept);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnUserAggregate( DataSet: TDataSet; const UserFunction: integer; const Count: integer; const Value: double; var Accumulator: double);
var
  AccumulatorTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnUserAggregate(BeforeCall)(DataSet,UserFunction,Count,Value,Accumulator);
    AccumulatorTemp := Accumulator;
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,UserFunction,Count,Value,AccumulatorTemp]);
    Accumulator := AccumulatorTemp;
    if AssignedMethod(AfterCall) then
      TkbmOnUserAggregate(AfterCall)(DataSet,UserFunction,Count,Value,Accumulator);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnProgress( DataSet: TDataSet;  Percentage: integer;  Code: TkbmProgressCode);
var
  CodeTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnProgress(BeforeCall)(DataSet,Percentage,Code);
    CodeTemp := Integer(Code);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,Percentage,CodeTemp]);
    if AssignedMethod(AfterCall) then
      TkbmOnProgress(AfterCall)(DataSet,Percentage,Code);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnLoadRecord( DataSet: TDataSet; var Accept: boolean);
var
  AcceptTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnLoadRecord(BeforeCall)(DataSet,Accept);
    AcceptTemp := Accept;
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,AcceptTemp]);
    Accept := AcceptTemp;
    if AssignedMethod(AfterCall) then
      TkbmOnLoadRecord(AfterCall)(DataSet,Accept);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnLoadField( DataSet: TDataSet;  FieldNo: integer;  Field: TField);
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnLoadField(BeforeCall)(DataSet,FieldNo,Field);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,FieldNo,Field]);
    if AssignedMethod(AfterCall) then
      TkbmOnLoadField(AfterCall)(DataSet,FieldNo,Field);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnSaveRecord( DataSet: TDataSet; var Accept: boolean);
var
  AcceptTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnSaveRecord(BeforeCall)(DataSet,Accept);
    AcceptTemp := Accept;
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,AcceptTemp]);
    Accept := AcceptTemp;
    if AssignedMethod(AfterCall) then
      TkbmOnSaveRecord(AfterCall)(DataSet,Accept);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnSaveField( DataSet: TDataSet;  FieldNo: integer;  Field: TField);
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnSaveField(BeforeCall)(DataSet,FieldNo,Field);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,FieldNo,Field]);
    if AssignedMethod(AfterCall) then
      TkbmOnSaveField(AfterCall)(DataSet,FieldNo,Field);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnCompressField( DataSet: TDataSet;  Field: TField; const Buffer: PAnsiChar; var Size: longint; var ResultBuffer: PAnsiChar);
var
  SizeTemp: variant;
  ResultBufferTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnCompressField(BeforeCall)(DataSet,Field,Buffer,Size,ResultBuffer);
    SizeTemp := Integer(Size);
    ResultBufferTemp := string(ResultBuffer);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,Field,Buffer,SizeTemp,ResultBufferTemp]);
    Size := VarToInteger(SizeTemp);
    ResultBuffer := PChar(VarToStr(ResultBufferTemp));
    if AssignedMethod(AfterCall) then
      TkbmOnCompressField(AfterCall)(DataSet,Field,Buffer,Size,ResultBuffer);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnDecompressField( DataSet: TDataSet;  Field: TField; const Buffer: PAnsiChar; var Size: longint; var ResultBuffer: PAnsiChar);
var
  SizeTemp: variant;
  ResultBufferTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnDecompressField(BeforeCall)(DataSet,Field,Buffer,Size,ResultBuffer);
    SizeTemp := Integer(Size);
    ResultBufferTemp := string(ResultBuffer);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,Field,Buffer,SizeTemp,ResultBufferTemp]);
    Size := VarToInteger(SizeTemp);
    ResultBuffer := PChar(VarToStr(ResultBufferTemp));
    if AssignedMethod(AfterCall) then
      TkbmOnDecompressField(AfterCall)(DataSet,Field,Buffer,Size,ResultBuffer);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnSave( DataSet: TDataSet;  StorageType: TkbmMemTableStorageType;  Stream: TStream);
var
  StorageTypeTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnSave(BeforeCall)(DataSet,StorageType,Stream);
    StorageTypeTemp := Integer(StorageType);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,StorageTypeTemp,Stream]);
    if AssignedMethod(AfterCall) then
      TkbmOnSave(AfterCall)(DataSet,StorageType,Stream);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnLoad( DataSet: TDataSet;  StorageType: TkbmMemTableStorageType;  Stream: TStream);
var
  StorageTypeTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnLoad(BeforeCall)(DataSet,StorageType,Stream);
    StorageTypeTemp := Integer(StorageType);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,StorageTypeTemp,Stream]);
    if AssignedMethod(AfterCall) then
      TkbmOnLoad(AfterCall)(DataSet,StorageType,Stream);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnSetupField( DataSet: TDataSet;  Field: TField; var FieldFlags: byte);
var
  FieldFlagsTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnSetupField(BeforeCall)(DataSet,Field,FieldFlags);
    FieldFlagsTemp := Integer(FieldFlags);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,Field,FieldFlagsTemp]);
    FieldFlags := VarToInteger(FieldFlagsTemp);
    if AssignedMethod(AfterCall) then
      TkbmOnSetupField(AfterCall)(DataSet,Field,FieldFlags);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnSetupFieldProperties( DataSet: TDataSet;  Field: TField);
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnSetupFieldProperties(BeforeCall)(DataSet,Field);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [DataSet,Field]);
    if AssignedMethod(AfterCall) then
      TkbmOnSetupFieldProperties(AfterCall)(DataSet,Field);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnCompress( Dataset: TkbmCustomMemTable;  UnCompressedStream: TStream;  CompressedStream: TStream);
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnCompress(BeforeCall)(Dataset,UnCompressedStream,CompressedStream);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [Dataset,UnCompressedStream,CompressedStream]);
    if AssignedMethod(AfterCall) then
      TkbmOnCompress(AfterCall)(Dataset,UnCompressedStream,CompressedStream);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmOnDeCompress( Dataset: TkbmCustomMemTable;  CompressedStream: TStream;  DeCompressedStream: TStream);
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmOnDeCompress(BeforeCall)(Dataset,CompressedStream,DeCompressedStream);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [Dataset,CompressedStream,DeCompressedStream]);
    if AssignedMethod(AfterCall) then
      TkbmOnDeCompress(AfterCall)(Dataset,CompressedStream,DeCompressedStream);
  end;
end;

procedure TatkbmMemTableDispatcher.__TkbmDeltaHandlerGetValue( ADeltaHandler: TkbmCustomDeltaHandler;  AField: TField; var AValue: variant);
var
  AValueTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TkbmDeltaHandlerGetValue(BeforeCall)(ADeltaHandler,AField,AValue);
    AValueTemp := AValue;
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [ADeltaHandler,AField,AValueTemp]);
    AValue := AValueTemp;
    if AssignedMethod(AfterCall) then
      TkbmDeltaHandlerGetValue(AfterCall)(ADeltaHandler,AField,AValue);
  end;
end;

procedure TatkbmMemTableLibrary.__StreamToVariant(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := kbmMemTable.StreamToVariant(TStream(VarToObject(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__VariantToStream(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    kbmMemTable.VariantToStream(GetInputArg(0),TStream(VarToObject(GetInputArg(1))));
  end;
end;

procedure TatkbmMemTableLibrary.__IndexOptions2CompareOptions(AMachine: TatVirtualMachine);
  var
  Param0: TIndexOptions;
  AResultSet: TkbmMemTableCompareOptions;
  AResult: variant;
begin
  with AMachine do
  begin
IntToSet(Param0, VarToInteger(GetInputArg(0)), SizeOf(Param0));
AResultSet := kbmMemTable.IndexOptions2CompareOptions(Param0);
AResult := IntFromSet(AResultSet, SizeOf(AResultSet));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__CompareOptions2IndexOptions(AMachine: TatVirtualMachine);
  var
  Param0: TkbmMemTableCompareOptions;
  AResultSet: TIndexOptions;
  AResult: variant;
begin
  with AMachine do
  begin
IntToSet(Param0, VarToInteger(GetInputArg(0)), SizeOf(Param0));
AResultSet := kbmMemTable.CompareOptions2IndexOptions(Param0);
AResult := IntFromSet(AResultSet, SizeOf(AResultSet));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatkbmMemTableLibrary.__CopyFieldDefs(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    kbmMemTable.CopyFieldDefs(TFieldDefs(VarToObject(GetInputArg(0))),TFieldDefs(VarToObject(GetInputArg(1))));
  end;
end;

procedure TatkbmMemTableLibrary.__GetkbmSupportedFieldTypes(AMachine: TatVirtualMachine);
var
PropValueSet: TkbmFieldTypes;
begin
  with AMachine do
  begin
    PropValueSet := kbmMemTable.kbmSupportedFieldTypes;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetkbmStringTypes(AMachine: TatVirtualMachine);
var
PropValueSet: TkbmFieldTypes;
begin
  with AMachine do
  begin
    PropValueSet := kbmMemTable.kbmStringTypes;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetkbmBinaryTypes(AMachine: TatVirtualMachine);
var
PropValueSet: TkbmFieldTypes;
begin
  with AMachine do
  begin
    PropValueSet := kbmMemTable.kbmBinaryTypes;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetkbmBlobTypes(AMachine: TatVirtualMachine);
var
PropValueSet: TkbmFieldTypes;
begin
  with AMachine do
  begin
    PropValueSet := kbmMemTable.kbmBlobTypes;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetkbmNonBlobTypes(AMachine: TatVirtualMachine);
var
PropValueSet: TkbmFieldTypes;
begin
  with AMachine do
  begin
    PropValueSet := kbmMemTable.kbmNonBlobTypes;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.__GetkbmVarLengthNonBlobTypes(AMachine: TatVirtualMachine);
var
PropValueSet: TkbmFieldTypes;
begin
  with AMachine do
  begin
    PropValueSet := kbmMemTable.kbmVarLengthNonBlobTypes;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatkbmMemTableLibrary.Init;
begin
  With Scripter.DefineClass(EMemTableError) do
  begin
  end;
  With Scripter.DefineClass(EMemTableFatalError) do
  begin
  end;
  With Scripter.DefineClass(EMemTableInvalidRecord) do
  begin
  end;
  With Scripter.DefineClass(EMemTableIndexError) do
  begin
  end;
  With Scripter.DefineClass(EMemTableDupKey) do
  begin
  end;
  With Scripter.DefineClass(EMemTableFilterError) do
  begin
  end;
  With Scripter.DefineClass(EMemTableLocaleError) do
  begin
  end;
  With Scripter.DefineClass(EMemTableInvalidLocale) do
  begin
  end;
  With Scripter.DefineClass(TkbmFieldList) do
  begin
    DefineMethod('Destroy',0,tkNone,nil,__TkbmFieldListDestroy,false,0,'');
    DefineMethod('Add',2,tkInteger,nil,__TkbmFieldListAdd,false,0,'AField: TField; AValue: TkbmifoOptions');
    DefineMethod('Clear',0,tkNone,nil,__TkbmFieldListClear,false,0,'');
    DefineMethod('IndexOf',1,tkInteger,nil,__TkbmFieldListIndexOf,false,0,'Item: TField');
    DefineMethod('AssignTo',1,tkNone,nil,__TkbmFieldListAssignTo,false,0,'AFieldList: TkbmFieldList');
    DefineMethod('MergeOptionsTo',1,tkNone,nil,__TkbmFieldListMergeOptionsTo,false,0,'AFieldList: TkbmFieldList');
    DefineMethod('ClearOptions',0,tkNone,nil,__TkbmFieldListClearOptions,false,0,'');
    DefineMethod('GetAsString',0,tkVariant,nil,__TkbmFieldListGetAsString,false,0,'');
    DefineProp('Count',tkInteger,__GetTkbmFieldListCount,nil,nil,false,0);
  end;
  With Scripter.DefineClass(TkbmIndex) do
  begin
    DefineMethod('Create',6,tkClass,TkbmIndex,__TkbmIndexCreate,true,0,'ABase: TkbmIndex; Name: string; DataSet: TkbmCustomMemtable; Fields: string; Options: TkbmMemTableCompareOptions; IndexType: TkbmIndexType');
    DefineMethod('Destroy',0,tkNone,nil,__TkbmIndexDestroy,false,0,'');
    DefineMethod('SearchRecordID',2,tkInteger,nil,__TkbmIndexSearchRecordID,false,0,'RecordID: TkbmNativeInt; Index: TkbmNativeInt').SetVarArgs([1]);
    DefineMethod('Clear',0,tkNone,nil,__TkbmIndexClear,false,0,'');
    DefineMethod('Load',0,tkNone,nil,__TkbmIndexLoad,false,0,'');
    DefineMethod('ReSort',0,tkNone,nil,__TkbmIndexReSort,false,0,'');
    DefineMethod('Rebuild',0,tkNone,nil,__TkbmIndexRebuild,false,0,'');
    DefineMethod('RebuildDepending',0,tkNone,nil,__TkbmIndexRebuildDepending,false,0,'');
    DefineProp('DependantIndexes',tkClass,__GetTkbmIndexDependantIndexes,nil,TkbmIndexes,false,0);
    DefineProp('Base',tkClass,__GetTkbmIndexBase,nil,TkbmIndex,false,0);
    DefineProp('Enabled',tkVariant,__GetTkbmIndexEnabled,__SetTkbmIndexEnabled,nil,false,0);
    DefineProp('IsSorted',tkVariant,__GetTkbmIndexIsSorted,__SetTkbmIndexIsSorted,nil,false,0);
    DefineProp('IsDirty',tkVariant,__GetTkbmIndexIsDirty,__SetTkbmIndexIsDirty,nil,false,0);
    DefineProp('IsOrdered',tkVariant,__GetTkbmIndexIsOrdered,nil,nil,false,0);
    DefineProp('IsFiltered',tkVariant,__GetTkbmIndexIsFiltered,__SetTkbmIndexIsFiltered,nil,false,0);
    DefineProp('IsRange',tkVariant,__GetTkbmIndexIsRange,__SetTkbmIndexIsRange,nil,false,0);
    DefineProp('IsFullScope',tkVariant,__GetTkbmIndexIsFullScope,nil,nil,false,0);
    DefineProp('IndexType',tkEnumeration,__GetTkbmIndexIndexType,__SetTkbmIndexIndexType,nil,false,0);
    DefineProp('IndexOptions',tkInteger,__GetTkbmIndexIndexOptions,__SetTkbmIndexIndexOptions,nil,false,0);
    DefineProp('IndexFields',tkVariant,__GetTkbmIndexIndexFields,__SetTkbmIndexIndexFields,nil,false,0);
    DefineProp('IndexFieldList',tkClass,__GetTkbmIndexIndexFieldList,__SetTkbmIndexIndexFieldList,TkbmFieldList,false,0);
    DefineProp('Dataset',tkClass,__GetTkbmIndexDataset,__SetTkbmIndexDataset,TkbmCustomMemTable,false,0);
    DefineProp('Name',tkVariant,__GetTkbmIndexName,__SetTkbmIndexName,nil,false,0);
    DefineProp('References',tkClass,__GetTkbmIndexReferences,__SetTkbmIndexReferences,TkbmList,false,0);
    DefineProp('IsRowOrder',tkVariant,__GetTkbmIndexIsRowOrder,__SetTkbmIndexIsRowOrder,nil,false,0);
    DefineProp('UpdateStatus',tkInteger,__GetTkbmIndexUpdateStatus,__SetTkbmIndexUpdateStatus,nil,false,0);
  end;
  With Scripter.DefineClass(TkbmIndexes) do
  begin
    DefineMethod('Create',1,tkClass,TkbmIndexes,__TkbmIndexesCreate,true,0,'ADataSet: TkbmCustomMemTable');
    DefineMethod('Destroy',0,tkNone,nil,__TkbmIndexesDestroy,false,0,'');
    DefineMethod('Clear',0,tkNone,nil,__TkbmIndexesClear,false,0,'');
    DefineMethod('Add',1,tkNone,nil,__TkbmIndexesAdd,false,0,'IndexDef: TIndexDef');
    DefineMethod('AddIndex',1,tkNone,nil,__TkbmIndexesAddIndex,false,0,'Index: TkbmIndex');
    DefineMethod('DeleteIndex',1,tkNone,nil,__TkbmIndexesDeleteIndex,false,0,'Index: TkbmIndex');
    DefineMethod('ReBuild',1,tkNone,nil,__TkbmIndexesReBuild,false,0,'IndexName: string');
    DefineMethod('Delete',1,tkNone,nil,__TkbmIndexesDelete,false,0,'IndexName: string');
    DefineMethod('Get',1,tkClass,TkbmIndex,__TkbmIndexesGet,false,0,'IndexName: string');
    DefineMethod('GetIndex',1,tkClass,TkbmIndex,__TkbmIndexesGetIndex,false,0,'Ordinal: integer');
    DefineMethod('Empty',1,tkNone,nil,__TkbmIndexesEmpty,false,0,'IndexName: string');
    DefineMethod('GetByFieldNames',1,tkClass,TkbmIndex,__TkbmIndexesGetByFieldNames,false,0,'FieldNames: string');
    DefineMethod('EmptyAll',0,tkNone,nil,__TkbmIndexesEmptyAll,false,0,'');
    DefineMethod('ReBuildAll',0,tkNone,nil,__TkbmIndexesReBuildAll,false,0,'');
    DefineMethod('MarkAllDirty',0,tkNone,nil,__TkbmIndexesMarkAllDirty,false,0,'');
    DefineMethod('Count',0,tkInteger,nil,__TkbmIndexesCount,false,0,'');
  end;
  With Scripter.DefineClass(TkbmCustomStreamFormat) do
  begin
    DefineMethod('Create',1,tkClass,TkbmCustomStreamFormat,__TkbmCustomStreamFormatCreate,true,0,'AOwner: TComponent');
    DefineMethod('Assign',1,tkNone,nil,__TkbmCustomStreamFormatAssign,false,0,'Source: TPersistent');
  end;
  With Scripter.DefineClass(TkbmStreamFormat) do
  begin
  end;
  With Scripter.DefineClass(TkbmCS) do
  begin
  end;
  With Scripter.DefineClass(TkbmCommon) do
  begin
    DefineMethod('GetDeletedRecordsCount',0,tkInteger,nil,__TkbmCommonGetDeletedRecordsCount,false,0,'');
    DefineMethod('GetFieldSize',2,tkInteger,nil,__TkbmCommonGetFieldSize,false,0,'FieldType: TFieldType; Size: longint');
    DefineMethod('GetFieldDataOffset',1,tkInteger,nil,__TkbmCommonGetFieldDataOffset,false,0,'Field: TField');
    DefineMethod('Create',1,tkClass,TkbmCommon,__TkbmCommonCreate,true,0,'AOwner: TkbmCustomMemTable');
    DefineMethod('Destroy',0,tkNone,nil,__TkbmCommonDestroy,false,0,'');
    DefineMethod('Lock',0,tkNone,nil,__TkbmCommonLock,false,0,'');
    DefineMethod('Unlock',0,tkNone,nil,__TkbmCommonUnlock,false,0,'');
    DefineMethod('GetFieldIsVarLength',2,tkVariant,nil,__TkbmCommonGetFieldIsVarLength,false,0,'FieldType: TFieldType; Size: longint');
    DefineMethod('DeAttachAllTables',1,tkNone,nil,__TkbmCommonDeAttachAllTables,false,0,'AExceptTable: TkbmCustomMemTable');
    DefineMethod('AttachTable',1,tkNone,nil,__TkbmCommonAttachTable,false,0,'ATable: TkbmCustomMemTable');
    DefineMethod('DeAttachTable',1,tkNone,nil,__TkbmCommonDeAttachTable,false,0,'ATable: TkbmCustomMemTable');
    DefineMethod('LayoutRecord',1,tkNone,nil,__TkbmCommonLayoutRecord,false,0,'AFieldCount: integer');
    DefineMethod('PackRecords',0,tkNone,nil,__TkbmCommonPackRecords,false,0,'');
    DefineMethod('RecordCount',0,tkInteger,nil,__TkbmCommonRecordCount,false,0,'');
    DefineMethod('DeletedRecordCount',0,tkInteger,nil,__TkbmCommonDeletedRecordCount,false,0,'');
    DefineMethod('Rollback',0,tkNone,nil,__TkbmCommonRollback,false,0,'');
    DefineMethod('Commit',0,tkNone,nil,__TkbmCommonCommit,false,0,'');
    DefineMethod('IsAnyTableActive',0,tkVariant,nil,__TkbmCommonIsAnyTableActive,false,0,'');
    DefineMethod('CloseTables',1,tkNone,nil,__TkbmCommonCloseTables,false,0,'Caller: TkbmCustomMemTable');
    DefineMethod('RefreshTables',1,tkNone,nil,__TkbmCommonRefreshTables,false,0,'Caller: TkbmCustomMemTable');
    DefineMethod('ResyncTables',0,tkNone,nil,__TkbmCommonResyncTables,false,0,'');
    DefineMethod('EmptyTables',0,tkNone,nil,__TkbmCommonEmptyTables,false,0,'');
    DefineMethod('RebuildIndexes',0,tkNone,nil,__TkbmCommonRebuildIndexes,false,0,'');
    DefineMethod('MarkIndexesDirty',0,tkNone,nil,__TkbmCommonMarkIndexesDirty,false,0,'');
    DefineMethod('UpdateIndexes',0,tkNone,nil,__TkbmCommonUpdateIndexes,false,0,'');
    DefineMethod('ClearIndexes',0,tkNone,nil,__TkbmCommonClearIndexes,false,0,'');
    DefineMethod('IncTransactionLevel',0,tkNone,nil,__TkbmCommonIncTransactionLevel,false,0,'');
    DefineMethod('DecTransactionLevel',0,tkNone,nil,__TkbmCommonDecTransactionLevel,false,0,'');
    DefineProp('DataRecordSize',tkInteger,__GetTkbmCommonDataRecordSize,nil,nil,false,0);
    DefineProp('Records',tkClass,__GetTkbmCommonRecords,nil,TkbmList,false,0);
    DefineProp('RecordID',tkInteger,__GetTkbmCommonRecordID,__SetTkbmCommonRecordID,nil,false,0);
    DefineProp('UniqueRecordID',tkInteger,__GetTkbmCommonUniqueRecordID,__SetTkbmCommonUniqueRecordID,nil,false,0);
    DefineProp('DeletedCount',tkInteger,__GetTkbmCommonDeletedCount,__SetTkbmCommonDeletedCount,nil,false,0);
    DefineProp('AttachMaxCount',tkInteger,__GetTkbmCommonAttachMaxCount,__SetTkbmCommonAttachMaxCount,nil,false,0);
    DefineProp('AttachCount',tkInteger,__GetTkbmCommonAttachCount,nil,nil,false,0);
    DefineProp('Standalone',tkVariant,__GetTkbmCommonStandalone,__SetTkbmCommonStandalone,nil,false,0);
    DefineProp('AutoIncMin',tkInteger,__GetTkbmCommonAutoIncMin,__SetTkbmCommonAutoIncMin,nil,false,0);
    DefineProp('AutoIncMax',tkInteger,__GetTkbmCommonAutoIncMax,__SetTkbmCommonAutoIncMax,nil,false,0);
    DefineProp('Performance',tkEnumeration,__GetTkbmCommonPerformance,__SetTkbmCommonPerformance,nil,false,0);
    DefineProp('VersioningMode',tkEnumeration,__GetTkbmCommonVersioningMode,__SetTkbmCommonVersioningMode,nil,false,0);
    DefineProp('EnableVersioning',tkVariant,__GetTkbmCommonEnableVersioning,__SetTkbmCommonEnableVersioning,nil,false,0);
    DefineProp('Capacity',tkInteger,__GetTkbmCommonCapacity,__SetTkbmCommonCapacity,nil,false,0);
    DefineProp('IsDataModified',tkVariant,__GetTkbmCommonIsDataModified,__SetTkbmCommonIsDataModified,nil,false,0);
    DefineProp('TransactionLevel',tkInteger,__GetTkbmCommonTransactionLevel,nil,nil,false,0);
    DefineProp('FieldModified',tkVariant,__GetTkbmCommonFieldModified,__SetTkbmCommonFieldModified,nil,false,1);
    DefineProp('LanguageID',tkInteger,__GetTkbmCommonLanguageID,__SetTkbmCommonLanguageID,nil,false,0);
    DefineProp('SortID',tkInteger,__GetTkbmCommonSortID,__SetTkbmCommonSortID,nil,false,0);
    DefineProp('SubLanguageID',tkInteger,__GetTkbmCommonSubLanguageID,__SetTkbmCommonSubLanguageID,nil,false,0);
    DefineProp('LocaleID',tkInteger,__GetTkbmCommonLocaleID,__SetTkbmCommonLocaleID,nil,false,0);
  end;
  With Scripter.DefineClass(TkbmMasterDataLink) do
  begin
  end;
  With Scripter.DefineClass(TkbmCustomMemTable) do
  begin
    DefineMethod('__CalcFieldsSize',0,tkInteger,nil,__TkbmCustomMemTable__CalcFieldsSize,false,0,'');
    DefineMethod('__ClearBuffers',0,tkNone,nil,__TkbmCustomMemTable__ClearBuffers,false,0,'');
    DefineMethod('__SetTempState',1,tkEnumeration,nil,__TkbmCustomMemTable__SetTempState,false,0,'Value: TDataSetState');
    DefineMethod('__RestoreState',1,tkNone,nil,__TkbmCustomMemTable__RestoreState,false,0,'Value: TDataSetState');
    DefineMethod('Create',1,tkClass,TkbmCustomMemTable,__TkbmCustomMemTableCreate,true,0,'AOwner: TComponent');
    DefineMethod('Destroy',0,tkNone,nil,__TkbmCustomMemTableDestroy,false,0,'');
    DefineMethod('UpdateStatus',0,tkEnumeration,nil,__TkbmCustomMemTableUpdateStatus,false,0,'');
    DefineMethod('CreateBlobStream',2,tkClass,TStream,__TkbmCustomMemTableCreateBlobStream,false,0,'Field: TField; Mode: TBlobStreamMode');
    DefineMethod('IsSequenced',0,tkVariant,nil,__TkbmCustomMemTableIsSequenced,false,0,'');
    DefineMethod('SavePersistent',0,tkNone,nil,__TkbmCustomMemTableSavePersistent,false,0,'');
    DefineMethod('LoadPersistent',0,tkNone,nil,__TkbmCustomMemTableLoadPersistent,false,0,'');
    DefineMethod('GetAggregateFieldName',2,tkVariant,nil,__TkbmCustomMemTableGetAggregateFieldName,true,0,'AFieldName: string; AOptions: TkbmifoOptions');
    DefineMethod('GetAggregateFieldOption',1,tkInteger,nil,__TkbmCustomMemTableGetAggregateFieldOption,true,0,'AAggregateFunction: string');
    DefineMethod('BuildFieldList',4,tkNone,nil,__TkbmCustomMemTableBuildFieldList,false,1,'Dataset: TDataset; List: TkbmFieldList; FieldNames: string; AggregateFieldNaming: boolean = false');
    DefineMethod('FindFieldInList',2,tkClass,TField,__TkbmCustomMemTableFindFieldInList,false,0,'List: TkbmFieldList; FieldName: String');
    DefineMethod('IsFieldListsEqual',3,tkVariant,nil,__TkbmCustomMemTableIsFieldListsEqual,false,0,'List1: TkbmFieldList; List2: TkbmFieldList; ASameCase: boolean');
    DefineMethod('IsFieldListsBegin',3,tkVariant,nil,__TkbmCustomMemTableIsFieldListsBegin,false,0,'List1: TkbmFieldList; List2: TkbmFieldList; ASameCase: boolean');
    DefineMethod('SetFieldListOptions',3,tkNone,nil,__TkbmCustomMemTableSetFieldListOptions,false,0,'AList: TkbmFieldList; AOptions: TkbmifoOption; AFieldNames: string');
    DefineMethod('ClearModified',0,tkNone,nil,__TkbmCustomMemTableClearModified,false,0,'');
    DefineMethod('DestroyIndexes',0,tkNone,nil,__TkbmCustomMemTableDestroyIndexes,false,0,'');
    DefineMethod('CreateIndexes',0,tkNone,nil,__TkbmCustomMemTableCreateIndexes,false,0,'');
    DefineMethod('IsMasterDetailActive',0,tkVariant,nil,__TkbmCustomMemTableIsMasterDetailActive,false,0,'');
    DefineMethod('SwitchToIndex',1,tkNone,nil,__TkbmCustomMemTableSwitchToIndex,false,0,'Index: TkbmIndex');
    DefineMethod('CreateFieldAs',2,tkClass,TField,__TkbmCustomMemTableCreateFieldAs,false,1,'Field: TField; AForceAsData: boolean = false');
    DefineMethod('MoveRecord',2,tkVariant,nil,__TkbmCustomMemTableMoveRecord,false,0,'Source: Integer; Destination: Integer');
    DefineMethod('CopyRecord',2,tkVariant,nil,__TkbmCustomMemTableCopyRecord,false,0,'Source: Integer; Destination: Integer');
    DefineMethod('MoveCurRecord',1,tkVariant,nil,__TkbmCustomMemTableMoveCurRecord,false,0,'Destination: Longint');
    DefineMethod('GetVersionFieldData',2,tkVariant,nil,__TkbmCustomMemTableGetVersionFieldData,false,0,'Field: TField; Version: integer');
    DefineMethod('GetVersionStatus',1,tkEnumeration,nil,__TkbmCustomMemTableGetVersionStatus,false,0,'Version: integer');
    DefineMethod('GetVersionCount',0,tkInteger,nil,__TkbmCustomMemTableGetVersionCount,false,0,'');
    DefineMethod('SetVersionFieldData',3,tkVariant,nil,__TkbmCustomMemTableSetVersionFieldData,false,0,'Field: TField; AVersion: integer; AValue: variant');
    DefineMethod('SetVersionStatus',2,tkEnumeration,nil,__TkbmCustomMemTableSetVersionStatus,false,0,'AVersion: integer; AUpdateStatus: TUpdateStatus');
    DefineMethod('ResetAutoInc',0,tkNone,nil,__TkbmCustomMemTableResetAutoInc,false,0,'');
    DefineMethod('Progress',2,tkNone,nil,__TkbmCustomMemTableProgress,false,0,'Pct: integer; Code: TkbmProgressCode');
    DefineMethod('CopyRecords',4,tkInteger,nil,__TkbmCustomMemTableCopyRecords,false,0,'Source: TDataSet; Destination: TDataSet; Count: longint; IgnoreErrors: boolean');
    DefineMethod('AssignRecord',2,tkNone,nil,__TkbmCustomMemTableAssignRecord,false,0,'Source: TDataSet; Destination: TDataSet');
    DefineMethod('Lock',0,tkNone,nil,__TkbmCustomMemTableLock,false,0,'');
    DefineMethod('Unlock',0,tkNone,nil,__TkbmCustomMemTableUnlock,false,0,'');
    DefineMethod('UpdateFieldVariables',0,tkNone,nil,__TkbmCustomMemTableUpdateFieldVariables,false,0,'');
    DefineMethod('CopyFieldProperties',2,tkNone,nil,__TkbmCustomMemTableCopyFieldProperties,false,0,'Source: TField; Destination: TField');
    DefineMethod('CopyFieldsProperties',2,tkNone,nil,__TkbmCustomMemTableCopyFieldsProperties,false,0,'Source: TDataSet; Destination: TDataSet');
    DefineMethod('Exists',0,tkVariant,nil,__TkbmCustomMemTableExists,false,0,'');
    DefineMethod('CreateTable',0,tkNone,nil,__TkbmCustomMemTableCreateTable,false,0,'');
    DefineMethod('EmptyTable',0,tkNone,nil,__TkbmCustomMemTableEmptyTable,false,0,'');
    DefineMethod('CreateTableAs',2,tkNone,nil,__TkbmCustomMemTableCreateTableAs,false,0,'Source: TDataSet; CopyOptions: TkbmMemTableCopyTableOptions');
    DefineMethod('DeleteTable',0,tkNone,nil,__TkbmCustomMemTableDeleteTable,false,0,'');
    DefineMethod('PackTable',0,tkNone,nil,__TkbmCustomMemTablePackTable,false,0,'');
    DefineMethod('AddIndex',3,tkClass,TkbmIndex,__TkbmCustomMemTableAddIndex,false,0,'Name: string; Fields: string; Options: TIndexOptions');
    DefineMethod('DeleteIndex',1,tkNone,nil,__TkbmCustomMemTableDeleteIndex,false,0,'Name: string');
    DefineMethod('UpdateIndexes',0,tkNone,nil,__TkbmCustomMemTableUpdateIndexes,false,0,'');
    DefineMethod('IndexFieldCount',0,tkInteger,nil,__TkbmCustomMemTableIndexFieldCount,false,0,'');
    DefineMethod('StartTransaction',0,tkNone,nil,__TkbmCustomMemTableStartTransaction,false,0,'');
    DefineMethod('Commit',0,tkNone,nil,__TkbmCustomMemTableCommit,false,0,'');
    DefineMethod('Rollback',0,tkNone,nil,__TkbmCustomMemTableRollback,false,0,'');
    DefineMethod('Undo',0,tkNone,nil,__TkbmCustomMemTableUndo,false,0,'');
    DefineMethod('LoadFromFile',1,tkNone,nil,__TkbmCustomMemTableLoadFromFile,false,0,'FileName: string');
    DefineMethod('LoadFromStream',1,tkNone,nil,__TkbmCustomMemTableLoadFromStream,false,0,'Stream: TStream');
    DefineMethod('LoadFromFileViaFormat',2,tkNone,nil,__TkbmCustomMemTableLoadFromFileViaFormat,false,0,'FileName: string; AFormat: TkbmCustomStreamFormat');
    DefineMethod('LoadFromStreamViaFormat',2,tkNone,nil,__TkbmCustomMemTableLoadFromStreamViaFormat,false,0,'Stream: TStream; AFormat: TkbmCustomStreamFormat');
    DefineMethod('SaveToFile',1,tkNone,nil,__TkbmCustomMemTableSaveToFile,false,0,'FileName: string');
    DefineMethod('SaveToStream',1,tkNone,nil,__TkbmCustomMemTableSaveToStream,false,0,'Stream: TStream');
    DefineMethod('SaveToFileViaFormat',2,tkNone,nil,__TkbmCustomMemTableSaveToFileViaFormat,false,0,'FileName: string; AFormat: TkbmCustomStreamFormat');
    DefineMethod('SaveToStreamViaFormat',2,tkNone,nil,__TkbmCustomMemTableSaveToStreamViaFormat,false,0,'Stream: TStream; AFormat: TkbmCustomStreamFormat');
    DefineMethod('LoadFromDataSet',2,tkNone,nil,__TkbmCustomMemTableLoadFromDataSet,false,0,'Source: TDataSet; CopyOptions: TkbmMemTableCopyTableOptions');
    DefineMethod('SaveToDataSet',2,tkNone,nil,__TkbmCustomMemTableSaveToDataSet,false,1,'Destination: TDataSet; CopyOptions: TkbmMemTableCopyTableOptions = []');
    DefineMethod('UpdateToDataSet',3,tkNone,nil,__TkbmCustomMemTableUpdateToDataSet,false,0,'Destination: TDataSet; KeyFields: String; Flags: TkbmMemTableUpdateFlags');
    DefineMethod('SortDefault',0,tkNone,nil,__TkbmCustomMemTableSortDefault,false,0,'');
    DefineMethod('Sort',1,tkNone,nil,__TkbmCustomMemTableSort,false,0,'Options: TkbmMemTableCompareOptions');
    DefineMethod('SortOn',2,tkNone,nil,__TkbmCustomMemTableSortOn,false,0,'FieldNames: string; Options: TkbmMemTableCompareOptions');
    DefineMethod('Lookup',3,tkVariant,nil,__TkbmCustomMemTableLookup,false,0,'KeyFields: string; KeyValues: Variant; ResultFields: string');
    DefineMethod('LookupByIndex',4,tkVariant,nil,__TkbmCustomMemTableLookupByIndex,false,0,'IndexName: string; KeyValues: Variant; ResultFields: string; RespFilter: boolean');
    DefineMethod('Locate',3,tkVariant,nil,__TkbmCustomMemTableLocate,false,0,'KeyFields: string; KeyValues: Variant; Options: TLocateOptions');
    DefineMethod('SetKey',0,tkNone,nil,__TkbmCustomMemTableSetKey,false,0,'');
    DefineMethod('EditKey',0,tkNone,nil,__TkbmCustomMemTableEditKey,false,0,'');
    DefineMethod('GotoNearest',0,tkVariant,nil,__TkbmCustomMemTableGotoNearest,false,0,'');
    DefineMethod('GotoKey',0,tkVariant,nil,__TkbmCustomMemTableGotoKey,false,0,'');
    DefineMethod('ApplyRange',0,tkNone,nil,__TkbmCustomMemTableApplyRange,false,0,'');
    DefineMethod('CancelRange',0,tkNone,nil,__TkbmCustomMemTableCancelRange,false,0,'');
    DefineMethod('SetRangeStart',0,tkNone,nil,__TkbmCustomMemTableSetRangeStart,false,0,'');
    DefineMethod('SetRangeEnd',0,tkNone,nil,__TkbmCustomMemTableSetRangeEnd,false,0,'');
    DefineMethod('EditRangeStart',0,tkNone,nil,__TkbmCustomMemTableEditRangeStart,false,0,'');
    DefineMethod('EditRangeEnd',0,tkNone,nil,__TkbmCustomMemTableEditRangeEnd,false,0,'');
    DefineMethod('CheckPoint',0,tkNone,nil,__TkbmCustomMemTableCheckPoint,false,0,'');
    DefineMethod('CheckPointRecord',1,tkEnumeration,nil,__TkbmCustomMemTableCheckPointRecord,false,0,'RecordIndex: integer');
    DefineMethod('GetRows',3,tkVariant,nil,__TkbmCustomMemTableGetRows,false,0,'Rows: Integer; Start: Variant; Fields: Variant');
    DefineMethod('Reset',0,tkNone,nil,__TkbmCustomMemTableReset,false,0,'');
    DefineMethod('GotoCurrent',1,tkNone,nil,__TkbmCustomMemTableGotoCurrent,false,0,'DataSet: TkbmCustomMemTable');
    DefineMethod('GroupBy',3,tkNone,nil,__TkbmCustomMemTableGroupBy,false,0,'ADestDataset: TkbmCustomMemTable; AGroupFields: string; AAggregateFields: string');
    DefineProp('PersistentSaved',tkVariant,__GetTkbmCustomMemTablePersistentSaved,__SetTkbmCustomMemTablePersistentSaved,nil,false,0);
    DefineProp('AttachedTo',tkClass,__GetTkbmCustomMemTableAttachedTo,__SetTkbmCustomMemTableAttachedTo,TkbmCustomMemTable,false,0);
    DefineProp('AttachedAutoRefresh',tkVariant,__GetTkbmCustomMemTableAttachedAutoRefresh,__SetTkbmCustomMemTableAttachedAutoRefresh,nil,false,0);
    DefineProp('Performance',tkEnumeration,__GetTkbmCustomMemTablePerformance,__SetTkbmCustomMemTablePerformance,nil,false,0);
    DefineProp('Filtered',tkVariant,nil,nil,nil,false,0);
    DefineProp('Filter',tkVariant,nil,nil,nil,false,0);
    DefineProp('CurIndex',tkClass,__GetTkbmCustomMemTableCurIndex,nil,TkbmIndex,false,0);
    DefineProp('IgnoreAutoIncPopulation',tkVariant,__GetTkbmCustomMemTableIgnoreAutoIncPopulation,__SetTkbmCustomMemTableIgnoreAutoIncPopulation,nil,false,0);
    DefineProp('AttachMaxCount',tkInteger,__GetTkbmCustomMemTableAttachMaxCount,__SetTkbmCustomMemTableAttachMaxCount,nil,false,0);
    DefineProp('AttachCount',tkInteger,__GetTkbmCustomMemTableAttachCount,nil,nil,false,0);
    DefineProp('DesignActivation',tkVariant,__GetTkbmCustomMemTableDesignActivation,__SetTkbmCustomMemTableDesignActivation,nil,false,0);
    DefineProp('LanguageID',tkInteger,__GetTkbmCustomMemTableLanguageID,__SetTkbmCustomMemTableLanguageID,nil,false,0);
    DefineProp('SortID',tkInteger,__GetTkbmCustomMemTableSortID,__SetTkbmCustomMemTableSortID,nil,false,0);
    DefineProp('SubLanguageID',tkInteger,__GetTkbmCustomMemTableSubLanguageID,__SetTkbmCustomMemTableSubLanguageID,nil,false,0);
    DefineProp('LocaleID',tkInteger,__GetTkbmCustomMemTableLocaleID,__SetTkbmCustomMemTableLocaleID,nil,false,0);
    DefineProp('Common',tkClass,__GetTkbmCustomMemTableCommon,nil,TkbmCommon,false,0);
    DefineProp('AutoIncValue',tkInteger,__GetTkbmCustomMemTableAutoIncValue,nil,nil,false,0);
    DefineProp('AutoIncMinValue',tkInteger,__GetTkbmCustomMemTableAutoIncMinValue,__SetTkbmCustomMemTableAutoIncMinValue,nil,false,0);
    DefineProp('AutoUpdateFieldVariables',tkVariant,__GetTkbmCustomMemTableAutoUpdateFieldVariables,__SetTkbmCustomMemTableAutoUpdateFieldVariables,nil,false,0);
    DefineProp('AllData',tkVariant,__GetTkbmCustomMemTableAllData,__SetTkbmCustomMemTableAllData,nil,false,0);
    DefineProp('StoreDataOnForm',tkVariant,__GetTkbmCustomMemTableStoreDataOnForm,__SetTkbmCustomMemTableStoreDataOnForm,nil,false,0);
    DefineProp('CommaText',tkVariant,__GetTkbmCustomMemTableCommaText,__SetTkbmCustomMemTableCommaText,nil,false,0);
    DefineProp('Capacity',tkInteger,__GetTkbmCustomMemTableCapacity,__SetTkbmCustomMemTableCapacity,nil,false,0);
    DefineProp('DeletedRecordsCount',tkInteger,__GetTkbmCustomMemTableDeletedRecordsCount,nil,nil,false,0);
    DefineProp('IndexFieldNames',tkVariant,__GetTkbmCustomMemTableIndexFieldNames,__SetTkbmCustomMemTableIndexFieldNames,nil,false,0);
    DefineProp('IndexName',tkVariant,__GetTkbmCustomMemTableIndexName,__SetTkbmCustomMemTableIndexName,nil,false,0);
    DefineProp('EnableIndexes',tkVariant,__GetTkbmCustomMemTableEnableIndexes,__SetTkbmCustomMemTableEnableIndexes,nil,false,0);
    DefineProp('AutoAddIndexes',tkVariant,__GetTkbmCustomMemTableAutoAddIndexes,__SetTkbmCustomMemTableAutoAddIndexes,nil,false,0);
    DefineProp('AutoReposition',tkVariant,__GetTkbmCustomMemTableAutoReposition,__SetTkbmCustomMemTableAutoReposition,nil,false,0);
    DefineProp('SortFields',tkVariant,__GetTkbmCustomMemTableSortFields,__SetTkbmCustomMemTableSortFields,nil,false,0);
    DefineProp('SortOptions',tkInteger,__GetTkbmCustomMemTableSortOptions,__SetTkbmCustomMemTableSortOptions,nil,false,0);
    DefineProp('ReadOnly',tkVariant,__GetTkbmCustomMemTableReadOnly,__SetTkbmCustomMemTableReadOnly,nil,false,0);
    DefineProp('Standalone',tkVariant,__GetTkbmCustomMemTableStandalone,__SetTkbmCustomMemTableStandalone,nil,false,0);
    DefineProp('IgnoreReadOnly',tkVariant,__GetTkbmCustomMemTableIgnoreReadOnly,__SetTkbmCustomMemTableIgnoreReadOnly,nil,false,0);
    DefineProp('RangeActive',tkVariant,__GetTkbmCustomMemTableRangeActive,nil,nil,false,0);
    DefineProp('RangeIgnoreNullKeyValues',tkVariant,__GetTkbmCustomMemTableRangeIgnoreNullKeyValues,__SetTkbmCustomMemTableRangeIgnoreNullKeyValues,nil,false,0);
    DefineProp('PersistentFile',tkVariant,__GetTkbmCustomMemTablePersistentFile,__SetTkbmCustomMemTablePersistentFile,nil,false,0);
    DefineProp('Persistent',tkVariant,__GetTkbmCustomMemTablePersistent,__SetTkbmCustomMemTablePersistent,nil,false,0);
    DefineProp('PersistentBackup',tkVariant,__GetTkbmCustomMemTablePersistentBackup,__SetTkbmCustomMemTablePersistentBackup,nil,false,0);
    DefineProp('PersistentBackupExt',tkVariant,__GetTkbmCustomMemTablePersistentBackupExt,__SetTkbmCustomMemTablePersistentBackupExt,nil,false,0);
    DefineProp('ProgressFlags',tkInteger,__GetTkbmCustomMemTableProgressFlags,__SetTkbmCustomMemTableProgressFlags,nil,false,0);
    DefineProp('LoadLimit',tkInteger,__GetTkbmCustomMemTableLoadLimit,__SetTkbmCustomMemTableLoadLimit,nil,false,0);
    DefineProp('LoadCount',tkInteger,__GetTkbmCustomMemTableLoadCount,__SetTkbmCustomMemTableLoadCount,nil,false,0);
    DefineProp('LoadedCompletely',tkVariant,__GetTkbmCustomMemTableLoadedCompletely,__SetTkbmCustomMemTableLoadedCompletely,nil,false,0);
    DefineProp('SaveLimit',tkInteger,__GetTkbmCustomMemTableSaveLimit,__SetTkbmCustomMemTableSaveLimit,nil,false,0);
    DefineProp('SaveCount',tkInteger,__GetTkbmCustomMemTableSaveCount,__SetTkbmCustomMemTableSaveCount,nil,false,0);
    DefineProp('SavedCompletely',tkVariant,__GetTkbmCustomMemTableSavedCompletely,__SetTkbmCustomMemTableSavedCompletely,nil,false,0);
    DefineProp('RecalcOnFetch',tkVariant,__GetTkbmCustomMemTableRecalcOnFetch,__SetTkbmCustomMemTableRecalcOnFetch,nil,false,0);
    DefineProp('IsFieldModified',tkVariant,__GetTkbmCustomMemTableIsFieldModified,nil,nil,false,1);
    DefineProp('EnableVersioning',tkVariant,__GetTkbmCustomMemTableEnableVersioning,__SetTkbmCustomMemTableEnableVersioning,nil,false,0);
    DefineProp('VersioningMode',tkEnumeration,__GetTkbmCustomMemTableVersioningMode,__SetTkbmCustomMemTableVersioningMode,nil,false,0);
    DefineProp('IsVersioning',tkVariant,__GetTkbmCustomMemTableIsVersioning,nil,nil,false,0);
    DefineProp('StatusFilter',tkInteger,__GetTkbmCustomMemTableStatusFilter,__SetTkbmCustomMemTableStatusFilter,nil,false,0);
    DefineProp('DeltaHandler',tkClass,__GetTkbmCustomMemTableDeltaHandler,__SetTkbmCustomMemTableDeltaHandler,TkbmCustomDeltaHandler,false,0);
    DefineProp('Indexes',tkClass,__GetTkbmCustomMemTableIndexes,nil,TkbmIndexes,false,0);
    DefineProp('IndexByName',tkClass,__GetTkbmCustomMemTableIndexByName,nil,TkbmIndex,false,1);
    DefineProp('IndexDefs',tkClass,__GetTkbmCustomMemTableIndexDefs,__SetTkbmCustomMemTableIndexDefs,TIndexDefs,false,0);
    DefineProp('IndexFields',tkClass,__GetTkbmCustomMemTableIndexFields,__SetTkbmCustomMemTableIndexFields,TField,false,1);
    DefineProp('RecalcOnIndex',tkVariant,__GetTkbmCustomMemTableRecalcOnIndex,__SetTkbmCustomMemTableRecalcOnIndex,nil,false,0);
    DefineProp('FilterOptions',tkInteger,__GetTkbmCustomMemTableFilterOptions,__SetTkbmCustomMemTableFilterOptions,nil,false,0);
    DefineProp('DetailFields',tkVariant,__GetTkbmCustomMemTableDetailFields,__SetTkbmCustomMemTableDetailFields,nil,false,0);
    DefineProp('MasterFields',tkVariant,__GetTkbmCustomMemTableMasterFields,__SetTkbmCustomMemTableMasterFields,nil,false,0);
    DefineProp('MasterSource',tkClass,__GetTkbmCustomMemTableMasterSource,__SetTkbmCustomMemTableMasterSource,TDataSource,false,0);
    DefineProp('RecordTag',tkInteger,__GetTkbmCustomMemTableRecordTag,__SetTkbmCustomMemTableRecordTag,nil,false,0);
    DefineProp('Version',tkVariant,__GetTkbmCustomMemTableVersion,__SetTkbmCustomMemTableVersion,nil,false,0);
    DefineProp('IsDataModified',tkVariant,__GetTkbmCustomMemTableIsDataModified,__SetTkbmCustomMemTableIsDataModified,nil,false,0);
    DefineProp('TransactionLevel',tkInteger,__GetTkbmCustomMemTableTransactionLevel,nil,nil,false,0);
    DefineProp('TableState',tkEnumeration,__GetTkbmCustomMemTableTableState,__SetTkbmCustomMemTableTableState,nil,false,0);
    DefineProp('DefaultFormat',tkClass,__GetTkbmCustomMemTableDefaultFormat,__SetTkbmCustomMemTableDefaultFormat,TkbmCustomStreamFormat,false,0);
    DefineProp('CommaTextFormat',tkClass,__GetTkbmCustomMemTableCommaTextFormat,__SetTkbmCustomMemTableCommaTextFormat,TkbmCustomStreamFormat,false,0);
    DefineProp('PersistentFormat',tkClass,__GetTkbmCustomMemTablePersistentFormat,__SetTkbmCustomMemTablePersistentFormat,TkbmCustomStreamFormat,false,0);
    DefineProp('FormFormat',tkClass,__GetTkbmCustomMemTableFormFormat,__SetTkbmCustomMemTableFormFormat,TkbmCustomStreamFormat,false,0);
    DefineProp('AllDataFormat',tkClass,__GetTkbmCustomMemTableAllDataFormat,__SetTkbmCustomMemTableAllDataFormat,TkbmCustomStreamFormat,false,0);
    DefineProp('BeforeOpen',tkVariant,nil,nil,nil,false,0);
    DefineProp('AfterOpen',tkVariant,nil,nil,nil,false,0);
    DefineProp('BeforeClose',tkVariant,nil,nil,nil,false,0);
    DefineProp('AfterClose',tkVariant,nil,nil,nil,false,0);
    DefineProp('AfterInsert',tkVariant,nil,nil,nil,false,0);
    DefineProp('BeforeEdit',tkVariant,nil,nil,nil,false,0);
    DefineProp('AfterEdit',tkVariant,nil,nil,nil,false,0);
    DefineProp('BeforePost',tkVariant,nil,nil,nil,false,0);
    DefineProp('AfterPost',tkVariant,nil,nil,nil,false,0);
    DefineProp('BeforeCancel',tkVariant,nil,nil,nil,false,0);
    DefineProp('AfterCancel',tkVariant,nil,nil,nil,false,0);
    DefineProp('BeforeDelete',tkVariant,nil,nil,nil,false,0);
    DefineProp('AfterDelete',tkVariant,nil,nil,nil,false,0);
    DefineProp('BeforeScroll',tkVariant,nil,nil,nil,false,0);
    DefineProp('AfterScroll',tkVariant,nil,nil,nil,false,0);
    DefineProp('OnCalcFields',tkVariant,nil,nil,nil,false,0);
    DefineProp('OnDeleteError',tkVariant,nil,nil,nil,false,0);
    DefineProp('OnEditError',tkVariant,nil,nil,nil,false,0);
    DefineProp('OnFilterRecord',tkVariant,nil,nil,nil,false,0);
    DefineProp('OnNewRecord',tkVariant,nil,nil,nil,false,0);
    DefineProp('OnPostError',tkVariant,nil,nil,nil,false,0);
    DefineProp('Active',tkVariant,nil,nil,nil,false,0);
  end;
  With Scripter.DefineClass(TkbmMemTable) do
  begin
    DefineProp('IgnoreReadOnly',tkVariant,nil,nil,nil,false,0);
  end;
  With Scripter.DefineClass(TkbmBlobStream) do
  begin
    DefineMethod('Create',2,tkClass,TkbmBlobStream,__TkbmBlobStreamCreate,true,0,'Field: TBlobField; Mode: TBlobStreamMode');
    DefineMethod('Destroy',0,tkNone,nil,__TkbmBlobStreamDestroy,false,0,'');
    DefineMethod('Write',2,tkInteger,nil,__TkbmBlobStreamWrite,false,0,'Buffer; Count: Longint');
    DefineMethod('Truncate',0,tkNone,nil,__TkbmBlobStreamTruncate,false,0,'');
  end;
  With Scripter.DefineClass(TkbmCustomDeltaHandler) do
  begin
    DefineMethod('Resolve',0,tkNone,nil,__TkbmCustomDeltaHandlerResolve,false,0,'');
    DefineProp('DataSet',tkClass,__GetTkbmCustomDeltaHandlerDataSet,__SetTkbmCustomDeltaHandlerDataSet,TkbmCustomMemTable,false,0);
    DefineProp('FieldCount',tkInteger,__GetTkbmCustomDeltaHandlerFieldCount,nil,nil,false,0);
    DefineProp('OrigValues',tkVariant,__GetTkbmCustomDeltaHandlerOrigValues,nil,nil,false,1);
    DefineProp('Values',tkVariant,__GetTkbmCustomDeltaHandlerValues,nil,nil,false,1);
    DefineProp('OrigValuesByName',tkVariant,__GetTkbmCustomDeltaHandlerOrigValuesByName,nil,nil,false,1);
    DefineProp('ValuesByName',tkVariant,__GetTkbmCustomDeltaHandlerValuesByName,nil,nil,false,1);
    DefineProp('FieldNames',tkVariant,__GetTkbmCustomDeltaHandlerFieldNames,nil,nil,false,1);
    DefineProp('Fields',tkClass,__GetTkbmCustomDeltaHandlerFields,nil,TField,false,1);
    DefineProp('RecNo',tkInteger,__GetTkbmCustomDeltaHandlerRecNo,nil,nil,false,0);
    DefineProp('UniqueRecID',tkInteger,__GetTkbmCustomDeltaHandlerUniqueRecID,nil,nil,false,0);
  end;
  DefineEventAdapter(TypeInfo(TkbmOnFilterIndex), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnFilterIndex);
  DefineEventAdapter(TypeInfo(TkbmOnUserAggregate), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnUserAggregate);
  DefineEventAdapter(TypeInfo(TkbmOnProgress), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnProgress);
  DefineEventAdapter(TypeInfo(TkbmOnLoadRecord), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnLoadRecord);
  DefineEventAdapter(TypeInfo(TkbmOnLoadField), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnLoadField);
  DefineEventAdapter(TypeInfo(TkbmOnSaveRecord), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnSaveRecord);
  DefineEventAdapter(TypeInfo(TkbmOnSaveField), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnSaveField);
  DefineEventAdapter(TypeInfo(TkbmOnCompressField), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnCompressField);
  DefineEventAdapter(TypeInfo(TkbmOnDecompressField), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnDecompressField);
  DefineEventAdapter(TypeInfo(TkbmOnSave), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnSave);
  DefineEventAdapter(TypeInfo(TkbmOnLoad), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnLoad);
  DefineEventAdapter(TypeInfo(TkbmOnSetupField), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnSetupField);
  DefineEventAdapter(TypeInfo(TkbmOnSetupFieldProperties), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnSetupFieldProperties);
  DefineEventAdapter(TypeInfo(TkbmOnCompress), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnCompress);
  DefineEventAdapter(TypeInfo(TkbmOnDeCompress), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmOnDeCompress);
  DefineEventAdapter(TypeInfo(TkbmDeltaHandlerGetValue), TatkbmMemTableDispatcher, @TatkbmMemTableDispatcher.__TkbmDeltaHandlerGetValue);
  With Scripter.DefineClass(ClassType) do
  begin
    DefineMethod('StreamToVariant',1,tkVariant,nil,__StreamToVariant,false,0,'stream: TStream');
    DefineMethod('VariantToStream',2,tkNone,nil,__VariantToStream,false,0,'AVariant: variant; stream: TStream');
    DefineMethod('IndexOptions2CompareOptions',1,tkInteger,nil,__IndexOptions2CompareOptions,false,0,'AOptions: TIndexOptions');
    DefineMethod('CompareOptions2IndexOptions',1,tkInteger,nil,__CompareOptions2IndexOptions,false,0,'AOptions: TkbmMemTableCompareOptions');
    DefineMethod('CopyFieldDefs',2,tkNone,nil,__CopyFieldDefs,false,0,'Source: TFieldDefs; Dest: TFieldDefs');
    DefineProp('kbmSupportedFieldTypes',tkInteger,__GetkbmSupportedFieldTypes,nil,nil,false,0);
    DefineProp('kbmStringTypes',tkInteger,__GetkbmStringTypes,nil,nil,false,0);
    DefineProp('kbmBinaryTypes',tkInteger,__GetkbmBinaryTypes,nil,nil,false,0);
    DefineProp('kbmBlobTypes',tkInteger,__GetkbmBlobTypes,nil,nil,false,0);
    DefineProp('kbmNonBlobTypes',tkInteger,__GetkbmNonBlobTypes,nil,nil,false,0);
    DefineProp('kbmVarLengthNonBlobTypes',tkInteger,__GetkbmVarLengthNonBlobTypes,nil,nil,false,0);
    AddConstant('mtifoDescending',mtifoDescending);
    AddConstant('mtifoCaseInsensitive',mtifoCaseInsensitive);
    AddConstant('mtifoPartial',mtifoPartial);
    AddConstant('mtifoIgnoreNull',mtifoIgnoreNull);
    AddConstant('mtifoIgnoreLocale',mtifoIgnoreLocale);
    AddConstant('mtifoAggregate',mtifoAggregate);
    AddConstant('mtifoAggSum',mtifoAggSum);
    AddConstant('mtifoAggMin',mtifoAggMin);
    AddConstant('mtifoAggMax',mtifoAggMax);
    AddConstant('mtifoAggCount',mtifoAggCount);
    AddConstant('mtifoAggAvg',mtifoAggAvg);
    AddConstant('mtifoAggUsr1',mtifoAggUsr1);
    AddConstant('mtifoAggUsr2',mtifoAggUsr2);
    AddConstant('mtifoAggUsr3',mtifoAggUsr3);
    AddConstant('mtifoIgnoreNonSpace',mtifoIgnoreNonSpace);
    AddConstant('mtifoIgnoreKanatype',mtifoIgnoreKanatype);
    AddConstant('mtifoIgnoreSymbols',mtifoIgnoreSymbols);
    AddConstant('mtifoIgnoreWidth',mtifoIgnoreWidth);
    AddConstant('mtstDataSet',mtstDataSet);
    AddConstant('mtstStream',mtstStream);
    AddConstant('mtstBinaryStream',mtstBinaryStream);
    AddConstant('mtstFile',mtstFile);
    AddConstant('mtstBinaryFile',mtstBinaryFile);
    AddConstant('mtufEdit',mtufEdit);
    AddConstant('mtufAppend',mtufAppend);
    AddConstant('mtufDontClear',mtufDontClear);
    AddConstant('mtcoDescending',mtcoDescending);
    AddConstant('mtcoCaseInsensitive',mtcoCaseInsensitive);
    AddConstant('mtcoPartialKey',mtcoPartialKey);
    AddConstant('mtcoIgnoreNullKey',mtcoIgnoreNullKey);
    AddConstant('mtcoIgnoreLocale',mtcoIgnoreLocale);
    AddConstant('mtcoUnique',mtcoUnique);
    AddConstant('mtcoNonMaintained',mtcoNonMaintained);
    AddConstant('mtcpoStructure',mtcpoStructure);
    AddConstant('mtcpoOnlyActiveFields',mtcpoOnlyActiveFields);
    AddConstant('mtcpoProperties',mtcpoProperties);
    AddConstant('mtcpoLookup',mtcpoLookup);
    AddConstant('mtcpoCalculated',mtcpoCalculated);
    AddConstant('mtcpoAppend',mtcpoAppend);
    AddConstant('mtcpoFieldIndex',mtcpoFieldIndex);
    AddConstant('mtcpoDontDisableIndexes',mtcpoDontDisableIndexes);
    AddConstant('mtcpoIgnoreErrors',mtcpoIgnoreErrors);
    AddConstant('mtcpoLookupAsData',mtcpoLookupAsData);
    AddConstant('mtcpoCalculatedAsData',mtcpoCalculatedAsData);
    AddConstant('mtitNonSorted',mtitNonSorted);
    AddConstant('mtitSorted',mtitSorted);
    AddConstant('mtstFirst',mtstFirst);
    AddConstant('mtstLast',mtstLast);
    AddConstant('mtstNearestBefore',mtstNearestBefore);
    AddConstant('mtstNearestAfter',mtstNearestAfter);
    AddConstant('mtiuhInsert',mtiuhInsert);
    AddConstant('mtiuhEdit',mtiuhEdit);
    AddConstant('mtiuhDelete',mtiuhDelete);
    AddConstant('mtvm1SinceCheckPoint',mtvm1SinceCheckPoint);
    AddConstant('mtvmAllSinceCheckPoint',mtvmAllSinceCheckPoint);
    AddConstant('mtpcLoad',mtpcLoad);
    AddConstant('mtpcSave',mtpcSave);
    AddConstant('mtpcEmpty',mtpcEmpty);
    AddConstant('mtpcPack',mtpcPack);
    AddConstant('mtpcCheckPoint',mtpcCheckPoint);
    AddConstant('mtpcSearch',mtpcSearch);
    AddConstant('mtpcCopy',mtpcCopy);
    AddConstant('mtpcUpdate',mtpcUpdate);
    AddConstant('mtpcSort',mtpcSort);
    AddConstant('mtstBrowse',mtstBrowse);
    AddConstant('mtstLoad',mtstLoad);
    AddConstant('mtstSave',mtstSave);
    AddConstant('mtstEmpty',mtstEmpty);
    AddConstant('mtstPack',mtstPack);
    AddConstant('mtstCheckPoint',mtstCheckPoint);
    AddConstant('mtstSearch',mtstSearch);
    AddConstant('mtstUpdate',mtstUpdate);
    AddConstant('mtstSort',mtstSort);
    AddConstant('mtpfFast',mtpfFast);
    AddConstant('mtpfBalanced',mtpfBalanced);
    AddConstant('mtpfSmall',mtpfSmall);
    AddConstant('sfSaveData',sfSaveData);
    AddConstant('sfLoadData',sfLoadData);
    AddConstant('sfSaveCalculated',sfSaveCalculated);
    AddConstant('sfLoadCalculated',sfLoadCalculated);
    AddConstant('sfSaveLookup',sfSaveLookup);
    AddConstant('sfLoadLookup',sfLoadLookup);
    AddConstant('sfSaveNonVisible',sfSaveNonVisible);
    AddConstant('sfLoadNonVisible',sfLoadNonVisible);
    AddConstant('sfSaveBlobs',sfSaveBlobs);
    AddConstant('sfLoadBlobs',sfLoadBlobs);
    AddConstant('sfSaveDef',sfSaveDef);
    AddConstant('sfLoadDef',sfLoadDef);
    AddConstant('sfAutoLayoutDef',sfAutoLayoutDef);
    AddConstant('sfLoadByFieldNo',sfLoadByFieldNo);
    AddConstant('sfSaveIndexDef',sfSaveIndexDef);
    AddConstant('sfLoadIndexDef',sfLoadIndexDef);
    AddConstant('sfSaveFiltered',sfSaveFiltered);
    AddConstant('sfSaveIgnoreRange',sfSaveIgnoreRange);
    AddConstant('sfSaveIgnoreMasterDetail',sfSaveIgnoreMasterDetail);
    AddConstant('sfSaveDeltas',sfSaveDeltas);
    AddConstant('sfLoadDeltas',sfLoadDeltas);
    AddConstant('sfSaveDontFilterDeltas',sfSaveDontFilterDeltas);
    AddConstant('sfSaveAppend',sfSaveAppend);
    AddConstant('sfSaveInsert',sfSaveInsert);
    AddConstant('sfSaveFieldKind',sfSaveFieldKind);
    AddConstant('sfLoadFieldKind',sfLoadFieldKind);
    AddConstant('sfLoadFromStart',sfLoadFromStart);
    AddConstant('sfLoadDetermineWidth',sfLoadDetermineWidth);
    AddConstant('dlfBeforeLoad',dlfBeforeLoad);
    AddConstant('dlfAfterLoadDef',dlfAfterLoadDef);
    AddConstant('chBreakNE',chBreakNE);
    AddConstant('chBreakLT',chBreakLT);
    AddConstant('chBreakGT',chBreakGT);
    AddConstant('chBreakLTE',chBreakLTE);
    AddConstant('chBreakGTE',chBreakGTE);
    AddConstant('KBMMEMTABLE_VERSION',KBMMEMTABLE_VERSION);
    AddConstant('KBM_MAX_FIELDS',KBM_MAX_FIELDS);
    AddConstant('kbmkbMin',kbmkbMin);
    AddConstant('kbmkbKey',kbmkbKey);
    AddConstant('kbmkbRangeStart',kbmkbRangeStart);
    AddConstant('kbmkbRangeEnd',kbmkbRangeEnd);
    AddConstant('kbmkbMasterDetail',kbmkbMasterDetail);
    AddConstant('kbmkbMax',kbmkbMax);
    AddConstant('kbmffIndirect',kbmffIndirect);
    AddConstant('kbmffCompress',kbmffCompress);
    AddConstant('kbmffModified',kbmffModified);
    AddConstant('kbmRecordIdent',kbmRecordIdent);
    AddConstant('kbmBookmarkCurrent',kbmBookmarkCurrent);
    AddConstant('kbmBookmarkFirst',kbmBookmarkFirst);
    AddConstant('kbmBookmarkLast',kbmBookmarkLast);
    AddConstant('kbmGetRowsRest',kbmGetRowsRest);
    AddConstant('kbmffNull',kbmffNull);
    AddConstant('kbmffUnknown',kbmffUnknown);
    AddConstant('kbmffData',kbmffData);
    AddConstant('kbmRowOrderIndex',kbmRowOrderIndex);
    AddConstant('kbmDetailIndex',kbmDetailIndex);
    AddConstant('kbmGroupIndex',kbmGroupIndex);
    AddConstant('kbmDefSortIndex',kbmDefSortIndex);
    AddConstant('kbmDefaultIndex',kbmDefaultIndex);
    AddConstant('kbmRangeIndex',kbmRangeIndex);
    AddConstant('kbmAutoIndex',kbmAutoIndex);
    AddConstant('kbmrfInTable',kbmrfInTable);
    AddConstant('kbmrfDontCheckPoint',kbmrfDontCheckPoint);
    //AddConstant('NullVarLength',NullVarLength);
  end;
end;

class function TatkbmMemTableLibrary.LibraryName: string;
begin
  result := 'kbmMemTable';
end;

initialization
  RegisterScripterLibrary(TatkbmMemTableLibrary, True);

{$WARNINGS ON}

end.

