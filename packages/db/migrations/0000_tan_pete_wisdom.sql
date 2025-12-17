CREATE TABLE "cohorts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"organization_id" uuid NOT NULL,
	"program_id" uuid NOT NULL,
	"name" text NOT NULL,
	"start_date" timestamp,
	"end_date" timestamp,
	"max_participants" integer,
	"status" text DEFAULT 'draft',
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "enrollments" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"organization_id" uuid NOT NULL,
	"person_id" uuid NOT NULL,
	"program_id" uuid NOT NULL,
	"cohort_id" uuid,
	"status" text DEFAULT 'applied',
	"application_data" jsonb DEFAULT '{}'::jsonb,
	"applied_at" timestamp DEFAULT now(),
	"enrolled_at" timestamp,
	"completed_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "organizations" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"slug" text NOT NULL,
	"config" jsonb DEFAULT '{}'::jsonb,
	"integrations" jsonb DEFAULT '{}'::jsonb,
	"is_active" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "organizations_slug_unique" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "people" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"organization_id" uuid NOT NULL,
	"first_name" text NOT NULL,
	"last_name" text NOT NULL,
	"email" text,
	"phone" text,
	"status" text DEFAULT 'pending',
	"metadata" jsonb DEFAULT '{}'::jsonb,
	"tags" text[] DEFAULT '{}',
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "programs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"organization_id" uuid NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"type" text,
	"config" jsonb DEFAULT '{}'::jsonb,
	"is_active" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "cohorts" ADD CONSTRAINT "cohorts_organization_id_organizations_id_fk" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "cohorts" ADD CONSTRAINT "cohorts_program_id_programs_id_fk" FOREIGN KEY ("program_id") REFERENCES "public"."programs"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enrollments" ADD CONSTRAINT "enrollments_organization_id_organizations_id_fk" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enrollments" ADD CONSTRAINT "enrollments_program_id_programs_id_fk" FOREIGN KEY ("program_id") REFERENCES "public"."programs"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "enrollments" ADD CONSTRAINT "enrollments_cohort_id_cohorts_id_fk" FOREIGN KEY ("cohort_id") REFERENCES "public"."cohorts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "people" ADD CONSTRAINT "people_organization_id_organizations_id_fk" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "programs" ADD CONSTRAINT "programs_organization_id_organizations_id_fk" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "cohorts_org_idx" ON "cohorts" USING btree ("organization_id");--> statement-breakpoint
CREATE INDEX "cohorts_program_idx" ON "cohorts" USING btree ("program_id");--> statement-breakpoint
CREATE INDEX "enrollments_org_idx" ON "enrollments" USING btree ("organization_id");--> statement-breakpoint
CREATE INDEX "enrollments_person_idx" ON "enrollments" USING btree ("person_id");--> statement-breakpoint
CREATE INDEX "enrollments_program_idx" ON "enrollments" USING btree ("program_id");--> statement-breakpoint
CREATE INDEX "people_org_idx" ON "people" USING btree ("organization_id");--> statement-breakpoint
CREATE INDEX "people_email_idx" ON "people" USING btree ("email");--> statement-breakpoint
CREATE INDEX "people_status_idx" ON "people" USING btree ("organization_id","status");--> statement-breakpoint
CREATE INDEX "programs_org_idx" ON "programs" USING btree ("organization_id");