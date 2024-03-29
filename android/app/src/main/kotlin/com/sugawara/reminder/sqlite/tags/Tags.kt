package com.sugawara.reminder.sqlite.tags

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.util.Log
import java.lang.Exception
import com.sugawara.reminder.sqlite.DBEnv

class Tags {
    /**
     * カーソルからデータを取得
     *
     * @param {cur}: Cursor データベースから取得したCursor
     * @param {columnName}: カラム名
     *
     * @return {res}: Any? IntかStringかNullのデータ
     * */
    private fun getData(
        cur: Cursor,
        columnName: String,
    ): Any? {
        val index: Int = cur.getColumnIndex(columnName)
        if (index < 0) return null

        if (columnName == TagsHelper.idKey) {
            return cur.getInt(index)
        } else if (
            columnName == TagsHelper.createdAtKey ||
            columnName == TagsHelper.updatedAtKey
        ) {
            return cur.getLong(index)
        }
         else if (columnName == TagsHelper.tagKey) {
            return cur.getString(index)
        }
        return null
    }

    /**
     * MapをArray<String>に変換
     *
     * @param {map}: Map<String, String> 変換したいMap
     *
     * @return {res}: Array<String> 変換後のArray
     */
    fun mapToArray(map: Map<String, String>?): Array<String>? {
        if(map == null) return null
        return map.values.toList().toTypedArray()
    }

    /**
     * SELECT文
     *
     * @param {context}:    Context          コンテキスト
     * @param {columns}:    Array<String>    カラム名のリスト
     * @param {where}:      String?          WHERE句
     * @param {whereArgs}:  Array<String>?   WHERE句のプレースホルダに入れる値
     * @param {orderBy}:    String?          並び替え
     * @param {limit}:      Int?             取得する行数
     *
     * @return {res}:       ArrayList<Map<String, Any?>>?  取得したデータ
     * */
    fun select(
        context: Context,
        columns: Array<String>,
        where: String?,
        whereArgs: Array<String>?,
        groupBy: String?,
        having: String?,
        orderBy: String?,
        limit: String?,
    ): ArrayList<Map<String, Any?>>? {
        try {
            val res: ArrayList<Map<String,Any?>> = arrayListOf()
            val tagsHelper = TagsHelper(context, DBEnv.dbName, null, TagsHelper.version);
            val db = tagsHelper.readableDatabase

            val cur =
                db.query(
                    TagsHelper.tableName,
                    columns,
                    where,
                    whereArgs,
                    groupBy,
                    having,
                    orderBy,
                    limit
                )
            if (cur.count > 0) {
                cur.moveToFirst()
                while (!cur.isAfterLast) {
                    var idIndex         = cur.getColumnIndex(TagsHelper.idKey)
                    var tagIndex      = cur.getColumnIndex(TagsHelper.tagKey)
                    var createdAtIndex  = cur.getColumnIndex(TagsHelper.createdAtKey)
                    var updatedAtIndex  = cur.getColumnIndex(TagsHelper.updatedAtKey)

                    var id:             Int?    = null
                    var tag:            String? = null
                    var createdAt:      Long?   = null
                    var updatedAt:      Long?   = null

                    if (idIndex >= 0) {
                        id = cur.getInt(idIndex)
                    }
                    if (tagIndex >= 0) {
                        tag = cur.getString(tagIndex)
                    }
                    if (createdAtIndex >= 0) {
                        createdAt = cur.getLong(createdAtIndex)
                    }
                    if (updatedAtIndex >= 0) {
                        updatedAt = cur.getLong(updatedAtIndex)
                    }

                    res.add(
                        mapOf(
                            TagsHelper.idKey              to id,
                            TagsHelper.tagKey           to tag,
                            TagsHelper.createdAtKey       to createdAt,
                            TagsHelper.updatedAtKey       to updatedAt,
                        )
                    )
                    cur.moveToNext()
                }
            }
            db.close()
            return res
        } catch (e: Exception) {
            Log.e("select data", e.toString())
            return null
        }
    }

    /**
     * INSERT文
     *
     * @param {context}: Context
     * @param {values}: ContentValues? 挿入したいデータ(Notificationsにあるカラムを全て定義)
     *
     * @return {num}: Long 挿入した行のID。挿入できなかった場合は-1
     * */
    fun insert(
        context: Context,
        values: ContentValues?,
    ): Long {
        try {
            val tagsHelper = TagsHelper(context, DBEnv.dbName, null, TagsHelper.version);
            val db = tagsHelper.writableDatabase
            val num = db.insert(DBEnv.dbName, null, values)
            db.close()
            return num
        } catch (e: Exception) {
            Log.e("insert data", e.toString())
            return -1
        }
    }

    /**
     * UPDATE文
     *
     * @param {context}: Context
     * @param {values}: ContentValues? 更新するデータ
     * @param {whereClause}: String? WHERE句
     * @param {whereArgs}: Array<String>? WHERE句のプレースホルダに入れる値
     *
     * @return {num}: Int 更新した行数
     * */
    fun update(
        context: Context,
        values: ContentValues?,
        whereClause: String?,
        whereArgs: Array<String>?,
    ): Int {
        try {
            val tagsHelper = TagsHelper(context, DBEnv.dbName, null, TagsHelper.version)
            val db = tagsHelper.writableDatabase
            val num = db.update(TagsHelper.tableName, values, whereClause, whereArgs)
            db.close()
            return num
        } catch (e: Exception) {
            Log.e("update data", e.toString())
            return -1
        }
    }

    /**
     * DELETE文
     *
     * @param {context}: Context
     * @param {whereClause}: String? WHERE句
     * @param {whereArgs}: Array<String?>? WHERE句のプレースホルダに入れる値
     *
     * @return {num}: Int 削除した行数
     * */
    fun delete(
        context: Context,
        whereClause: String?,
        whereArgs: Array<String>?,
    ): Int {
        try {
            val tagsHelper = TagsHelper(context, DBEnv.dbName, null, TagsHelper.version)
            val db = tagsHelper.writableDatabase
            val num = db.delete(TagsHelper.tableName, whereClause, whereArgs)
            db.close()
            return num
        } catch (e: Exception) {
            Log.e("delete data", e.toString())
            return -1
        }
    }
}
