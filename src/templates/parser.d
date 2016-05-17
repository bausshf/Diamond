module diamond.templates.parser;

import std.conv : to;
import std.algorithm : count;
import std.string : indexOf;

import diamond.templates.grammar;
import diamond.templates.contentmode;
import diamond.templates.characterincludemode;
import diamond.templates.part;

private {
  enum grammars = [
    '[' : new Grammar(
      "metadata", '[', ']',
      ContentMode.metaContent, CharacterIncludeMode.none, false, false
    ),

    '<' : new Grammar(
      "placeHolder", '<', '>',
      ContentMode.appendContent, CharacterIncludeMode.both, true, false
    ),

    '{' : new Grammar(
      "code", '{', '}',
      ContentMode.mixinContent, CharacterIncludeMode.none, false, false
    ),

    ':' : new Grammar(
      "expression", ':', '\n',
      ContentMode.mixinContent, CharacterIncludeMode.none, false, true
    ),

    '=' : new Grammar(
      "expressionValue", '=', ';',
      ContentMode.appendContent, CharacterIncludeMode.none, false, true
    ),

    '(' : new Grammar(
      "escapedValue", '(', ')',
      ContentMode.appendContent, CharacterIncludeMode.none, false, false
    ),

    '*' : new Grammar(
      "comment", '*', '*',
      ContentMode.discardContent, CharacterIncludeMode.none, false, true
    )
  ];
}

/**
* Parses a diamond template.
* Params:
*   content = The content of the diamond template to parse.
* Returns:
*   An array of the template parts.
*/
auto parseTemplate(string content) {
  Part[] parts;

  auto current = new Part;
  size_t curlyBracketCount = 0;
  size_t squareBracketcount = 0;
  size_t parenthesisCount = 0;

  foreach (ref i; 0 .. content.length) {
    auto beforeChar = i > 0 ? content[i - 1] : '\0';
    auto currentChar = content[i];
    auto afterChar = i < (content.length - 1) ? content[i + 1] : '\0';

    if (currentChar == '@' && !current.currentGrammar) {
      if (current._content && current._content.length && afterChar != '.') {
        parts ~= current;
        current = new Part;
      }

      if (afterChar != '@' && afterChar != '.') {
        auto grammar = grammars.get(afterChar, null);

        if (grammar && beforeChar != '@') {
          current.currentGrammar = grammar;

          if (afterChar == ':') {
            auto searchSource = content[i .. $];
            searchSource = searchSource[0 .. searchSource.indexOf('\n')];

            curlyBracketCount += searchSource.count!(c => c == '{');
            squareBracketcount += searchSource.count!(c => c == '[');
            parenthesisCount += searchSource.count!(c => c == '(');

            curlyBracketCount -= searchSource.count!(c => c == '}');
            squareBracketcount -= searchSource.count!(c => c == ']');
            parenthesisCount -= searchSource.count!(c => c == ')');

            if (curlyBracketCount > 0) {
              //current._content ~= "HERE ... CURLY";
            }

            if (squareBracketcount > 0) {
              //current._content ~= "HERE ... SQ";
            }

            if (parenthesisCount > 0) {
              //current._content ~= "HERE ... PARA";
            }
          }
        }
        else {
          current._content ~= currentChar;
        }
      }
      else if (afterChar == '.') {
        current._content ~= currentChar;
      }
    }
    else {
      if (current.currentGrammar) {
        if (currentChar == current.currentGrammar.startCharacter && (!current.currentGrammar.ignoreDepth || !current.isStart())) {
          current.increaseSeekIndex();

          if (current.isStart()) {
            continue;
          }
        }
        else if (currentChar == current.currentGrammar.endCharacter) {
          current.decreaseSeekIndex();
        }
      }

      if (current.isEnd(currentChar)) {
        // if (currentChar == '}') {
        //   curlyBracketCount--;
        // }
        // else if (squareBracketcount == ']') {
        //   squareBracketcount--;
        // }
        // else if (parenthesisCount == ')') {
        //   parenthesisCount--;
        // }

        switch (current.currentGrammar.characterIncludeMode) {
          case CharacterIncludeMode.start:
            current._content = to!string(current.currentGrammar.startCharacter) ~ current.content;
            break;

          case CharacterIncludeMode.end:
            current._content ~= current.currentGrammar.endCharacter;
            break;

          case CharacterIncludeMode.both:
            current._content = to!string(current.currentGrammar.startCharacter) ~ current.content ~ to!string(current.currentGrammar.endCharacter);
            break;

          default: break;
        }

        if (current.currentGrammar && current.currentGrammar.includeStatementCharacter) {
          current._content = "@" ~ current.content;
        }

        parts ~= current;
        current = new Part;
      }
      else {
        if (curlyBracketCount && currentChar == '}') {
          curlyBracketCount--;

          parts ~= current;

          current = new Part;
          current.currentGrammar = grammars.get('{', null);
          current._content = "}";
          parts ~= current;

          current = new Part;
        }
        else if (squareBracketcount && currentChar == ']') {
          squareBracketcount--;

          parts ~= current;

          current = new Part;
          current.currentGrammar = grammars.get('{', null);
          current._content = "]";
          parts ~= current;

          current = new Part;
        }
        else if (parenthesisCount && currentChar == ')') {
          parenthesisCount--;

          parts ~= current;

          current = new Part;
          current.currentGrammar = grammars.get('{', null);
          current._content = ")";
          parts ~= current;

          current = new Part;
        }
        else {
          current._content ~= currentChar;
        }
      }
    }
  }

  parts ~= current;

  return parts;
}
