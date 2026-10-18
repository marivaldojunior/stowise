using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddImportacoes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "importacoes",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    tipo = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    formato = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    nome_arquivo = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    hash_arquivo = table.Column<string>(type: "character(64)", fixedLength: true, maxLength: 64, nullable: false),
                    tamanho_bytes = table.Column<long>(type: "bigint", nullable: false),
                    encoding = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    delimitador = table.Column<string>(type: "character varying(1)", maxLength: 1, nullable: true),
                    separador_decimal = table.Column<string>(type: "character varying(1)", maxLength: 1, nullable: false),
                    tem_cabecalho = table.Column<bool>(type: "boolean", nullable: false),
                    colunas = table.Column<string>(type: "jsonb", nullable: false),
                    amostra = table.Column<string>(type: "jsonb", nullable: false),
                    total_linhas = table.Column<int>(type: "integer", nullable: false),
                    status = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    usuario_id = table.Column<Guid>(type: "uuid", nullable: false),
                    iniciado_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    concluido_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_importacoes", x => x.id);
                    table.ForeignKey(
                        name: "fk_importacoes_usuarios_usuario_id",
                        column: x => x.usuario_id,
                        principalTable: "usuarios",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "importacao_arquivos",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    importacao_id = table.Column<Guid>(type: "uuid", nullable: false),
                    conteudo = table.Column<byte[]>(type: "bytea", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_importacao_arquivos", x => x.id);
                    table.ForeignKey(
                        name: "fk_importacao_arquivos_importacoes_importacao_id",
                        column: x => x.importacao_id,
                        principalTable: "importacoes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_importacao_arquivos_importacao_id",
                table: "importacao_arquivos",
                column: "importacao_id",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_importacoes_iniciado_em",
                table: "importacoes",
                column: "iniciado_em");

            migrationBuilder.CreateIndex(
                name: "ix_importacoes_tipo_hash_arquivo",
                table: "importacoes",
                columns: new[] { "tipo", "hash_arquivo" },
                unique: true,
                filter: "status <> 'Falhou'");

            migrationBuilder.CreateIndex(
                name: "ix_importacoes_usuario_id",
                table: "importacoes",
                column: "usuario_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "importacao_arquivos");

            migrationBuilder.DropTable(
                name: "importacoes");
        }
    }
}
