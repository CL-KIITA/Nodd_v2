// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps, prefer_const_declarations, avoid_print, avoid_shadowing_type_parameters, slash_for_doc_comments
// ignore: todo
// TODO: Delete ignore_for_file

import 'package:nodd/number_manager.dart';
import "package:nyxx/nyxx.dart";
import "dart:io" show Platform, exit, sleep;

import 'package:nyxx_interactions/interactions.dart';

void main(List<String> args) {
  final scjNumberFormat = RegExp(r'#\d{4}$');
  final Map<String, String> envVars = Platform.environment;
  final String? token = envVars["DISCORD_NODD_BOT_TOKEN"];
  if (token == null) {
    throw Exception(
        "Token is not defined. Please set `export DISCORD_NODD_BOT_TOKEN=<TOKEN>`");
  }
  final String? guildId = envVars["DISCORD_NODD_GUILD_ID"];
  if (guildId == null) {
    throw Exception(
        "Guild ID is not defined. Please set `export DISCORD_NODD_GUILD_ID=<GUILD ID>`");
  }
  final String? projectId = envVars["DISCORD_NODD_PROJECT_ID"];
  if (projectId == null) {
    throw Exception(
        "Project ID is not defined. Please set `export DISCORD_NODD_PROJECT_ID=<PROJECT ID>`");
  }
  final String? privateKeyId = envVars["DISCORD_NODD_PRIVATE_KEY_ID"];
  if (privateKeyId == null) {
    throw Exception(
        "Private key ID is not defined. Please set `export DISCORD_NODD_PRIVATE_KEY_ID=<PRIVATE KEY ID>`");
  }
  final String? privateKey = envVars["DISCORD_NODD_PRIVATE_KEY"];
  if (privateKey == null) {
    throw Exception(
        "Private key is not defined. Please set `export DISCORD_NODD_PRIVATE_KEY=<PRIVATE KEY>`");
  }
  final String? clientEmail = envVars["DISCORD_NODD_CLIENT_EMAIL"];
  if (clientEmail == null) {
    throw Exception(
        "Client E-mail is not defined. Please set `export DISCORD_NODD_CLIENT_EMAIL=<CLIENT EMAIL>`");
  }
  final String? clientId = envVars["DISCORD_NODD_CLIENT_ID"];
  if (clientId == null) {
    throw Exception(
        "Client ID is not defined. Please set `export DISCORD_NODD_CLIENT_ID=<CLIENT ID>`");
  }
  final String? clientX509CertUrl =
      envVars["DISCORD_NODD_CLIENT_X509_CERT_URL"];
  if (clientX509CertUrl == null) {
    throw Exception(
        "The URL of the public x509 certificate is not defined. Please set `export DISCORD_NODD_CLIENT_X509_CERT_URL=<CLIENT X509 CERT URL>`");
  }
  final String? spreadsheetId = envVars["DISCORD_NODD_SPREADSHEET_ID"];
  if (spreadsheetId == null) {
    throw Exception(
        "Spreadsheet ID is not defined. Please set `export DISCORD_NODD_SPREADSHEET_ID=<SPREADSHEET ID>`");
  }
  final credentials = '''
{
  "type": "service_account",
  "project_id": "$projectId",
  "private_key_id": "$privateKeyId",
  "private_key": "$privateKey",
  "client_email": "$clientEmail",
  "client_id": "$clientId",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "$clientX509CertUrl"
}
''';
  final numberManager = NumberManager(credentials, spreadsheetId);
  Nyxx bot = Nyxx(token, GatewayIntents.allUnprivileged);
  Interactions(bot)
    ..registerSlashCommand(SlashCommandBuilder(
        "neko",
        "Nodd?????????????????????????????????????????????",
        [
          CommandOptionBuilder(
              CommandOptionType.string, "text", "Nodd??????????????????????????????",
              required: false),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((event) {
        if (event.args.any((element) => element.name == "text")) {
          final String text = event.getArg("text").value.toString();
          final String catText = text.replaceAll("???", "??????");
          event.respond(MessageBuilder.content("${catText}??????"));
        } else {
          event.respond(MessageBuilder.content("????????????"));
        }
      }))
    ..registerSlashCommand(SlashCommandBuilder(
        "nick",
        "???????????????????????????????????????",
        [
          CommandOptionBuilder(
              CommandOptionType.string, "raw_nick", "???????????????????????????",
              required: true),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((event) async {
        final rawNick = event.getArg("raw_nick").value.toString();
        if (rawNick.length > 27) {
          event.respond(MessageBuilder.content(
              "????????????????????????????????? ${rawNick.length} ???????????????????????????????????????????????????27???????????????"));
          return;
        }

        final Member author = event.interaction.memberAuthor!;
        final match = scjNumberFormat.firstMatch(author.nickname!);
        final String scjId = (match == null)
            ? '#${(await numberManager.register(event.interaction.memberAuthor!.id.id))}'
            : match.group(0)!;
        final String newNick = rawNick + scjId;
        await author.edit(nick: newNick);
        event.respond(MessageBuilder.content("????????????????????????????????? $newNick ?????????????????????"));
      }))
    ..registerSlashCommand(SlashCommandBuilder(
        "number",
        "SCJ???????????????????????????????????????????????????????????????",
        [
          CommandOptionBuilder(
              CommandOptionType.string, "user_id", "????????????????????????ID",
              required: true
          ),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((event) async {
        final userId = event.getArg("user_id").value.toString();
        final guild = await event.interaction.guild?.getOrDownload();
        final member = await guild?.fetchMember(Snowflake(userId));
        if (member == null) {
          event.respond(MessageBuilder.content("??????ID????????????????????????????????????????????????????????????"));
          return;
        }
        final user = await member.user.getOrDownload();
        if (user.bot) return;
        final nickname = (member.nickname ?? user.username)
            .replaceAll(scjNumberFormat, '');
        final match = scjNumberFormat.firstMatch(nickname);
        final String scjId = (match == null)
            ? '#${(await numberManager.register(member.id.id))}'
            : match.group(0)!;
        final String newNick = nickname + scjId;
        await member.edit(nick: newNick);
        event.respond(MessageBuilder.content("$nickname ????????? $newNick ?????????????????????"));
      }))
    ..registerSlashCommand(SlashCommandBuilder(
        "poll",
        "???????????????????????????",
        [
          CommandOptionBuilder(CommandOptionType.string, "title", "?????????????????????",
              required: false),
          CommandOptionBuilder(
              CommandOptionType.role, "mention_r", "?????????????????????????????????(?????????)",
              required: false),
          CommandOptionBuilder(
              CommandOptionType.user, "mention_m", "?????????????????????????????????(?????????)",
              required: false),
          CommandOptionBuilder(CommandOptionType.boolean, "only_mentioned",
              "????????????????????????????????????????????????????????????????????????",
              required: false),
          CommandOptionBuilder(CommandOptionType.string, "content", "???????????????",
              required: true),
          CommandOptionBuilder(CommandOptionType.string, "image", "????????????????????????",
              required: false),
          CommandOptionBuilder(
              CommandOptionType.integer, "vote_max", "????????????????????????(??????????????????1)",
              required: false),
          CommandOptionBuilder(
              CommandOptionType.subCommandGroup, "choice", "??????????????????",
              options: [
                CommandOptionBuilder(
                    CommandOptionType.string, "choice_1", "?????????1",
                    required: true),
                CommandOptionBuilder(
                    CommandOptionType.string, "choice_2", "?????????2",
                    required: true),
                CommandOptionBuilder(
                    CommandOptionType.string, "choice_3", "?????????3",
                    required: false),
                CommandOptionBuilder(
                    CommandOptionType.string, "choice_4", "?????????4",
                    required: false),
                CommandOptionBuilder(
                    CommandOptionType.string, "choice_5", "?????????5",
                    required: false),
                CommandOptionBuilder(
                    CommandOptionType.string, "choice_6", "?????????6",
                    required: false),
              ],
              required: true),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((SlashCommandInteractionEvent event) {
        EmbedBuilder enbeds = EmbedBuilder();
        late int maxVote;
        if (event.args
            .any((InteractionOption element) => element.name == "vote_max")) {
          int temp = int.parse(event.getArg("vote_max").value.toString());
          if (temp > 0 && temp <= 6) {
            maxVote = temp;
          } else {
            maxVote = 1;
          }
        } else {
          maxVote = 1;
        }
        List<String> choices = {} as List<String>;
        int choiceNr = 2;
        choices.add(event.getArg("choice_1").value.toString());
        choices.add(event.getArg("choice_2").value.toString());
        if (event.args
            .any((InteractionOption element) => element.name == "choice_3")) {
          choices.add(event.getArg("choice_3").value.toString());
          choiceNr++;
        }
        if (event.args
            .any((InteractionOption element) => element.name == "choice_4")) {
          choices.add(event.getArg("choice_4").value.toString());
          choiceNr++;
        }
        if (event.args
            .any((InteractionOption element) => element.name == "choice_5")) {
          choices.add(event.getArg("choice_5").value.toString());
          choiceNr++;
        }
        if (event.args
            .any((InteractionOption element) => element.name == "choice_6")) {
          choices.add(event.getArg("choice_6").value.toString());
          choiceNr++;
        }
        List<EmbedFieldBuilder> retChoices = choices
            .indexedMap(
                (int index, String choice) => EmbedFieldBuilder(index, choice))
            .toList();
        enbeds.fields = retChoices;

        bool strict = false;
        if (event.args.any(
            (InteractionOption element) => element.name == "only_mentioned")) {
          strict = event.getArg("only_mentioned") as bool;
        }
        String content = "";
        if (event.args
            .any((InteractionOption element) => element.name == "mention_r")) {
          content += " ";
          content += event.getArg("mention_r").value.toString();
        }
        if (event.args
            .any((InteractionOption element) => element.name == "mention_m")) {
          content += " ";
          content += event.getArg("mention_m").value.toString();
        }
        if (content != "") {
          content += "\n";
        }
        content += event.getArg("content").value.toString();
        enbeds.description = content;
        final Member author = event.interaction.memberAuthor!;
        EmbedAuthorBuilder authorR = EmbedAuthorBuilder();
        authorR.iconUrl = author.avatarURL()!;
        authorR.name = author.nickname!;
        enbeds.author = authorR;
        if (event.args
            .any((InteractionOption element) => element.name == "image")) {
          enbeds.imageUrl = event.getArg("image").value.toString();
        }
        event.respond(MessageBuilder.embed(enbeds));
      }))
    ..syncOnReady();

  final Map<String, String> prefixes = {
    "sl": "/",
    "ps": "%",
    "dl": "\$",
  };
  final String prefixKey = "ps";
  final String prefix =
      prefixes.containsKey(prefixKey) ? prefixes[prefixKey]! : "";

  bot.onReady.listen((ReadyEvent e) {
    print("Ready!");
  });
  bot.onMessageReceived.listen((MessageReceivedEvent event) {
    String commandThis = event.message.content.substring(prefix.length);
    String prefixThis = event.message.content.substring(0, prefix.length);
    if (prefixThis == prefix) {
      // ??????????????????(?????????????????????????????????)
      if (commandThis.startsWith("quit") ||
          commandThis.startsWith("exit") ||
          commandThis.startsWith("kill")) {
        IMessageAuthor at = event.message.author;
        String tag = at.tag;
        if (tag == "thd???????????????#7369" || tag == "skytomo#9913") {
          event.message.channel
              .sendMessage(MessageBuilder.content("Nodd System Shutdown."));
          print("Nodd System Shutdown.");
          sleep(const Duration(seconds: 6));
          exit(0);
        } else {
          event.message.channel.sendMessage(
              MessageBuilder.content("Nodd?????????????????????????????????????????????????????????????????????"));
        }
      } else {
        event.message.channel
            .sendMessage(MessageBuilder.content("Pong: \n$commandThis"));
      }
    } else {
      //????????????????????????????????????
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
