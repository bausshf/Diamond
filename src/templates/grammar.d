module diamond.templates.grammar;

import diamond.templates.contentmode;
import diamond.templates.characterincludemode;

/// A wrapper around the basic template grammar for parsing a diamond template.
final class Grammar {
  private:
  /// The name.
  immutable(string) _name;
  /// The start character.
  immutable(char) _startCharacter;
  /// The end character.
  immutable(char) _endCharacter;
  /// The content mode.
  ContentMode _contentMode;
  /// The character include mode.
  CharacterIncludeMode _characterIncludeMode;
  /// Boolean determining whether the statement character should be included.
  immutable(bool) _includeStatementCharacter;
  /// Boolean determining whether the grammar should ignore depth of characters or not.
  immutable(bool) _ignoreDepth;

  public:
  final:
  /**
  * Creates a new template grammar.
  * Params:
  *   name =            The name of the grammar.
  *   startCharacter =  The start character.
  *   endCharacter =    The end character.
  *   contentMode =               The content mode.
  *   characterIncludeMode =      The character include mode.
  *   includeStatementCharacter = Boolean determining whether the statement character should be included.
  */
  this(string name, char startCharacter, char endCharacter, ContentMode contentMode, CharacterIncludeMode characterIncludeMode, bool includeStatementCharacter, bool ignoreDepth) {
    _name = cast(immutable)name;
    _startCharacter = cast(immutable)startCharacter;
    _endCharacter = cast(immutable)endCharacter;
    _contentMode = contentMode;
    _characterIncludeMode = characterIncludeMode;
    _includeStatementCharacter = cast(immutable)includeStatementCharacter;
    _ignoreDepth = cast(immutable)ignoreDepth;
  }

  @property {
    /// Gets the name.
    auto name() { return _name; }

    /// Gets the start character.
    auto startCharacter() { return _startCharacter; }

    /// Gets the end character.
    auto endCharacter() { return _endCharacter; }

    /// Gets the content mode.
    auto contentMode() { return _contentMode; }

    /// Gets the character include mode.
    auto characterIncludeMode() { return _characterIncludeMode; }

    /// Gets a boolean determining whether the statement character should be included.
    auto includeStatementCharacter() { return _includeStatementCharacter; }

    /// Gets a boolean determining whether the grammar should ignore depth or not.
    auto ignoreDepth() { return _ignoreDepth; }
  }
}
