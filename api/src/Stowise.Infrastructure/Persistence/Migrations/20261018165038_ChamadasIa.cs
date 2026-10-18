using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ChamadasIa : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "chamadas_ia",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    funcionalidade = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    usuario_id = table.Column<Guid>(type: "uuid", nullable: true),
                    provedor = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    modelo = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    prompt_versao = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    tokens_entrada = table.Column<int>(type: "integer", nullable: true),
                    tokens_saida = table.Column<int>(type: "integer", nullable: true),
                    custo_estimado = table.Column<decimal>(type: "numeric(18,6)", precision: 18, scale: 6, nullable: true),
                    latencia_ms = table.Column<int>(type: "integer", nullable: false),
                    tentativas = table.Column<int>(type: "integer", nullable: false),
                    usou_fallback = table.Column<bool>(type: "boolean", nullable: false),
                    sucesso = table.Column<bool>(type: "boolean", nullable: false),
                    erro = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    correlacao_id = table.Column<string>(type: "character varying(64)", maxLength: 64, nullable: true),
                    criada_em = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_chamadas_ia", x => x.id);
                    table.ForeignKey(
                        name: "fk_chamadas_ia_usuarios_usuario_id",
                        column: x => x.usuario_id,
                        principalTable: "usuarios",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "ix_chamadas_ia_funcionalidade_criada_em",
                table: "chamadas_ia",
                columns: new[] { "funcionalidade", "criada_em" });

            migrationBuilder.CreateIndex(
                name: "ix_chamadas_ia_usuario_id_criada_em",
                table: "chamadas_ia",
                columns: new[] { "usuario_id", "criada_em" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "chamadas_ia");
        }
    }
}
