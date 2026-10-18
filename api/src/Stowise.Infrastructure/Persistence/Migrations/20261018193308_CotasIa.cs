using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class CotasIa : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "cotas_ia",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    perfil = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: true),
                    usuario_id = table.Column<Guid>(type: "uuid", nullable: true),
                    funcionalidade = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: true),
                    limite_chamadas_dia = table.Column<int>(type: "integer", nullable: true),
                    limite_tokens_mes = table.Column<long>(type: "bigint", nullable: true),
                    xmin = table.Column<uint>(type: "xid", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_cotas_ia", x => x.id);
                    table.CheckConstraint("ck_cotas_ia_perfil_ou_usuario", "(perfil IS NULL) <> (usuario_id IS NULL)");
                    table.ForeignKey(
                        name: "fk_cotas_ia_usuarios_usuario_id",
                        column: x => x.usuario_id,
                        principalTable: "usuarios",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "cotas_ia",
                columns: new[] { "id", "funcionalidade", "limite_chamadas_dia", "limite_tokens_mes", "perfil", "usuario_id" },
                values: new object[,]
                {
                    { new Guid("0199f0a0-0000-7000-8000-00000000c001"), null, 200, 2000000L, "Gestor", null },
                    { new Guid("0199f0a0-0000-7000-8000-00000000c002"), null, 50, 500000L, "Operador", null }
                });

            migrationBuilder.CreateIndex(
                name: "ix_cotas_ia_perfil_funcionalidade",
                table: "cotas_ia",
                columns: new[] { "perfil", "funcionalidade" },
                unique: true,
                filter: "perfil IS NOT NULL")
                .Annotation("Npgsql:NullsDistinct", false);

            migrationBuilder.CreateIndex(
                name: "ix_cotas_ia_usuario_id_funcionalidade",
                table: "cotas_ia",
                columns: new[] { "usuario_id", "funcionalidade" },
                unique: true,
                filter: "usuario_id IS NOT NULL")
                .Annotation("Npgsql:NullsDistinct", false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "cotas_ia");
        }
    }
}
