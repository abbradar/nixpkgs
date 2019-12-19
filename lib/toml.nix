{ lib }:

{
  # Converts given object to TOML text.
  toTOML =
    let
      toInlinePair = name: value: "${builtins.toJSON name} = ${toPlainTOMLValue value}";

      toPlainTOMLValue = value:
        if lib.isList value then
          if value == [] then "[]" else "[ ${lib.concatMapStringsSep ", " toPlainTOMLValue value} ]"
        else if lib.isAttrs value then
          if value == {} then "{}" else "{ ${lib.concatMapStringsSep ", " (lib.mapAttrsToList toInlinePair value)} }"
        else
          builtins.toJSON value;

      toPlainTOML = { name, value }: "${builtins.toJSON name} = ${toPlainTOMLValue value}";

      toGenericTableTOML = header: prefix: value:
        let
          insideTOML = toPrefixedTOML prefix value;
        in
          if insideTOML == "" then header else "${header}\n${insideTOML}";

      prefixHeader = prefix: lib.concatMapStringsSep "." builtins.toJSON prefix;

      toTableTOML = prefix: { name, value }:
        let
          newPrefix = prefix ++ [ name ];
          header = "[${prefixHeader newPrefix}]";
        in toGenericTableTOML header newPrefix value;

      toTableArrayTOML = prefix: { name, value }:
        let
          newPrefix = prefix ++ [ name ];
          header = "[[${prefixHeader newPrefix}]]";
        in lib.concatMapStringsSep "\n\n" (toGenericTableTOML header newPrefix) value;

      toPrefixedTOML = prefix: obj:
        let
          splitKeys1 = lib.partition (pair: lib.isAttrs pair.value) (lib.mapAttrsToList lib.nameValuePair obj);
          splitKeys2 = lib.partition (pair: lib.isList pair.value && pair.value != [] && lib.all lib.isAttrs pair.value) splitKeys1.wrong;

          plainAttrs = splitKeys2.wrong;
          tableAttrs = splitKeys1.right;
          tableArrayAttrs = splitKeys2.right;

          plainTOML = lib.concatMapStringsSep "\n" toPlainTOML plainAttrs;
          tableTOML = lib.concatMapStringsSep "\n\n" (toTableTOML prefix) tableAttrs;
          tableArrayTOML = lib.concatMapStringsSep "\n\n" (toTableArrayTOML prefix) tableArrayAttrs;

        in lib.concatStringsSep "\n\n" (
          lib.optional (plainAttrs != []) plainTOML
          ++ lib.optional (tableAttrs != []) tableTOML
          ++ lib.optional (tableArrayAttrs != []) tableArrayTOML
        );
    in toPrefixedTOML [];
}
