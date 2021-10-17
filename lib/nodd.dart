import "package:nyxx/nyxx.dart";
import "dart:io" show Platform, exit, sleep;

import 'package:nyxx_interactions/interactions.dart';

/**
方針：コマンドは推論型付きマクロ言語となるように構成したい(理想/できれば)
"@"　型注釈
":"　コマンド合成/プロパティ接続
"|"　並列実行
"+>"　逐次実行
"?"　nullable　T? = maybe[T] = or[T,null]
">"　右代入
"<"　左代入
"(" ")"　コマンドブロック

型関係：
anything
object << anything, null << anything
number << object,{x@number, y@number}:bind>frac << object,bool << object,string << object,regexp << object,
domain << object,path << object,uri << object,url << uri,
userid << object, twitterid << userid,discordid << userid,channelid << object,guilid << object,massageid << object,

ジェネリクス型：
or[T,U],iterator[T],iterator[K,V],result[R,E],maybe[T]

bind：
{el1,el2,el3}:bind>some
some:unbind>{el1,el2,el3}

詳細は ../docs/spec/lang.md

 */
void main(List<String> args) {
  final Map<String,String> envVars = Platform.environment;
  final String token = envVars["DISCORD_NODD_BOT_TOKEN"];
  if (token == null) {
    throw Exception(
        "Token is not difined. Please set `export DISCORD_NODD_BOT_TOKEN=<TOKEN>`");
  }
  final String guildId = envVars["DISCORD_NODD_GUILD_ID"];
  if (guildId == null) {
    throw Exception(
        "Guild ID is not difined. Please set `export DISCORD_NODD_GUILD_ID=<GUILD ID>`");
  }
  Nyxx bot = Nyxx(token, GatewayIntents.allUnprivileged);
  Interactions(bot)
    ..registerSlashCommand(SlashCommandBuilder(
        "neko",
        "Noddくんが生きているか判定します。",
        [
          CommandOptionBuilder(
              CommandOptionType.string, "text", "Noddくんに言わせるセリフ",
              required: false),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((event) {
        if (event.args.any((element) => element.name == "text")) {
          final String text = event.getArg("text").value.toString();
          final String catText = text.replaceAll("な", "にゃ");
          event.respond(MessageBuilder.content("${catText}にゃ"));
        } else {
          event.respond(MessageBuilder.content("にゃーん"));
        }
      }))
    ..registerSlashCommand(SlashCommandBuilder(
        "nick",
        "ニックネームを変更します。",
        [
          CommandOptionBuilder(
            CommandOptionType.string,
            "raw_nick",
            "新しいニックネーム",
          ),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((event) async {
        final rawNick = event.getArg("raw_nick").value.toString();
        if (RegExp(r'（Ｎｏ．[０-９]+）').hasMatch(rawNick)) {
          event.respond(MessageBuilder.content("そのニックネームには変更できません。"));
        } else {
          final Member author = event.interaction.memberAuthor!;
          final String scjId =
              RegExp(r'（Ｎｏ．[０-９]+）$').firstMatch(author.nickname!)!.group(0)!;
          final String newNick = rawNick + scjId;
          await author.edit(nick: newNick);
          event.respond(MessageBuilder.content("あなたのニックネームを $newNick に変更しました"));
        }
      ..registerSlashCommand(SlashCommandBuilder(
        "poll",
        "投票を開始します。",
        [
          CommandOptionBuilder(
              CommandOptionType.string, "title", "投票のタイトル",
              required: false),
          CommandOptionBuilder(
              CommandOptionType.role, "mention_r", "投票のためのメンション(ロール)",
              required: false),
          CommandOptionBuilder(
              CommandOptionType.user, "mention_m", "投票のためのメンション(メンバ)",
              required: false),
          CommandOptionBuilder(
              CommandOptionType.boolean, "only_mentioned", "投票可能な人をメンションした人に制限するかどうか",
              required: false),
          CommandOptionBuilder(
              CommandOptionType.string, "content", "投票の内容",
              required: true),
          CommandOptionBuilder(
              CommandOptionType.string, "image", "投票につける画像",
              required: false),
          CommandOptionBuilder(
              CommandOptionType.integer, "vote_max", "投票可能な最大数(デフォルトは1)",
              required: false),
          CommandOptionBuilder(
              CommandOptionType.subCommandGroup, "choice", "投票の選択肢",
              opions:
                CommandOptionBuilder(
                  CommandOptionType.string, "choice_1", "選択肢1",
                  required: true),
                CommandOptionBuilder(
                  CommandOptionType.string, "choice_2", "選択肢2",
                  required: true),
                CommandOptionBuilder(
                  CommandOptionType.string, "choice_3", "選択肢3",
                  required: false),
                CommandOptionBuilder(
                  CommandOptionType.string, "choice_4", "選択肢4",
                  required: false),
                CommandOptionBuilder(
                  CommandOptionType.string, "choice_5", "選択肢5",
                  required: false),
                CommandOptionBuilder(
                  CommandOptionType.string, "choice_6", "選択肢6",
                  required: false),
              required: true),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((SlashCommandInteractionEvent event) {
          EnbedBuilder enbeds = EnbedBuilder();
          late int maxVote;
          if (event.args.any((InteractionOption element) => element.name == "vote_max")){
            int temp = int.parse(event.getArg("vote_max").value.toString());
            if(temp > 0 && temp <= 6){
              maxVote = temp;
            }else{
              maxVote = 1;
            }
          }else{
            maxVote = 1
          }
          List<String> choices = {};
          int choiceNr = 2;
          choices.add(event.getArg("choice_1").value.toString());
          choices.add(event.getArg("choice_2").value.toString());
          if (event.args.any((InteractionOption element) => element.name == "choice_3")) {
            choices.add(event.getArg("choice_3").value.toString());
            choiceNr++;
          }
          if (event.args.any((InteractionOption element) => element.name == "choice_4")) {
            choices.add(event.getArg("choice_4").value.toString());
            choiceNr++;
          }
          if (event.args.any((InteractionOption element) => element.name == "choice_5")) {
            choices.add(event.getArg("choice_5").value.toString());
            choiceNr++;
          }
          if (event.args.any((InteractionOption element) => element.name == "choice_6")) {
            choices.add(event.getArg("choice_6").value.toString());
            choiceNr++;
          }
          List<EmbedFieldBuilder> retChoices = choices.indexedMap((int index, String choice)=>EmbedFieldBuilder(index, choice)).toList();
          enbeds.fields = retChoices;

          bool strict = false;
          if (event.args.any((InteractionOption element) => element.name == "only_mentioned")) {
            strict = bool.parse(event.getArg("only_mentioned").value.toString());
          }
          String content = "";
          if (event.args.any((InteractionOption element) => element.name == "mention_r")) {
            content += " ";
            content += event.getArg("mention_r").value.toString();
          }
          if (event.args.any((InteractionOption element) => element.name == "mention_m")) {
            content += " ";
            content += event.getArg("mention_m").value.toString();
          }
          if(content != ""){
            content += "\n";
          }
          content += event.getArg("content").value.toString();
          enbeds.description = content;
          final Member author = event.interaction.memberAuthor!;
          EmbedAuthorBuilder authorR = EmbedAuthorBuilder();
          authorR.iconUrl = author.avatarURL()!;
          authorR.name = author.nickname!;
          enbeds.author = authorR;
          if (event.args.any((InteractionOption element) => element.name == "image")) {
            enbeds.imageUrl = event.getArg("image").value.toString();
          }
          event.respond(MessageBuilder.enbed(enbeds));
      }))
    ..syncOnReady();
  final Map<String, String> prefixes = {
    "sl": "/",
    "ps": "%",
    "dl": "\$",
  };
  final String prefixKey = "ps";
  final String prefix = prefixes.containsKey(prefixKey) ? prefixes[prefixKey]! : "";

  bot.onReady.listen((ReadyEvent e) {
    print("Ready!");
  });
  bot.onMessageReceived.listen((MessageReceivedEvent event) {
    String commandThis = event.message.content.substring(prefix.length);
    String prefixThis = event.message.content.substring(0, prefix.length);
    if (prefixThis == prefix) {
      // コマンド実行(スラッシュコマンド以外)
      if (commandThis.startsWith("quit") ||
          commandThis.startsWith("exit") ||
          commandThis.startsWith("kill")) {
        IMessageAuthor at = event.message.author;
        String tag = at.tag;
        if(tag == "thd：佐藤陽花#7369" ||
           tag == "skytomo#9913"){
          event.message.channel
            .sendMessage(MessageBuilder.content("Nodd System Shutdown."));
          print("Nodd System Shutdown.");
          sleep(const Duration(seconds: 6));
          exit(0);
        }else{
          event.message.channel
            .sendMessage(MessageBuilder.content("Noddシステムをシャットダウンする権限がありません。"));
        }
      } else {
        event.message.channel
            .sendMessage(MessageBuilder.content("Pong: \n$commandThis"));
      }
    } else {
      //コマンド以外のメッセージ
    }
    print(event.message.content);
  });
}
extension IndexedMap<T, E> on List<T> {
  List<E> indexedMap<E>(E Function(int index, T item) function) {
    final list = <E>[];
    asMap().forEach((index, element) {
      list.add(function(index, element));
    });
    return list;
  }
}