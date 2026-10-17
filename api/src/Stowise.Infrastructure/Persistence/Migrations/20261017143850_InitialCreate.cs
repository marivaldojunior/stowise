using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Stowise.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterDatabase()
                .Annotation("Npgsql:PostgresExtension:vector", ",,");

            migrationBuilder.CreateTable(
                name: "armazens",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    codigo = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    nome = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_armazens", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "zonas",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    armazem_id = table.Column<Guid>(type: "uuid", nullable: false),
                    codigo = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    classe_armazenagem = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_zonas", x => x.id);
                    table.ForeignKey(
                        name: "fk_zonas_armazens_armazem_id",
                        column: x => x.armazem_id,
                        principalTable: "armazens",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "enderecos",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    zona_id = table.Column<Guid>(type: "uuid", nullable: false),
                    codigo = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    rua = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    modulo = table.Column<int>(type: "integer", nullable: false),
                    nivel = table.Column<int>(type: "integer", nullable: false),
                    posicao = table.Column<int>(type: "integer", nullable: false),
                    capacidade_peso_kg = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    altura_cm = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    largura_cm = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    profundidade_cm = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    distancia_expedicao = table.Column<decimal>(type: "numeric(18,4)", precision: 18, scale: 4, nullable: false),
                    status = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    motivo_bloqueio = table.Column<string>(type: "character varying(250)", maxLength: 250, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_enderecos", x => x.id);
                    table.ForeignKey(
                        name: "fk_enderecos_zonas_zona_id",
                        column: x => x.zona_id,
                        principalTable: "zonas",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "ix_armazens_codigo",
                table: "armazens",
                column: "codigo",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_enderecos_status",
                table: "enderecos",
                column: "status");

            migrationBuilder.CreateIndex(
                name: "ix_enderecos_zona_id_codigo",
                table: "enderecos",
                columns: new[] { "zona_id", "codigo" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_zonas_armazem_id_codigo",
                table: "zonas",
                columns: new[] { "armazem_id", "codigo" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "enderecos");

            migrationBuilder.DropTable(
                name: "zonas");

            migrationBuilder.DropTable(
                name: "armazens");
        }
    }
}
